#import "PrintingListener.h"

const int FINGER_THRESHOLD = 1;
const double MIN_PRINT_INTERVAL = 0.25;
const BOOL PRINT_A_LOT = NO;


@interface PrintingListener ()

@property double lastTimestamp;

@end



@implementation PrintingListener

@synthesize lastTimestamp;

- (void) handleTouches:(mtTouch *)data numTouches:(int)n atTime:(double)timestamp {
    if (timestamp - self.lastTimestamp < MIN_PRINT_INTERVAL)
        return;
    self.lastTimestamp = timestamp;
    
    printf("%6.2lf    ", timestamp);
    for (int i = 0; i < n; i++) {
        mtTouch *t = &data[i];
        if (PRINT_A_LOT) {
            printf("frame: %d, ID: %d, state: %d, PosX: %f, PosY: %f, VelX: %f, VelY: %f, Angle: %f, MajorAxis: %f, MinorAxis: %f\n",
                   t->frame,
                   t->identifier,
                   t->state,
                   t->normalized.position.x,
                   t->normalized.position.y,
                   t->normalized.velocity.x,
                   t->normalized.velocity.y,
                   t->angle,
                   t->majorAxis,
                   t->minorAxis);
        } else {
            printf("%2d    ", t->identifier);
        }
    }
    printf("\n");
}

@end
