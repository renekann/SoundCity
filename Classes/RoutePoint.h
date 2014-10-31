//
//  RoutePoint.h
//  SoundCity
//
//  Created by René Kann on 23.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RoutePoint : NSObject<MKAnnotation>  {
	CLLocationCoordinate2D coordinate;
	double latitude;
	double longitude;
}

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite) double latitude;
@property (nonatomic, readwrite) double longitude;

-(void)initCoordinate;

@end
