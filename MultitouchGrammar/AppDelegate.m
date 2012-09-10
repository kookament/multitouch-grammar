#import "AppDelegate.h"
#import "PrintingListener.h"
#import "GrammarListener.h"

@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    PrintingListener *p = [[PrintingListener alloc] init];
    GrammarListener *g = [[GrammarListener alloc] init];
}

@end
