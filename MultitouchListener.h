#import <Foundation/Foundation.h>
#import "Multitouch.h"

@interface MultitouchListener : NSObject

- (void) handleTouches:(mtTouch*)data numTouches:(int)n atTime:(double)timestamp;

@end
