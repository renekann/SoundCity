//
//  MapViewController.h
//  SoundCity
//
//  Created by René Kann on 09.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SoundCityAppDelegate.h";
#import "POIDetailsViewController.h"
#import "POIListViewController.h";
#import "GPSPoint.h";
#import <CoreLocation/CoreLocation.h>
#import "GPSCalculator.h";
#import "POI.h"
#import "AppSettings.h"

@interface MapViewController : UIViewController <GPSCalculatorDelegate, MKMapViewDelegate> {
	SoundCityAppDelegate *appDelegate;
	POIDetailsViewController *poiDetailsView;	
	POIListViewController *poiListView;
	
	int currentGPSPointPos;
	GPSPoint *currentGPSPoint;
	NSMutableArray *visitedPois;
	
	// dictionary of route views indexed by annotation
	NSMutableDictionary *_routeViews;
	
	// Klasse zur Berechnung des Abstandes zwischen GPS Pos. und POI
	GPSCalculator *gpsCalc;
	
	IBOutlet MKMapView *mapView;
	UILabel *gpsStatus;
	UIBarButtonItem *gpsStatusBarButton;
	UIBarButtonItem *buttonMap;
	
	AppSettings *settings;
	
	// gefundenen POI speichern
	BOOL foundPOI;
	POI *currentPOI;
	NSMutableArray *currentPOIList;
	
	// Buttons
	UIBarButtonItem *btnPause;
	UIBarButtonItem *btnPlay;
}
@property (nonatomic, retain) POIDetailsViewController *poiDetailsView;
@property (nonatomic, retain) POIListViewController *poiListView;
@property (nonatomic, retain) UIBarButtonItem *buttonMap;

@property int currentGPSPointPos;
@property (nonatomic, retain) GPSPoint *currentGPSPoint;

@property (nonatomic, retain) GPSCalculator *gpsCalc;

@property (nonatomic, retain) UILabel *gpsStatus;
@property (nonatomic, retain) UIBarButtonItem *gpsStatusBarButton;

@property BOOL foundPOI;
@property (nonatomic, copy) POI *currentPOI;
@property (nonatomic, copy) NSMutableArray *currentPOIList;
@property (nonatomic, copy) NSMutableArray *visitedPois;

@property (nonatomic, retain) UIBarButtonItem *btnPause;
@property (nonatomic, retain) UIBarButtonItem *btnPlay;

@property (nonatomic, retain) AppSettings *settings;

- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
- (void)setGPSPoint;
- (void)showMarks:(NSArray *)marks;
- (void)showCurrentPOIInMap;
- (BOOL)poiWasVisited:(POI *)poi;
- (void)initMapWithRoute;
- (void)fitMapToRegion;
- (void)playAudioOfPOI;


@end
