// OS-owned snapshots and notification lifecycle; no application policy.
#include "../../native/src/macos.m"
#include <assert.h>
#include <pthread.h>
#include <stdio.h>
static void *off_owner(void *raw) {
  @autoreleasepool {
    struct MacEnvironment env;
    assert(rinzu_macos_environment(raw, &env) == RZ_OWNER);
    assert(rinzu_macos_environment_watch(raw, YES) == RZ_OWNER);
  }
  return NULL;
}
int main(void) {
  @autoreleasepool {
    void *raw = rinzu_macos_session(rinzu_macos_open());
    RZMacSession *session = (RZMacSession *)lookup(raw, RZ_SESSION);
    struct MacEnvironment env;
    assert(rinzu_macos_environment(raw, NULL) == RZ_ARGUMENT);
    assert(rinzu_macos_environment(raw, &env) == 0 && !env.observing && !env.generation &&
           !env.fontGeneration);
    assert(env.preferences >= 0 && env.preferences <= 15);
    pthread_t other;
    assert(!pthread_create(&other, NULL, off_owner, raw));
    assert(!pthread_join(other, NULL));
    assert(rinzu_macos_environment_watch(raw, YES) == 0);
    assert(rinzu_macos_environment_watch(raw, YES) == 0 && session.environmentObservers.count == 5);
    assert(rinzu_macos_font_catalog(raw) == 0 && session.fontCatalogValid);
    NSData *initialCatalog = session.fontCatalogData;
    assert(initialCatalog.length && rinzu_macos_font_catalog(raw) == 0 &&
           session.fontCatalogData == initialCatalog);
    session.streaming = YES;
    for (int i = 0; i < 1000; ++i)
      [NSNotificationCenter.defaultCenter postNotificationName:NSFontSetChangedNotification
                                                        object:nil];
    assert(rinzu_macos_environment(raw, &env) == 0 && env.fontGeneration == 1000 &&
           env.generation == 1000);
    assert(!session.fontCatalogValid && rinzu_macos_font_catalog(raw) == 0 &&
           session.fontCatalogData != initialCatalog && session.fontCatalogValid);
    assert(session->count == 1 && session->events[session->head].kind == RZ_ENVIRONMENT &&
           !session.overflow);
    [NSWorkspace.sharedWorkspace.notificationCenter
        postNotificationName:NSWorkspaceAccessibilityDisplayOptionsDidChangeNotification
                      object:nil];
    assert(rinzu_macos_environment(raw, &env) == 0 && env.generation == 1001 &&
           env.fontGeneration == 1000);
    assert(rinzu_macos_environment_watch(raw, NO) == 0 && !session.environmentObservers &&
           !session.fontCatalogValid);
    [NSNotificationCenter.defaultCenter postNotificationName:NSFontSetChangedNotification
                                                      object:nil];
    assert(rinzu_macos_environment(raw, &env) == 0 && env.generation == 1001 && !env.observing);
    assert(rinzu_macos_environment_watch(raw, YES) == 0);
    __weak RZMacSession *weak = session;
    session.streaming = NO;
    assert(rinzu_macos_close(raw) == 0 && !session.environmentObservers &&
           !session.observingEnvironment);
    assert(rinzu_macos_environment(raw, &env) == RZ_INVALID);
    [NSNotificationCenter.defaultCenter postNotificationName:NSFontSetChangedNotification
                                                      object:nil];
    session = nil;
    (void)weak;
    struct MacStatistics stats;
    assert(!rinzu_macos_statistics(&stats));
    assert(!stats.sessions && !stats.retainedControls);
    puts("PASS:environment:owned:owner:preferences:font-generation:coalesced:opt-in:remove:late:"
         "zero");
  }
}
