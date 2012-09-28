#import "Gesture.h"

// Maximum number of gesture points in a gesture. Continuous movements with more gesture points
// have their earlier gesture points thrown out to keep the geture at the maximum length.
// Circular buffer would be nice and fast for this.
const int MAX_GESTURE_LENGTH = 10;

@implementation Gesture

- (Gesture*) init {
    if (self = [super init]) {
        fingers = [[NSMutableArray alloc] init];
        for (int i = 0; i < 12; ++i) // 11 -> largest identifier returned by the driver.
            [fingers addObject:[[NSMutableArray alloc] init]];
    }
    return self;
}

- (void) reset {
    for (int i = 0; i < 12; ++i)
        [[fingers objectAtIndex:i] removeAllObjects];
}

- (BOOL) isValid {
    for (int i = 1; i < 12; ++i) {
        if ([[fingers objectAtIndex:i] count] > 1) {
            return YES;
        }
    }
    return NO;
}

- (void) truncate {
    for (int i = 1; i < 12; ++i) {
        NSMutableArray *finger = [fingers objectAtIndex:i];
        if ([finger count] > MAX_GESTURE_LENGTH) {
            [finger removeObjectAtIndex:0];
        }
    }
}

- (NSString*) description {
    if (![self isValid])
        return @"";
    NSMutableString *desc = [[NSMutableString alloc] init];
    for (int i = 1; i < 12; ++i) {
        NSMutableArray *finger = [fingers objectAtIndex:i];
        if ([finger count] != 0) {
            [desc appendFormat:@"%@\n", finger];
        }
    }
    return desc;
}

- (void) addTouch:(Touch*)touch {
    NSMutableArray *finger = [fingers objectAtIndex:touch.identifier];
    if ([[finger lastObject] dirFromPrevious] == touch.dirFromPrevious){
        [finger removeLastObject];
    }
    [finger addObject:touch];
}

- (Touch*) lastTouchForFinger:(int)identifier {
    return [[fingers objectAtIndex:identifier] lastObject];
}

@end
