#import "AppDelegate.h"
#import "PrintingListener.h"

@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    PrintingListener *p = [[PrintingListener alloc] init];
}

@end
