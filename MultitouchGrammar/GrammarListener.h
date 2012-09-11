#import "MultitouchListener.h"
#import "Enum.h"

@interface Direction : Enum
    EnumDecl(Direction, NONE)
    EnumDecl(Direction, UP)
    EnumDecl(Direction, DOWN)
    EnumDecl(Direction, LEFT)
    EnumDecl(Direction, RIGHT)
@end

@interface GrammarListener : MultitouchListener {
    double lastTimestamp;
    NSMutableArray *gesturePoints;
    Touch *lastPoints;
    int lastPointsLength;
};

@end
