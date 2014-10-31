//
//  RouteArrow.h
//  SoundCity
//
//  Created by René Kann on 05.11.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RouteArrow : NSObject {
	CGPoint middlePoint;
	float angle; // in radian
	NSString *direction;
}

@property CGPoint middlePoint;
@property float angle;
@property (nonatomic, retain) NSString *direction;

- (void)calculateAngle:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;

@end
