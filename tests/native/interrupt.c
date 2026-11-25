#define _POSIX_C_SOURCE 200809L

#include <errno.h>
#include <poll.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static long long millis(void) {
  struct timespec time;
  clock_gettime(CLOCK_MONOTONIC, &time);
  return (long long)time.tv_sec * 1000 + time.tv_nsec / 1000000;
}

static void launch(char **command, int pipefd[2], bool ignored, bool blocked) {
  close(pipefd[0]);
  struct sigaction action = {.sa_handler = ignored ? SIG_IGN : SIG_DFL};
  sigemptyset(&action.sa_mask);
  sigset_t mask;
  sigemptyset(&mask);
  sigaddset(&mask, SIGINT);
  if (sigaction(SIGINT, &action, NULL) != 0 ||
      sigprocmask(blocked ? SIG_BLOCK : SIG_UNBLOCK, &mask, NULL) != 0 ||
      dup2(pipefd[1], STDOUT_FILENO) < 0 || dup2(pipefd[1], STDERR_FILENO) < 0) {
    perror("prepare interrupt fixture");
    _exit(125);
  }
  close(pipefd[1]);
  execvp(command[0], command);
  perror(command[0]);
  _exit(125);
}

static bool capture(pid_t child, int readfd, char *output, size_t capacity) {
  long long deadline = millis() + 90000;
  struct pollfd source = {.fd = readfd, .events = POLLIN};
  size_t length = 0;
  bool interrupted = false;
  while (length + 1 < capacity) {
    long long remaining = deadline - millis();
    if (remaining <= 0)
      break;
    int ready = poll(&source, 1, (int)remaining);
    if (ready < 0 && errno == EINTR)
      continue;
    if (ready <= 0)
      break;
    ssize_t count = read(readfd, output + length, capacity - length - 1);
    if (count < 0 && errno == EINTR)
      continue;
    if (count == 0)
      return interrupted;
    if (count < 0)
      break;

    length += (size_t)count;
    output[length] = '\0';
    if (!interrupted && strstr(output, "TERMINATION_MARK=10\n")) {
      if (kill(child, SIGINT) != 0)
        return false;
      interrupted = true;
      deadline = millis() + 3000;
    }
  }
  return false;
}

static bool reap(pid_t child, int *status) {
  long long deadline = millis() + 3000;
  while (millis() < deadline) {
    pid_t waited = waitpid(child, status, WNOHANG);
    if (waited == child)
      return true;
    if (waited < 0 && errno != EINTR)
      return false;
    struct timespec pause = {.tv_nsec = 10000000};
    nanosleep(&pause, NULL);
  }
  return false;
}

int main(int argc, char **argv) {
  if (argc < 3) {
    fprintf(stderr, "Usage: %s default|ignored|blocked command [args...]\n", argv[0]);
    return 2;
  }
  bool blocked = strcmp(argv[1], "blocked") == 0;
  bool ignored = blocked || strcmp(argv[1], "ignored") == 0;
  if (!ignored && strcmp(argv[1], "default") != 0)
    return 2;
  int pipefd[2];
  if (pipe(pipefd) != 0) {
    perror("pipe");
    return 1;
  }
  pid_t child = fork();
  if (child == 0)
    launch(argv + 2, pipefd, ignored, blocked);
  close(pipefd[1]);
  if (child < 0) {
    close(pipefd[0]);
    perror("fork");
    return 1;
  }

  char output[65536] = "";
  bool reachedCallback = capture(child, pipefd[0], output, sizeof(output));
  close(pipefd[0]);
  int status;
  if (!reachedCallback || !reap(child, &status)) {
    kill(child, SIGKILL);
    while (waitpid(child, NULL, 0) < 0 && errno == EINTR) {
    }
    fprintf(stderr, "AppKit callback did not terminate on SIGINT:\n%s", output);
    return 1;
  }
  if (!WIFSIGNALED(status) || WTERMSIG(status) != SIGINT ||
      !strstr(output, "TERMINATION_MARK=1\n") || strstr(output, "TERMINATION_MARK=4\n") ||
      strstr(output, "TERMINATION_MARK=5\n") || strstr(output, "RINZU_NATIVE_CALLS=") ||
      strstr(output, "ERROR: AddressSanitizer") || strstr(output, "runtime error:")) {
    fprintf(stderr, "Unexpected interrupt result (%d):\n%s", status, output);
    return 1;
  }
  printf("PASS:interrupt:%s\n", argv[1]);
  return 0;
}
