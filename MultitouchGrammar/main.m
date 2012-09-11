#import <Cocoa/Cocoa.h>
#import "Touch.h"
#import "GrammarListener.h"

int main(int argc, char *argv[]) {
    GrammarListener *g = [[GrammarListener alloc] init];
    while (YES) {
        // Because Xcode is bad and should feel bad. Continuing after
        // a breakpoint would otherwise terminate the program because
        // it would continue after sleep().
        sleep(-1);
    }
    return 0;
}
