#import "MultitouchListener.h"

static NSMutableArray *registeredListeners = nil;

static int touchCallback(int device, Touch *data, int nFingers, double timestamp, int frame) {
    for (int i = 0; i < [registeredListeners count]; ++i) {
        [((MultitouchListener*) [registeredListeners objectAtIndex:i]) handleTouches:data numTouches:nFingers atTime:timestamp];
    }
    return 0;
}

@implementation MultitouchListener

+ (void) initialize {
    if (self == [MultitouchListener class]) {
        registeredListeners = [[NSMutableArray alloc] init];
        MTDeviceRef trackpad = MTDeviceCreateDefault();
        MTRegisterContactFrameCallback(trackpad, touchCallback);
        MTDeviceStart(trackpad, 0);
    }
}

- (void) registerSelf {
    [registeredListeners addObject:self];
}

- (void) deregisterSelf {
    [registeredListeners removeObject:self];
}

- (MultitouchListener*) init {
    self = [super init];
    if (self == nil) {
        [NSException raise:@"Unable to allocate listener" format:@"There was an error while initializing the listener."];
    }
    [self registerSelf];
    return self;
}

- (void) handleTouches:(Touch *)data numTouches:(int)n atTime:(double)timestamp {
    [NSException raise:@"Must subclass MultitouchListener" format:@"MultitouchListener is abstract and must be subclassed."];
}

- (void) dealloc {
    [super dealloc];
    [self deregisterSelf];
}

@end
