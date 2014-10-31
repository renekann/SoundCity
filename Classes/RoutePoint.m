//
//  RoutePoint.m
//  SoundCity
//
//  Created by René Kann on 23.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "RoutePoint.h"


@implementation RoutePoint

@synthesize coordinate, latitude, longitude;

-(void)initCoordinate {
	CLLocationCoordinate2D location;
	
	location.latitude = [self latitude];
	location.longitude = [self longitude];
	coordinate = location;
}

- (NSString *)description {
	return [[NSString alloc] initWithFormat:@"RoutePoint: Latitude - %f | Longitude - %f", self.coordinate.latitude,  self.coordinate.longitude];
}

- (void) dealloc {
	[super dealloc];
}


@end
