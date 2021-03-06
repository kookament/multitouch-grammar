#import <Foundation/Foundation.h>
#import "Touch.h"

@interface Gesture : NSObject {
    NSMutableArray *fingers;
}

- (Touch*) lastTouchForFinger:(int)identifier;
- (void) addTouch:(Touch*)touch;

- (BOOL) isEmpty;
- (void) truncate;

- (NSArray*) sorted;
- (BOOL) isEqualToGesture:(Gesture*)gesture;

@end
