#import <Foundation/Foundation.h>
#import "Enum.h"

@interface Direction : Enum
    EnumDecl(Direction, NONE)
    EnumDecl(Direction, UP)
    EnumDecl(Direction, DOWN)
    EnumDecl(Direction, LEFT)
    EnumDecl(Direction, RIGHT)
@end

@interface Finger : NSObject
@property (readonly) int identifier;
@property (readonly) Direction *direction;

- (Finger*) initWithId:(int)theId withDirection:(Direction*)theDirection;

@end