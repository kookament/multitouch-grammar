#import "MultitouchListener.h"

@interface GrammarListener : MultitouchListener {
    double lastTimestamp;
    int lastTouchFingerCount;
    NSMutableArray *gesturePoints;
};

@end
