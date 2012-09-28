#import "MultitouchListener.h"
#import "Gesture.h"

@interface GrammarListener : MultitouchListener {
    double lastTimestamp;
    int lastTouchFingerCount;
    Gesture *gesture;
};

@end
