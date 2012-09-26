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
- (Direction*) directionFrom:(Touch*)origin withThreshold:(float)minDist;

@property (readonly, nonatomic) NSNumber *identifier;
@property (readonly, nonatomic) float x;
@property (readonly, nonatomic) float y;

// This doesn't quite belong here, but this is easier for quick testing.
@property Direction *dirFromPrevious;

@end
