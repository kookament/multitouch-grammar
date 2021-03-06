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

- (BOOL) isEmpty {
    for (int i = 1; i < 12; ++i) {
        if ([[fingers objectAtIndex:i] count] > 1) {
            return NO;
        }
    }
    return YES;
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
    if ([self isEmpty])
        return @"<empty gesture>";
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

- (NSArray*) sorted {
    return [[fingers
    filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id array, NSDictionary *bindings) {
        return [array count] > 0;
    }]] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [[a objectAtIndex:0] compare:[b objectAtIndex:0]];
    }];
}

- (BOOL) isEqualToGesture:(Gesture *)gesture {
    NSArray *sorted = [self sorted];
    NSArray *otherSorted = [gesture sorted];
    
    if ([sorted count] != [otherSorted count])
        return NO;
    
    for (int i = 0; i < [sorted count]; ++i) {
        NSArray *f1 = [sorted objectAtIndex:i];
        NSArray *f2 = [otherSorted objectAtIndex:i];
        
        if ([f1 count] != [f2 count])
            return NO;
        
        for (int j = 0; j < [f1 count]; ++j) {
            if ([[f1 objectAtIndex:j] dirFromPrevious] != [[f2 objectAtIndex:j] dirFromPrevious])
                return NO;
        }
    }
    return YES;
}

@end
