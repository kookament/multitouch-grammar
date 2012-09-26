//
//  Touch.m
//  MultitouchGrammar
//
//  Created by Sean Kelley on 9/26/12.
//  Copyright (c) 2012 Sean Kelley. All rights reserved.
//

#import "Touch.h"

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

- (Direction*) directionFrom:(Touch*)origin withThreshold:(float)minDist {
    if (origin == nil)
        return Direction.NONE;
    
    float xdiff = self.x - origin.x;
    float ydiff = self.y - origin.y;
    
    if (fabs(xdiff) > fabs(ydiff)) {
        if (xdiff < -minDist)
            return Direction.LEFT;
        else if (xdiff > minDist)
            return Direction.RIGHT;
    } else {
        if (ydiff < -minDist)
            return Direction.DOWN;
        else if (ydiff > minDist)
            return Direction.UP;
    }
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
    return [NSString stringWithFormat:@"%d: <%.3f, %.3f, %@>", self.identifier, self.x, self.y, self.dirFromPrevious];
}

@end
