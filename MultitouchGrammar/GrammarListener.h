#import "MultitouchListener.h"

@interface GrammarListener : MultitouchListener {
    double lastTimestamp;
    int lastTouchFingerCount;
    NSMutableDictionary *gesturePoints;
};

@end
