#import "GrammarListener.h"
#import "Touch.h"

// geture detection parameters

// How long must elapse between consecutive measurements in order to create a new gesture point.
// Certain events are exempted from this requirement:
//   - there is no previous point
//   - the number of fingers has changed
//   - (unimplemented) the distance since the last point is above a threshold (?)
const double MIN_INTERVAL = 0.05;
// How long between callbacks/movements is considered a new gesture.
const double NEW_GESTURE_START_TIME = 1.0;
// Maximum number of gesture points in a gesture. Continuous movements with more gesture points
// have their earlier gesture points thrown out to keep the geture at the maximum length.
// Circular buffer would be nice and fast for this.
const int MAX_GESTURE_LENGTH = 10;

// class definition

@implementation GrammarListener

- (GrammarListener*) init {
    if (self = [super init]) {
        gesturePoints = [[NSMutableArray alloc] init];
        for (int i = 0; i < 12; ++i) // 11 -> largest identifier returned by the driver.
            [gesturePoints addObject:[[NSMutableArray alloc] init]];
        [self resetGesture];
    }
    return self;
}

- (void) resetGesture {
    if (lastTimestamp != 0) {
        [self printGesturePoints];
        for (int i = 0; i < 12; ++i)
            [[gesturePoints objectAtIndex:i] removeAllObjects];
    }
    lastTimestamp = 0;
    lastTouchFingerCount = 0;
}

- (Touch*) lastTouchFor:(int)identifier {
    return [[gesturePoints objectAtIndex:identifier] lastObject];
}

- (void) addTouch:(Touch*)touch {
    NSMutableArray *finger = [gesturePoints objectAtIndex:touch.identifier];
    if ([[finger lastObject] dirFromPrevious] == touch.dirFromPrevious){
        [finger removeLastObject];
    }
    [finger addObject:touch];
}

- (void) handleTouches:(mtTouch *)data numTouches:(int)n atTime:(double)timestamp {
    if (n < 2) {
        [self resetGesture];
        return;
    } else if (timestamp - lastTimestamp < MIN_INTERVAL) {
        return;
    } else if (n != lastTouchFingerCount) {
        [self detectGesture];
        [self resetGesture];
    } else if (timestamp - lastTimestamp > NEW_GESTURE_START_TIME) {
        [self resetGesture];
    }

    for (int i = 0; i < n; ++i) {
        mtTouch *rawTouch = &data[i];
        Touch *t = [[Touch alloc] initWithMTTouch:rawTouch withPrevious:[self lastTouchFor:rawTouch->identifier]];
        if (t.dirFromPrevious != Direction.NONE || lastTimestamp == 0 || lastTouchFingerCount != n)
            [self addTouch:t];
    }

    lastTimestamp = timestamp;
    lastTouchFingerCount = n;
    [self truncateGesturePoints];
    [self detectGesture];
}

- (void) truncateGesturePoints {
    for (int i = 1; i < 12; ++i) {
        NSMutableArray *finger = [gesturePoints objectAtIndex:i];
        if ([finger count] > MAX_GESTURE_LENGTH) {
            [finger removeObjectAtIndex:0];
        }
    }
}

- (void) printGesturePoints {
    for (int i = 1; i < 12; ++i) {
        if ([[gesturePoints objectAtIndex:i] count] > 1) {
            goto shouldPrint;
        }
    }
    return;
shouldPrint:
    NSLog(@"%.3lf: gesture points", lastTimestamp);
    for (int i = 1; i < 12; ++i) {
        NSMutableArray *finger = [gesturePoints objectAtIndex:i];
        if ([finger count] != 0) {
            NSLog(@"%@", finger);
        }
    }
}

- (void) detectGesture {
    // 
}

@end
