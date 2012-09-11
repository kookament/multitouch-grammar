#import "GrammarListener.h"

const double MIN_INTERVAL = 0.05;
const double MIN_DISTANCE = 0.1;
// How long between callbacks is considered a new gesture (without futher computation).
const double NEW_GESTURE_START_TIME = 1.0;
// Arbitrary cutoff for gesture length. Events older than this are thrown out.
// Circular buffer would be nice and fast for this.
const int MAX_GESTURE_LENGTH = 15;

typedef enum diff_dir_t {
    NONE = 0,
    UP = 1,
    DOWN = 2,
    LEFT = 4,
    RIGHT = 8
} diff_dir;

@implementation GrammarListener

- (GrammarListener*) init {
    self = [super init];
    [self resetGesture];
    return self;
}

- (void) resetGesture {
    lastTimestamp = 0;
    gesturePoints = [[NSMutableArray alloc] init];
    if (lastPoints != nil) {
        free(lastPoints);
    }
    lastPoints = nil;
    lastPointsLength = 0;
}

- (void) handleTouches:(Touch *)data numTouches:(int)n atTime:(double)timestamp {
    if (n < 2) {
        [self resetGesture];
        return;
    } else if (timestamp - lastTimestamp > NEW_GESTURE_START_TIME) {
        [self resetGesture];
    } else if ((timestamp - lastTimestamp < MIN_INTERVAL) &&
               (lastPoints == nil || lastPointsLength == n || [self enoughDistanceFromLast:data numTouches:n])) {
        return;
    }
    
    NSMutableDictionary *fingers = [[NSMutableDictionary alloc] init];
    if (lastPoints == nil || n != lastPointsLength) {
        for (int i = 0; i < n; ++i) {
            [fingers setObject:Direction.NONE forKey:[[NSNumber alloc] initWithInt:data[i].identifier]];
        }
        [gesturePoints addObject:fingers];
    } else {
        BOOL stationary = YES;
        for (int i = 0; i < n; ++i) {
            assert(lastPoints[i].identifier == data[i].identifier);
            Direction *dir = [self directionFrom:&lastPoints[i] to:&data[i]];
            if (dir != Direction.NONE) {
                stationary = NO;
            }
            [fingers setObject:dir forKey:[[NSNumber alloc] initWithInt:data[i].identifier]];
        }
        if (!stationary) {
            [gesturePoints addObject:fingers];
        } else {
            return;
        }
    }
    
    if ([gesturePoints count] > MAX_GESTURE_LENGTH) {
        [gesturePoints removeObjectAtIndex:0];
    }
    
    lastTimestamp = timestamp;
    [self copyLastGesturePointPosition:data numTouches:n];
    
    [self detectGesture];
}

- (BOOL) enoughDistanceFromLast:(Touch*)data numTouches:(int)n {
    if (lastPoints == nil) {
        return YES;
    } else {
        // If any fingers are far enough, the whole gesture should be considered far enough.
        return NO;
    }
}

- (void) copyLastGesturePointPosition:(Touch*)data numTouches:(int)n {
    if (lastPoints != nil) {
        free(lastPoints);
    }
    lastPoints = malloc(sizeof(Touch) * n);
    memcpy(lastPoints, data, sizeof(Touch) * n);
    lastPointsLength = n;
}

- (void) detectGesture {
    assert([gesturePoints count] <= MAX_GESTURE_LENGTH);
    NSLog(@"%ld gesture points", [gesturePoints count]);
}

- (Direction*) directionFrom:(Touch*)t1 to:(Touch*)t2 {
    float xdiff = t2->normalized.position.x - t1->normalized.position.x;
    float ydiff = t2->normalized.position.y - t1->normalized.position.y;
    
    if (fabs(xdiff) > fabs(ydiff)) {
        if (xdiff < -MIN_DISTANCE)
            return Direction.LEFT;
        else if (xdiff > MIN_DISTANCE)
            return Direction.RIGHT;
    } else {
        if (ydiff < -MIN_DISTANCE)
            return Direction.DOWN;
        else if (ydiff > MIN_DISTANCE)
            return Direction.UP;
    }
    return Direction.NONE;
}

@end
