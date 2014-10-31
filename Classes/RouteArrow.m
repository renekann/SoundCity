//
//  RouteArrow.m
//  SoundCity
//
//  Created by René Kann on 05.11.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "RouteArrow.h"
#include <math.h>

@implementation RouteArrow

@synthesize middlePoint, angle, direction;

- (void)calculateAngle:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
	
	float rvX = toPoint.x - fromPoint.x; // Richtungsvektor der Routenlinie mit X-Wert
	float rvY = toPoint.y - fromPoint.y;// Richtungsvektor der Routenlinie mit X-Wert
	
	// Ein Vektor in horizontaler Richtung entspricht der Grundausrichtung der Pfeilgrafik
	float hvX = 320 - fromPoint.x; // Hilfsvektor für die Winkelberechnung - X Wert
	float hvY = 0; // Hilfsvektor für die Winkelberechnung - Y Wert
	
	if(hvX < 0) {
		hvX = hvX * -1;
	}
		// Berechnung des Radians
	float tmpangle = atan2(rvY, rvX) - atan2(hvY, hvX);
	
	[self setAngle:tmpangle];
}

@end
