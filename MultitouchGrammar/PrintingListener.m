#import "PrintingListener.h"

const int FINGER_THRESHOLD = 1;
const double MIN_INTERVAL = 0.25;


@interface PrintingListener ()

@property double lastTimestamp;

@end



@implementation PrintingListener

@synthesize lastTimestamp;

- (void) handleTouches:(Touch *)data numTouches:(int)n atTime:(double)timestamp {
    if (timestamp - self.lastTimestamp < MIN_INTERVAL)
        return;
    self.lastTimestamp = timestamp;
    
    printf("%6.2lf    ", timestamp);
    for (int i = 0; i < n; i++) {
        Touch *t = &data[i];
        printf("%2d    ", t->identifier);
//        printf("frame: %d, timestamp: %f, ID: %d, state: %d, PosX: %f, PosY: %f, VelX: %f, VelY: %f, Angle: %f, MajorAxis: %f, MinorAxis: %f\n",
//               t->frame,
//               t->timestamp,
//               t->identifier,
//               t->state,
//               t->normalized.position.x,
//               t->normalized.position.y,
//               t->normalized.velocity.x,
//               t->normalized.velocity.y,
//               t->angle,
//               t->majorAxis,
//               t->minorAxis);
    }
    printf("\n");
}

@end
