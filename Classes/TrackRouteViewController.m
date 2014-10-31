//
//  TrackRouteViewController.m
//  SoundCity
//
//  Created by René Kann on 29.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "AppSettings.h"
#import "TrackRouteViewController.h"
#import <MapKit/MapKit.h>
#import "CSRouteAnnotation.h"
#import "CSRouteView.h"
#import "CSImageAnnotationView.h"
#import "CSMapAnnotation.h"
#import "MLog.h"
#import "RoutePoint.h"

NSString * const TRACKING = @"Currently Tracking";
NSString * const NOT_TRACKING = @"Tracking not started yet";
NSString * const ROUTE_TRACKED = @"A route was tracked and is ready for saving";

NSString * const BUTTON_LABEL_START_TRACKING = @"Route tracken";
NSString * const BUTTON_LABEL_STOP_TRACKING = @"Tracking stoppen";
NSString * const BUTTON_LABEL_WAITING_FOR_USER = @"Warte auf Bearbeitung...";

@implementation TrackRouteViewController

@synthesize gpsCalc, currentGPSPoint, route, state, btnTrackingHandling, trackingStatusLabel, btnDiscardTracking, btnSaveTrackingData, saveTrackView;

#define MLogString(s,...) \
[MLog logFile:(char *)__FUNCTION__ lineNumber:__LINE__ \
format:(s),##__VA_ARGS__]

// CUSTOM METHODS

- (IBAction)handleTrackingButton:(id)sender {
	
	// Tracking nicht gestartet, also hier starten...
	if(self.state == NOT_TRACKING) {
		
		[self setState:TRACKING];
		[self.btnTrackingHandling setTitle:BUTTON_LABEL_STOP_TRACKING forState:UIControlStateNormal];
		[self.btnDiscardTracking setHidden:YES];
		[self.btnSaveTrackingData setHidden:YES];
		
		return;
	}
	
	// Tracking läuft, soll gestoppt werden...
	if(self.state == TRACKING) {
		
		[self setState:ROUTE_TRACKED];
		[self.btnTrackingHandling setTitle:BUTTON_LABEL_WAITING_FOR_USER forState:UIControlStateNormal];
		[self.btnTrackingHandling setEnabled:NO];
		
		[self.btnDiscardTracking setHidden:NO];
		[self.btnSaveTrackingData setHidden:NO];
		
		return;
	}
}

- (IBAction)discardData:(id)sender {
	
	route = nil;
	route = [[Route alloc] init];
	
	[self.btnDiscardTracking setHidden:YES];
	[self.btnSaveTrackingData setHidden:YES];
	[self.btnTrackingHandling setEnabled:YES];
	[self.btnTrackingHandling setTitle:BUTTON_LABEL_START_TRACKING forState:UIControlStateNormal];
	
	[self setState:NOT_TRACKING];
}

- (IBAction)saveData:(id)sender {
	
	saveTrackView = [[TrackRouteSaveViewController alloc] initWithNibName:@"TrackRouteSaveViewController" bundle:nil];
	saveTrackView.route = self.route;
	
	// Animation aufsetzen und Listenansicht der POIs auf den Stack schieben
	[self.navigationController pushViewController:self.saveTrackView animated:YES];
	
	[self setState:NOT_TRACKING];
}

- (IBAction)dummyUpdate:(id)sender {
	currentGPSPoint = (GPSPoint*)[route.dummyGPSPoints objectAtIndex:dummyGPSPos];
	
	[self updatePositionOnMap];
	dummyGPSPos++;
}

- (void)updatePositionOnMap {
	
	RoutePoint *tmpRoutePoint = [[RoutePoint alloc] init];
	tmpRoutePoint.coordinate = currentGPSPoint.coordinate;
	
	[mapView removeAnnotations:mapView.annotations];
	[mapView addAnnotation:currentGPSPoint];
	
	// GPS Punkt als RoutePoint zur Route hinzufügen
	[route.routepoints addObject:tmpRoutePoint];
	[tmpRoutePoint release];
	
	[self fitMapToRegion];
	[self drawRoute];
}

- (void) drawRoute {
	CSRouteAnnotation* routeAnnotation = [[[CSRouteAnnotation alloc] initWithPoints:route.routepoints] autorelease];
	[mapView addAnnotation:routeAnnotation];
	
}

/**
 Setzt die Karte auf den voreingestellten Auschnitt, so dass alle POIs zu sehen sind
 @todo: - Ausschnitt so anpassen, dass Route auch in den Ausschnitt passt
 */
-(void)fitMapToRegion {
	//Passenden Ausschnitt ermitteln
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	
	span.latitudeDelta = 0.005;
	span.longitudeDelta = 0.005;
	
	if(currentGPSPoint != nil) {
		CLLocationCoordinate2D location = currentGPSPoint.coordinate;
		
		region.span=span;
		region.center=location;
		
		[mapView setRegion:region animated:TRUE];
		//[mapView regionThatFits:region];
	}
}

// REIMPLEMENTED METHODS

/** 
 Aktuelle Position anhand des LocationManagers aus dem Objekt GPSCalc
 */
- (void)locationUpdate:(CLLocation *)location {
	if(currentGPSPoint != nil) {
		currentGPSPoint.coordinate = location.coordinate;
		[self.trackingStatusLabel setText:@"Neuer GPS Punkt"];
		[self updatePositionOnMap];
	}
}

- (void)locationError:(NSError *)error {
	
}

// MAP METHODS

/**
 Annotations auf der Karte initalisieren und zurückgeben
 @param mapView aktuelle Referenz auf die Karte
 @param annotation aktuelle Annotation, welche initalisiert werden soll (kann ein GPSPoint, POI usw. sein)
 */

- (MKAnnotationView *) mapView:(MKMapView *)mapView2 viewForAnnotation:(id <MKAnnotation>) annotation{
	
	MKAnnotationView *annView = nil;
	
	if([annotation isKindOfClass:[CSRouteAnnotation class]])
	{
		CSRouteAnnotation* routeAnnotation = (CSRouteAnnotation*) annotation;
		
		annView = [_routeViews objectForKey:routeAnnotation.routeID];
		
		if(nil == annView)
		{
			CSRouteView *routeView = [[[CSRouteView alloc] initWithFrame:CGRectMake(100, 100, mapView.frame.size.width, mapView.frame.size.height) drawArrows:NO] autorelease];
			
			routeView.annotation = routeAnnotation;
			routeView.mapView = mapView;
			
			[_routeViews setObject:routeView forKey:routeAnnotation.routeID];
			
			annView = routeView;
		}
	}

	if([annotation isMemberOfClass:[GPSPoint class]]){
		
		// GPS Punkt
		annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"z_GPS"];
		[annView setImage:[UIImage imageNamed:@"person.png"]];
		annView.canShowCallout = YES;
	}
	
	return annView;
}

/**
 Funktion zum ausblenden der Route, BEVOR Karte gezoomt oder per Pan verschoben wird
 @param mapView aktuelle Referenz auf die Karte
 @param regionWillChangeAnimated Nutzen der Animation
 */
#pragma mark mapView delegate functions
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
	
	// turn off the view of the route as the map is chaning regions. This prevents
	// the line from being displayed at an incorrect positoin on the map during the
	// transition. 
	for(NSObject* key in [_routeViews allKeys])
	{
		CSRouteView* routeView = [_routeViews objectForKey:key];
		routeView.hidden = YES;
	}
	
}

/**
 Funktion zum ausblenden der Route, NACHDEM Karte gezoomt oder per Pan verschoben wird
 @param mapView aktuelle Referenz auf die Karte
 @param regionWillChangeAnimated Nutzen der Animation
 */
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	// re-enable and re-poosition the route display. 
	for(NSObject* key in [_routeViews allKeys])
	{
		CSRouteView* routeView = [_routeViews objectForKey:key];
		routeView.hidden = NO;
		[routeView regionChanged];
	}
	
}

// VIEW METHODS

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	// View wurde geladen, es kann noch kein Tracking stattgefunden haben
	[self setState:NOT_TRACKING];
	
	dummyGPSPos = 0;
	
	// Button auf Standardlabel setzen
	[self.btnTrackingHandling setTitle:BUTTON_LABEL_START_TRACKING forState:UIControlStateNormal];
	
	// Titel für NavigationItem initalisieren
	[self.navigationItem setTitle:@"Tracking"];
	
	currentGPSPoint = [[GPSPoint alloc] init];
	
	route = [[Route alloc] init];
	
	// für testzwecke einige Dummypunkte einfügen
	[route setDummyRoutePoints];
	
	// GPS Distanz Manager initalisieren um die aktuelle GPS Position zu bekommen
	//gpsCalc = [[GPSCalculator alloc] init];
	gpsCalc = [GPSCalculator sharedAppGPSCalc];
	gpsCalc.delegate = self;
	[gpsCalc.locationManager startUpdatingLocation];
	
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[currentGPSPoint release];
	[self.btnTrackingHandling release];
    [super dealloc];
}


@end
