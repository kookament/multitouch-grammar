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

// class definition

static Gesture *targetGesture = nil;

@implementation GrammarListener

- (GrammarListener*) init {
    if (self = [super init]) {
        gesture = [[Gesture alloc] init];
        detectedGesture = NO;
        lastTimestamp = 0;
        lastTouchFingerCount = 0;
    }
    return self;
}

- (void) reset {
    if (lastTimestamp != 0) {
        if (![gesture isEmpty]) {
            NSLog(@"%@", [gesture sorted]);
            if (targetGesture == nil && ![gesture isEmpty] ) {
                targetGesture = gesture;
            }
        }
        gesture = [[Gesture alloc] init];
    }
    detectedGesture = NO;
    lastTimestamp = 0;
    lastTouchFingerCount = 0;
}

- (void) handleTouches:(mtTouch *)data numTouches:(int)n atTime:(double)timestamp {
    if (n < 2) {
        [self reset];
        return;
    } else if (timestamp - lastTimestamp < MIN_INTERVAL) {
        return;
    } else if (n != lastTouchFingerCount) {
        [self detectGesture];
        [self reset];
    } else if (timestamp - lastTimestamp > NEW_GESTURE_START_TIME) {
        [self reset];
    } else if (detectedGesture) {
        return;
    }

    for (int i = 0; i < n; ++i) {
        mtTouch *rawTouch = &data[i];
        Touch *t = [[Touch alloc] initWithMTTouch:rawTouch withPrevious:[gesture lastTouchForFinger:rawTouch->identifier]];
        if (t.dirFromPrevious != Direction.NONE || lastTimestamp == 0)
            [gesture addTouch:t];
    }

    lastTimestamp = timestamp;
    lastTouchFingerCount = n;
    [gesture truncate];
    [self detectGesture];
}

- (void) detectGesture {
    assert([gesture isEqualToGesture:gesture]);
    if (!detectedGesture && [gesture isEqualToGesture:targetGesture]) {
        NSLog(@"detected original gesture.");
        detectedGesture = YES;
    }
}

@end
