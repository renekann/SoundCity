//
//  GPSPoint.m
//  SoundCity
//
//  Created by René Kann on 14.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "GPSPoint.h"


@implementation GPSPoint

@synthesize gpsid, title, longitude, latitude, coordinate;


- (id) initWithPrimaryKey:(NSInteger) pk {
	
	[super init];
	gpsid = pk;
	return self;
}

- (void)setData:(NSString *)n latitude:(double)lat longitude:(double) lon {
	latitude = lat;
	longitude = lon;
	self.title = n;
	
	CLLocationCoordinate2D location;
	
	location.latitude = lat;
	location.longitude = lon;
	coordinate = location;
}

- (NSString *)description {
	return [[NSString alloc] initWithFormat:@"GPSPoint latitude: %f | longitude %f ", self.coordinate.latitude, self.coordinate.longitude];
}

-(NSString *) coordinateToString{
	return [[NSString alloc] initWithFormat:@"%f, %f", coordinate.latitude, coordinate.longitude];
}

@end
