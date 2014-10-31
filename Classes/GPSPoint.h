//
//  GPSPoint.h
//  SoundCity
//
//  Created by René Kann on 14.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GPSPoint : NSObject <MKAnnotation>{
	CLLocationCoordinate2D coordinate;
	NSInteger *gpsid;
	NSString *title;
	double latitude; 
	double longitude; 
}

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSInteger *gpsid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, readwrite) double latitude;
@property (nonatomic, readwrite) double longitude;

- (id) initWithPrimaryKey:(NSInteger) pk;
- (void)setData:(NSString *)n latitude :(double )lat longitude:(double) lon; 
-(void)coordinateFromString:(NSString *) coordString;

@end
