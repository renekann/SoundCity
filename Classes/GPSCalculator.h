//
//  GPSCalculator.h
//  SoundCity
//
//  Created by René Kann on 14.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol GPSCalculatorDelegate 
@required
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
@end

@class POI;
@class GPSPoint;

@interface GPSCalculator : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	CLLocation *currentLocation;
	POI *nearestPOI;
	NSMutableArray *nearestPOIList;
	id delegate;
	AppSettings *settings;
	NSString *gpsStatus;
	
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) id delegate;

/** gefundener Punkt, welcher am nächsten am aktuellen GPS Punkt ist */
@property (nonatomic, retain) POI *nearestPOI;
/** alle Punkte, aufsteigend nach Entfernung sortiert, die im Radius gefunden wurden */
@property (nonatomic, retain) NSMutableArray *nearestPOIList;
/** aktuelle Einstellungen der App, als Singleton */
@property (nonatomic, retain) AppSettings *settings;
@property (nonatomic, retain) NSString *gpsStatus;

@property (nonatomic, retain) CLLocation *currentLocation;

+ (GPSCalculator *)sharedAppGPSCalc;


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

- (BOOL)nearestPOIExists:(NSMutableArray *) pois gpspoint:(GPSPoint *)gpspoint;
- (void)setGPSStatus:(NSString *)s;

@end
