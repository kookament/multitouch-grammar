#import "GrammarListener.h"

const double MIN_INTERVAL = 0.1;
const double MIN_DISTANCE = 0.1;

typedef enum diff_dir_t {
    NONE = 0,
    UP = 1,
    DOWN = 2,
    LEFT = 4,
    RIGHT = 5
} diff_dir;

@implementation GrammarListener

- (GrammarListener*) init {
    self = [super init];
    lastTimestamp = 0;
    gesturePoints = [[NSMutableArray alloc] init];
    lastPoints = nil;
    return self;
}

- (void) handleTouches:(Touch *)data numTouches:(int)n atTime:(double)timestamp {
    if ((n < 2 || timestamp - lastTimestamp < MIN_INTERVAL) && (lastPoints == nil || lastPointsLength == n)) {
        return;
    }
    
    if (lastPoints == nil) {
        NSMutableDictionary *fingers = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < n; ++i) {
            [fingers setObject:Direction.NONE forKey:[[NSNumber alloc] initWithInt:data[i].identifier]];
        }
        [gesturePoints addObject:fingers];
    } else {
        if (n == lastPointsLength) {
            // We moved and it's been long enough.
            // Assert we have the same finger ids; any changes in count should have been caught earlier.
        } else if (n < lastPointsLength) {
            // Finger lifted.
        } else {
            // Finger put down.
        }
    }
    
    lastTimestamp = timestamp;
    lastPoints = data;
    lastPointsLength = n;
}

- (diff_dir) directionFrom:(Touch*)t1 to:(Touch*)t2 {
    float xdiff = t2->normalized.position.x - t1->normalized.position.x;
    float ydiff = t2->normalized.position.y - t1->normalized.position.y;
    
    diff_dir dir = NONE;
    
    if (xdiff <= -MIN_DISTANCE)
        dir |= LEFT;
    if (xdiff >= MIN_DISTANCE)
        dir |= RIGHT;
    if (ydiff <= -MIN_DISTANCE)
        dir |= DOWN;
    if (ydiff >= MIN_DISTANCE)
        dir |= UP;
    
    return dir;
}

@end
