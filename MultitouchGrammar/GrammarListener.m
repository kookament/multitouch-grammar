#import "GrammarListener.h"

// geture detection parameters

// How long must elapse between consecutive measurements in order to create a new gsture point.
// Certain events are exempted from this requirement:
//   - there is no previous point
//   - the number of fingers has changed
//   - (unimplemented) the distance since the last point is above a threshold
const double MIN_INTERVAL = 0.05;
// How far a finger most move (in normalized space) to be considered moving (avoids twitches,
// movements that are not exactly in one compass direction, etc.).
const double MIN_DISTANCE = 0.1;
// How long between callbacks/movements is considered a new gesture.
const double NEW_GESTURE_START_TIME = 1.0;
// Maximum number of gesture points in a gesture. Continuous movements with more gesture points
// have their earlier gesture points thrown out to keep the geture at the maximum length.
// Circular buffer would be nice and fast for this.
const int MAX_GESTURE_LENGTH = 15;

// helper functions

static Direction *directionBetween(Touch *start, Touch *end) {
    float xdiff = end->normalized.position.x - start->normalized.position.x;
    float ydiff = end->normalized.position.y - start->normalized.position.y;
    
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

// class definitions

@implementation Direction
    EnumImpl(NONE)
    EnumImpl(UP)
    EnumImpl(DOWN)
    EnumImpl(LEFT)
    EnumImpl(RIGHT)
@end

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
        BOOL differentFromLast = NO, stationary = YES;
        for (int i = 0; i < n; ++i) {
            assert(lastPoints[i].identifier == data[i].identifier);
            NSNumber *index = [[NSNumber alloc] initWithInt:data[i].identifier];
            Direction *dir = directionBetween(&lastPoints[i], &data[i]);
            if (dir != [[gesturePoints lastObject] objectForKey:index]) {
                differentFromLast = YES;
            }
            if (dir != Direction.NONE) {
                stationary = NO;
            }
            [fingers setObject:dir forKey:index];
        }
        if (!stationary && differentFromLast) {
            NSLog(@"old:\n%@", [gesturePoints lastObject]);
            NSLog(@"new:\n%@", fingers);
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

@end
