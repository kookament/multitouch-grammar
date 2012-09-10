#import "MultitouchListener.h"
#import "GesturePoint.h"

@interface GrammarListener : MultitouchListener {
    double lastTimestamp;
    NSMutableArray *gesturePoints;
    Touch *lastPoints;
    int lastPointsLength;
};

@end
