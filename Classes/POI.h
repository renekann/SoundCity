//
//  POI.h
//  SoundCity
//
//  Created by René Kann on 12.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SoundCityAppDelegate.h"

@class POIInternalView;

@interface POI : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSInteger pid;
	NSString *title;
	NSString *subtitle;
	double latitude; 
	double longitude; 
	NSString *soundURL;
	NSString *videoURL;
	NSString *imageURL;
	NSString *details;
	SoundCityAppDelegate *appDelegate;
	double distance;
	NSString* userData;
	
	int detailsTextLength;
}

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite) NSInteger pid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readwrite) double latitude;
@property (nonatomic, readwrite) double longitude;
@property (nonatomic, readwrite) double distance;
@property (nonatomic, copy) NSString *soundURL;
@property (nonatomic, copy) NSString *videoURL;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, retain) SoundCityAppDelegate *appDelegate;
@property (nonatomic, retain) NSString* userData;
@property (nonatomic, readwrite) int detailsTextLength;

- (id) initWithPrimaryKey:(NSInteger) pk;
- (void)setData:(NSString *)title latitude :(double)lat longitude:(double) lon soundURL:(NSString *) _soundURL; 
- (BOOL)isEqual:(id)object;
- (NSString *)getLatitude;
- (NSString *)getLongitude;
- (void)initCoordinate;
- (void)playSound;
- (void)stopSound;
- (CGContextRef)drawPOI:(CGContextRef)context;

@end
