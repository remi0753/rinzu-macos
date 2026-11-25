#define _POSIX_C_SOURCE 200809L

#include <errno.h>
#include <signal.h>
#include <spawn.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

extern char **environ;

static volatile sig_atomic_t interrupted;

static void remember_signal(int signal) {
  interrupted = signal;
}

static long long milliseconds(void) {
  struct timespec now;
  clock_gettime(CLOCK_MONOTONIC, &now);
  return (long long)now.tv_sec * 1000 + now.tv_nsec / 1000000;
}

static int supervise(pid_t child, long seconds, const char *command) {
  long long deadline = milliseconds() + seconds * 1000;
  int result = 0;
  for (;;) {
    siginfo_t info = {0};
    if (waitid(P_PID, child, &info, WEXITED | WNOHANG | WNOWAIT) < 0 && errno != EINTR) {
      perror("waitid");
      result = 125;
      break;
    }
    if (interrupted) {
      result = 128 + interrupted;
      break;
    }
    if (info.si_pid == child)
      break;
    if (milliseconds() >= deadline) {
      fprintf(stderr, "Command timed out (limit %ld s): %s\n", seconds, command);
      result = 124;
      break;
    }
    struct timespec pause = {.tv_nsec = 10000000};
    nanosleep(&pause, NULL);
  }

  // Keep the group leader unreaped until its remaining processes have been signalled.
  kill(-child, SIGKILL);
  int status;
  while (waitpid(child, &status, 0) < 0) {
    if (errno != EINTR) {
      perror("waitpid");
      return 125;
    }
  }
  if (result)
    return result;
  return WIFEXITED(status) ? WEXITSTATUS(status) : 128 + WTERMSIG(status);
}

int main(int argc, char **argv) {
  char *end = NULL;
  long seconds = argc >= 3 ? strtol(argv[1], &end, 10) : 0;
  if (seconds < 1 || seconds > 86400 || *end) {
    fprintf(stderr, "Usage: %s SECONDS COMMAND [ARGS...]\n", argv[0]);
    return 2;
  }

  struct sigaction action = {.sa_handler = remember_signal};
  sigemptyset(&action.sa_mask);
  if (sigaction(SIGHUP, &action, NULL) < 0 || sigaction(SIGINT, &action, NULL) < 0 ||
      sigaction(SIGTERM, &action, NULL) < 0) {
    perror("sigaction");
    return 125;
  }

  posix_spawnattr_t attributes;
  int error = posix_spawnattr_init(&attributes);
  if (error) {
    fprintf(stderr, "posix_spawnattr_init: %s\n", strerror(error));
    return 125;
  }
  pid_t child;
  error = posix_spawnattr_setflags(&attributes, POSIX_SPAWN_SETPGROUP);
  if (!error)
    error = posix_spawnattr_setpgroup(&attributes, 0);
  if (!error)
    error = posix_spawnp(&child, argv[2], NULL, &attributes, argv + 2, environ);
  posix_spawnattr_destroy(&attributes);
  if (error) {
    fprintf(stderr, "Could not launch %s: %s\n", argv[2], strerror(error));
    return error == ENOENT ? 127 : 126;
  }
  return supervise(child, seconds, argv[2]);
}
