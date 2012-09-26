#import "Enum.h"

@interface Direction : Enum
    EnumDecl(Direction, NONE)
    EnumDecl(Direction, UP)
    EnumDecl(Direction, DOWN)
    EnumDecl(Direction, LEFT)
    EnumDecl(Direction, RIGHT)
@end
