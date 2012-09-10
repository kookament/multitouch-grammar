#import "GesturePoint.h"

@implementation Direction
    EnumImpl(NONE)
    EnumImpl(UP)
    EnumImpl(DOWN)
    EnumImpl(LEFT)
    EnumImpl(RIGHT)
@end

@implementation Finger

@synthesize identifier;
@synthesize direction;

- (Finger*) initWithId:(int)theId withDirection:(Direction*)theDirection {
    self = [super init];
    identifier = theId;
    direction = theDirection;
    return self;
}

@end