#import "GrammarListener.h"

const double MIN_INTERVAL = 10;
const double MIN_DISTANCE = 0.1;

@implementation GrammarListener

- (GrammarListener*) init {
    self = [super init];
    lastTimestamp = 0;
    gesturePoints = [[NSMutableArray alloc] init];
    return self;
}

- (void) handleTouches:(Touch *)data numTouches:(int)n atTime:(double)timestamp {
    if (n < 2 || timestamp - lastTimestamp < MIN_INTERVAL)
        return;
    lastTimestamp = timestamp;
    
    
}

@end
