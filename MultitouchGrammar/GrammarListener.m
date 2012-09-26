#import "GrammarListener.h"
#import "Touch.h"

// geture detection parameters

// How long must elapse between consecutive measurements in order to create a new gesture point.
// Certain events are exempted from this requirement:
//   - there is no previous point
//   - the number of fingers has changed
//   - (unimplemented) the distance since the last point is above a threshold
const double MIN_INTERVAL = 0.05;
// How much any finger must move to trigger registration of a new gesture point for all fingers.
const double MIN_TRIGGER_DISTANCE = 0.2;
// How much a given finger must move, assuming a gesture point is going to be registered, to
// be considered moving. Note that this should be smaller than the trigger distance. In
// combination with the trigger distance, this ensures that any fingers that were near but did
// not pass the the trigger threshold still count as moving (while still ruling out twitches
// or small accidental movements).
const double MIN_MOVE_DISTANCE = 0.1;
// How long between callbacks/movements is considered a new gesture.
const double NEW_GESTURE_START_TIME = 1.0;
// Maximum number of gesture points in a gesture. Continuous movements with more gesture points
// have their earlier gesture points thrown out to keep the geture at the maximum length.
// Circular buffer would be nice and fast for this.
const int MAX_GESTURE_LENGTH = 15;

// class definitions

@implementation GrammarListener

- (GrammarListener*) init {
    self = [super init];
    [self resetGesture];
    return self;
}

- (void) resetGesture {
    lastTimestamp = 0;
    lastTouchFingerCount = 0;
    gesturePoints = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < 11; ++i) { // 11 -> largest identifier returned by the driver.
        [gesturePoints setObject:[[NSMutableArray alloc] init] forKey:[[NSNumber alloc] initWithInt:i]];
    }
}

- (Touch*) lastCorrespondingTouch:(Touch*)touch {
    return [[gesturePoints objectForKey:touch.identifier] lastObject];
}

- (void) addTouch:(Touch*)touch {
    [[gesturePoints objectForKey:touch.identifier] addObject:touch];
}

- (void) handleTouches:(mtTouch *)data numTouches:(int)n atTime:(double)timestamp {
    if (n < 2) {
        [self resetGesture];
        return;
    } else if (timestamp - lastTimestamp > NEW_GESTURE_START_TIME) {
        [self resetGesture];
    } else if (timestamp - lastTimestamp < MIN_INTERVAL) {
        return;
    }
    
//    if (lastTimestamp == 0) {
//        NSLog(@"initializing new gesture with touches");
//        for (int i = 0; i < n; ++i) {
//            [self addTouch:[[Touch alloc] initWithMTTouch:&data[i]]];
//        }
//        thingsGotAdded = YES;
//    } else if (n != lastTouchFingerCount) {
//        NSLog(@"number of fingers changed, adding entries");
//        for (int i = 0; i < n; ++i) {
//            Touch *t = [[Touch alloc] initWithMTTouch:&data[i]];
//            if ([self lastCorrespondingTouch:t] == nil) {
//                [self addTouch:t];
//                thingsGotAdded = YES;
//            }
//        }
//    } else {
    
        for (int i = 0; i < n; ++i) {
            Touch *t = [[Touch alloc] initWithMTTouch:&data[i]];
            // Dir from can't use a threshold, since it's being run so frequently. Just pick the max diff, and
            // bias towards the direct of the previous.
            [t setDirFromPrevious:[t directionFrom:[self lastCorrespondingTouch:t] withThreshold:MIN_MOVE_DISTANCE]];
            [self addTouch:t];
        }
//    }

    lastTimestamp = timestamp;
    lastTouchFingerCount = n;
    [self truncateGesturePoints];
    [self detectGesture];
    [self printGesturePoints];
}

- (void) truncateGesturePoints {
    for (int i = 0; i < 11; ++i) {
        NSMutableArray *finger = [gesturePoints objectForKey:[[NSNumber alloc] initWithInt:i]];
        if ([finger count] > MAX_GESTURE_LENGTH) {
            [finger removeObjectAtIndex:0];
        }
    }
}

- (void) printGesturePoints {
    NSLog(@"%lf: gesture points", lastTimestamp);
    for (int i = 0; i < 11; ++i) {
        NSMutableArray *finger = [gesturePoints objectForKey:[[NSNumber alloc] initWithInt:i]];
        if ([finger count] != 0) {
            NSLog(@"%@", finger);
        }
    }
}

- (void) detectGesture {
    // 
}

@end
