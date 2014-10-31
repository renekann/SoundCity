//
//  TrackRouteViewController.h
//  SoundCity
//
//  Created by René Kann on 29.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GPSCalculator.h"
#import "GPSPoint.h"
#import "Route.h"
#import "TrackRouteSaveViewController.h"

@interface TrackRouteViewController : UIViewController <GPSCalculatorDelegate, MKMapViewDelegate> {
	
	// Klasse zur Berechnung des Abstandes zwischen GPS Pos. und POI
	GPSCalculator *gpsCalc;
	GPSPoint *currentGPSPoint;
	Route *route;
	NSString *state;
	
	// dictionary of route views indexed by annotation
	NSMutableDictionary *_routeViews;
	
	// VIEWS
	
	// Ansicht, um Trackingdaten zu speichern
	TrackRouteSaveViewController *saveTrackView;
	
	// IBOutlets
	IBOutlet UILabel *trackingStatusLabel;
	IBOutlet MKMapView *mapView;
	IBOutlet UIButton *btnTrackingHandling;
	IBOutlet UIButton *btnDiscardTracking;
	IBOutlet UIButton *btnSaveTrackingData;
	
	// Testing
	int dummyGPSPos;
}

// Views
@property (nonatomic, retain) TrackRouteSaveViewController *saveTrackView;

// Interne
@property (nonatomic, retain) GPSCalculator *gpsCalc;
@property GPSPoint *currentGPSPoint;
@property (nonatomic, retain) Route *route;
@property (nonatomic, retain) NSString *state;

// IBOutlets
@property (nonatomic, retain) UIButton *btnTrackingHandling;
@property (nonatomic, retain) UIButton *btnDiscardTracking;
@property (nonatomic, retain) UIButton *btnSaveTrackingData;
@property (nonatomic, retain) IBOutlet UILabel *trackingStatusLabel;

- (IBAction)handleTrackingButton:(id)sender;
- (IBAction)saveData:(id)sender;
- (IBAction)discardData:(id)sender;

- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
- (void)updatePositionOnMap;
- (void)drawRoute;
- (void)fitMapToRegion;
- (IBAction)dummyUpdate:(id)sender;

@end
