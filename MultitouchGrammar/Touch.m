#import "Touch.h"

// How far a finger must move (in normalized space, after X_BIAS application) for
// directionFrom:withBias: to consider the distance nonaccidental/twitchy. If the
// distance is less than this threshold, directionFrom:withBias: returns
// Direction.NONE.
// Determined experimentally.
const float MIN_DISTANCE = 0.05;
// When a bias direction is given to directionFrom:withBias:, how strongly it
// should affect the outcome. 1 has no effect, >1 is more bias, and <1 is reverse
// bias (and should not be used -- though this is not enforced).
// Determined experimentally.
const float BIAS_FACTOR = 2;
// A compensation factor for movement in the x direction to undo normalization:
// fingers may move more in the x than y direction, but because the rectangular
// trackpad is normalized, this may confusingly register as more movement in the
// y direction.
// Determined by measuring the trackpad approximately. May not be appropriate
// for all trackpad sizes.
const float X_BIAS = 1.5;

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
    
    float xdiff = (self.x - origin.x) * X_BIAS;
    float ydiff = self.y - origin.y;
    
    if (bias == Direction.LEFT || bias == Direction.RIGHT)
        xdiff *= BIAS_FACTOR;
    else if (bias == Direction.UP || bias == Direction.DOWN)
        ydiff *= BIAS_FACTOR;
    
    if (fabs(xdiff) > fabs(ydiff) && fabs(xdiff) > MIN_DISTANCE)
        return xdiff < 0 ? Direction.LEFT : Direction.RIGHT;
    else if (fabs(ydiff) > MIN_DISTANCE)
        return ydiff < 0 ? Direction.DOWN : Direction.UP;
    return Direction.NONE;
}

- (int) identifier {
    return sourceTouch->identifier;
}

- (float) x {
    return sourceTouch->normalized.position.x;
}

- (float) y {
    return sourceTouch->normalized.position.y;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%d <%.3f, %.3f, %@>", self.identifier, self.x, self.y, self.dirFromPrevious];
}

@end
