//
//  Touch.h
//  MultitouchGrammar
//
//  Created by Sean Kelley on 9/26/12.
//  Copyright (c) 2012 Sean Kelley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Multitouch.h"
#import "Direction.h"

@interface Touch : NSObject

- (Touch*) initWithMTTouch:(mtTouch*)touch;
- (Touch*) initWithMTTouch:(mtTouch*)touch withPrevious:(Touch*)previous;
- (Direction*) directionFrom:(Touch*)origin withBias:(Direction*)bias;

@property (readonly, nonatomic) NSNumber *identifier;
@property (readonly, nonatomic) float x;
@property (readonly, nonatomic) float y;

// This doesn't quite belong here, but this is easier for quick testing.
@property Direction *dirFromPrevious;

@end
