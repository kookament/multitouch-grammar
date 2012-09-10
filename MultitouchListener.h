#import <Foundation/Foundation.h>
#import "Touch.h"

@interface MultitouchListener : NSObject

- (void) handleTouches:(Touch*)data numTouches:(int)n atTime:(double)timestamp frame:(int)f;

@end
