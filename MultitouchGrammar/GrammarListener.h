#import "MultitouchListener.h"

@interface GrammarListener : MultitouchListener {
    double lastTimestamp;
    NSMutableArray *gesturePoints;
};

@end
