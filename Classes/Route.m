//
//  Route.m
//  SoundCity
//
//  Created by René Kann on 23.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "Route.h"
#import "GPSPoint.h"

@implementation Route

@synthesize rid, name, image, details, pois, routepoints, dummyGPSPoints;

- (id)init {
	pois = [[NSMutableArray alloc] init];
	routepoints = [[NSMutableArray alloc] init];
	
	return self;
}

- (void) setDummyRoutePoints {
	dummyGPSPoints = [[NSMutableArray alloc] init];
	
	GPSPoint *gps1 = [[GPSPoint alloc] init];
	[gps1 setData:@"1" latitude:37.333258 longitude:-122.030404];
	[dummyGPSPoints addObject:gps1];
	[gps1 release];
	
	GPSPoint *gps2 = [[GPSPoint alloc] init];
	[gps2 setData:@"2" latitude:37.332797 longitude:-122.028601];
	[dummyGPSPoints addObject:gps2];
	[gps2 release];
	
	GPSPoint *gps3 = [[GPSPoint alloc] init];
	[gps3 setData:@"3" latitude:37.330681 longitude:-122.028708];
	[dummyGPSPoints addObject:gps3];
	[gps3 release];
	
	GPSPoint *gps4 = [[GPSPoint alloc] init];
	[gps4 setData:@"4" latitude:37.330477 longitude:-122.030554];
	[dummyGPSPoints addObject:gps4];
	[gps4 release];
	
	GPSPoint *gps5 = [[GPSPoint alloc] init];
	[gps5 setData:@"5" latitude:37.330272 longitude:-122.032292];
	[dummyGPSPoints addObject:gps5];
	[gps5 release];
	
	GPSPoint *gps6 = [[GPSPoint alloc] init];
	[gps6 setData:@"6" latitude:37.331790 longitude:-122.032228];
	[dummyGPSPoints addObject:gps6];
	[gps6 release];
	//[routepoints addObjectsFromArray:dummyGPSPoints];
}

- (NSString *)description {
	return [[NSString alloc] initWithFormat:@"Route: Name - %@ | Image - %@", [self name], [self image]];
}

- (void) dealloc {
	
	[name release];
	[image release];
	[details release];
	[pois release];
	[routepoints release];
	[super dealloc];
}

@end
