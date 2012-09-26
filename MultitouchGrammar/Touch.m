#import "Touch.h"

// How far a finger must move (in normalized space) for directionFrom:withBias: to
// consider the distance nonaccidental/twitchy. If the distance is less than this
// threshold, directionFrom:withBias: returns Direction.NONE.
const float MIN_DISTANCE = 0.05;

@interface Touch () {
    mtTouch *sourceTouch;
}
@end

@implementation Touch

@synthesize dirFromPrevious;

- (Touch*) initWithMTTouch:(mtTouch*)touch {
    self = [super init];
    if (self == nil) {
        [NSException raise:@"Initialization failure" format:@"Superclass failed to initialize Touch."];
    }
    sourceTouch = malloc(sizeof(mtTouch));
    memcpy(sourceTouch, touch, sizeof(mtTouch));
    self.dirFromPrevious = Direction.NONE;
    return self;
}

- (Touch*) initWithMTTouch:(mtTouch*)touch withPrevious:(Touch*)previous {
    self = [self initWithMTTouch:touch];
    self.dirFromPrevious = [self directionFrom:previous withBias:previous.dirFromPrevious];
    return self;
}

- (Direction*) directionFrom:(Touch*)origin withBias:(Direction*)bias {
    if (origin == nil)
        return Direction.NONE;
    
    float xdiff = self.x - origin.x;
    float ydiff = self.y - origin.y;
    
    if (bias == Direction.LEFT || bias == Direction.RIGHT)
        xdiff *= 2;
    else if (bias == Direction.UP || bias == Direction.DOWN)
        ydiff *= 2;
    
    if (fabs(xdiff) > fabs(ydiff) && fabs(xdiff) > MIN_DISTANCE)
        return xdiff < 0 ? Direction.LEFT : Direction.RIGHT;
    else if (fabs(ydiff) > MIN_DISTANCE)
        return ydiff < 0 ? Direction.DOWN : Direction.UP;
    return Direction.NONE;
}

- (NSNumber*) identifier {
    return [[NSNumber alloc] initWithInt:sourceTouch->identifier];
}

- (float) x {
    return sourceTouch->normalized.position.x;
}

- (float) y {
    return sourceTouch->normalized.position.y;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@: <%.3f, %.3f, %@>", self.identifier, self.x, self.y, self.dirFromPrevious];
}

@end
