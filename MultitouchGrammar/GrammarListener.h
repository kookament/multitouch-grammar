#import "MultitouchListener.h"
#import "Gesture.h"

@interface GrammarListener : MultitouchListener {
    double lastTimestamp;
    int lastTouchFingerCount;
    BOOL detectedGesture;
    Gesture *gesture;
};

@end
