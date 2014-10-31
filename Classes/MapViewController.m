//
//  MapViewController.m
//  SoundCity
//
//  Created by René Kann on 09.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "AppSettings.h"
#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "GPSPoint.h";
#import "CSRouteAnnotation.h"
#import "CSRouteView.h"
#import "CSImageAnnotationView.h"
#import "CSMapAnnotation.h"
#import "AudioStreamer.h"
#import "SoundController.h"

@implementation MapViewController

@synthesize buttonMap, poiListView, poiDetailsView, currentGPSPointPos, currentGPSPoint, gpsCalc, gpsStatus, currentPOI, currentPOIList, btnPlay, btnPause;
@synthesize settings, gpsStatusBarButton, visitedPois, foundPOI;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// METHODS FOR INITALIZATION

- (void)viewDidLoad {
	// Initalisieren für die Darstellung der GPS Punkte
	currentGPSPointPos = 21;
	currentGPSPoint = [[GPSPoint alloc] init];
	
	// Hole Delegator der App
	appDelegate = (SoundCityAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// Singleton der AppSettings auf MapViewController laden
	settings = [AppSettings sharedAppSettings];
	
	// Array für besuchte POI initalisieren
	visitedPois = [[NSMutableArray alloc] init];
	
	// dictionary to keep track of route views that get generated. 
	_routeViews = [[NSMutableDictionary alloc] init];
	
	// Liste der aktuell gefundenen POIs
	currentPOIList = [[NSMutableArray alloc] init];
	currentPOI = [[POI alloc] init];
 	
	// GPS Distanz Manager initalisieren um die aktuelle GPS Position mit den POIs abzugleichen
	//gpsCalc = [[GPSCalculator alloc] init];
	gpsCalc = [[GPSCalculator sharedAppGPSCalc] autorelease];
	gpsCalc.delegate = self;
	[gpsCalc.locationManager startUpdatingLocation];
	
	// Notification Center konnectieren und auf Meldungen warten
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(handleXMLReloaded:) name:@"XMLReloaded" object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(soundPlaybackChanged:) name:@"soundStateChanged" object:appDelegate.soundController];
	
	// Hören, wenn in einer Detailsansicht eines POIs die Audioausgabe gestartet wurde
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCurrentPOIFromDetailsView:) name:@"setCurrentPOI" object:poiDetailsView];
	
	// Titel des NavigationControllers setzen (überschreibt auch TabTitle?)
	[self.navigationItem setTitle:@"Audioguide"];
	
	// button für durchschalten der GPS Punkte - nur für die Entwicklung gedacht
	UIBarButtonItem *buttonIterateGPSPoints = [[UIBarButtonItem alloc] initWithTitle:@"GPS +"
												 style:UIBarButtonItemStylePlain 
												target:self
												action:@selector(setGPSPoint)];
	
	
	// Button, um in dem NavigationController zwischen Karte und Liste umzuschalten
	buttonMap = [[UIBarButtonItem alloc] initWithTitle:@"POIs"
																  style:UIBarButtonItemStylePlain 
																 target:self
																 action:@selector(showListWithPOIs)];
	
	// Play und Pause Button
	btnPlay = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(controlGlobalSound)];
	btnPause = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(controlGlobalSound)];
	
		
	// Ein Label in der Toolbar hinzufügen, um Statusänderungen anzuzeigen
	gpsStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 230, 25)];
	gpsStatus.textAlignment = UITextAlignmentLeft;
	gpsStatus.backgroundColor = [UIColor clearColor];
	gpsStatus.adjustsFontSizeToFitWidth = NO;
	gpsStatus.text = @"";
	gpsStatus.font = [UIFont boldSystemFontOfSize:12];
	
	gpsStatusBarButton = [[UIBarButtonItem alloc] initWithCustomView: gpsStatus];
	
	
	// Buttons zum NavCont. hinzufügen
	self.navigationItem.leftBarButtonItem = buttonIterateGPSPoints;
	self.navigationItem.rightBarButtonItem = buttonMap;
	
	[self.navigationController.toolbar setTranslucent:YES];
	[self.navigationController.navigationBar setTranslucent:YES];
	[self.navigationController.toolbar setTintColor:[UIColor orangeColor]];
	[self.navigationController.navigationBar setTintColor:[UIColor orangeColor]];
	[self.navigationController.navigationBar setAlpha:0.8f];
	[self.navigationController.toolbar setAlpha:0.8f];
	
	[self setToolbarContent];
	
	// Karte mit der Route inialisieren
	[self initMapWithRoute];
	
	foundPOI = NO;	
	
	[buttonMap release];
	[buttonIterateGPSPoints release];
	[gpsStatus release];
	
	[super viewDidLoad];
}

/** Methode wirde immer aufgerufen, wenn eine Route aus der Routenliste des zweiten Tabs ausgewählt wurde
	Es werden dann die Route, der aktuelle GPS Punkt und die POIs gezeichnet
	Außerdem werden vorher alle Annotations von der Karte entfernt
	Die Methode wird nur ausgeführt, wenn eine aktuelle Route ausgewählt und auch ein Wechsel der Route ausgeführt wurde
	Aufgerufen wird die Methode bei viewWillAppear und viewDidLoad
 */
- (void)initMapWithRoute {
	if(appDelegate.currentRoute != nil) {
		
		if(appDelegate.routeChanged == YES) {
			[appDelegate setRouteChanged:NO];
			
			[mapView removeAnnotations:mapView.annotations];
			
			[self addRoutePointsToMap];
			
			[self setGPSPoint];
			[self showMarks:appDelegate.currentRoute.pois];
		}
	}
}

/**
 Routenpunkte werden zur Karte hinzugefügt, dabei wird ein CSRouteAnnotation Objekt erzeugt und das
 Polygon mit der Route darauf gezeichnet
 */
- (void)addRoutePointsToMap {
	
	CSRouteAnnotation* routeAnnotation = [[CSRouteAnnotation alloc] initWithPoints:appDelegate.currentRoute.routepoints];
	[mapView addAnnotation:routeAnnotation];
	
	// create the rest of the annotations
	CSMapAnnotation* annotation2 = [[CSMapAnnotation alloc] initWithCoordinate:[[appDelegate.currentRoute.routepoints objectAtIndex:[appDelegate.currentRoute.routepoints count] - 1 ] coordinate]
																annotationType:CSMapAnnotationTypeImage
																		 title:@"Routenziel"];
	[annotation2 setUserData:@"ziel.png"];
	[mapView addAnnotation:annotation2];
	
	// create the rest of the annotations
	CSMapAnnotation* annotation = [[CSMapAnnotation alloc] initWithCoordinate:[[appDelegate.currentRoute.routepoints objectAtIndex:0] coordinate]
											   annotationType:CSMapAnnotationTypeImage
														title:@"Startpunkt"];
	
	[annotation setUserData:@"start.png"];
	[mapView addAnnotation:annotation];
	
	[routeAnnotation release];
	[annotation release];
	[annotation2 release];
	
}

- (void)showMarks:(NSArray *)marks{
	
	//Marks anzeigen
	[mapView addAnnotations:marks];
	
	[self fitMapToRegion];

	
	// aktuellen POI in der Map anzeigen und callout auslösen
	if(self.currentPOI != nil) {
		[self showCurrentPOIInMap];
	}	
}


// METHODS FOR VIEWS AND CONTROLS

/**
 Anzeigen der Liste mit den POIs der aktuellen Route
 */
- (void)showListWithPOIs {
	
	poiListView = [[POIListViewController alloc] initWithNibName:@"POIListViewController" bundle:nil];
	poiListView.route = appDelegate.currentRoute;
	
	// Animation aufsetzen und Listenansicht der POIs auf den Stack schieben
	[self.navigationController pushViewController:self.poiListView animated:YES];
}

- (void)setToolbarContent {
	
	// mehr als ein POI befindet sich in unmittelbarer Nähe
	if([self.currentPOIList count] > 1) {
		
		UIBarButtonItem *btnNextPOI = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStylePlain target:self action:@selector(nextCurrentPOI)];
		UIBarButtonItem *btnPreviousPOI = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(prevCurrentPOI)];
		
		if(appDelegate.soundController.soundstate != INITIALIZED) {
			self.toolbarItems = [NSArray arrayWithObjects:btnPause,gpsStatusBarButton, btnPreviousPOI, btnNextPOI, nil];
		} else {
			self.toolbarItems = [NSArray arrayWithObjects:btnPlay,gpsStatusBarButton, btnPreviousPOI, btnNextPOI, nil];
		}
		
		[btnNextPOI release];
		[btnPreviousPOI release];
	}
	
	// Wenn nur ein POI gefunden wurde
	if([self.currentPOIList count] <= 1) {
		
		if(appDelegate.soundController.soundstate != INITIALIZED) {
			self.toolbarItems = [NSArray arrayWithObjects:btnPause,gpsStatusBarButton, nil];
		} else {
			self.toolbarItems = [NSArray arrayWithObjects:btnPlay,gpsStatusBarButton, nil];
		}
	}	
	
	if(appDelegate.soundController.soundstate == NOT_YET_PLAYED || currentPOI == nil) {
		[self.btnPause setEnabled:NO];
		[self.btnPlay setEnabled:NO];
	} else {
		[self.btnPause setEnabled:YES];
		[self.btnPlay setEnabled:YES];
	}
}

// METHODS FOR MAP INTERACTIONS

/**
 
 */
- (void)nextCurrentPOI {
	
}

/**
 
 */
- (void)prevCurrentPOI {
	
}

/**
 Zur Steuerung der globalen Audioausgabe.
 */
- (void) controlGlobalSound {
	
	
	if(appDelegate.soundController.soundstate != NOT_YET_PLAYED && appDelegate.soundController.soundstate != INITIALIZED) {
		if(self.currentPOI != nil) {
			[currentPOI stopSound];
			[self setToolbarContent];
			return;
		}
	}
	
	if(appDelegate.soundController.soundstate == INITIALIZED) {
		if(self.currentPOI != nil) {
			[currentPOI playSound];
			[self setToolbarContent];
			return;
		}
	}
}

- (void)soundPlaybackChanged:(NSNotification *)aNotification {
	[self setToolbarContent];
}

- (void) setCurrentPOIFromDetailsView:(NSNotification *)aNotification {
	if(poiDetailsView != nil) {
		POI *tmpPoi = poiDetailsView.poi;
		currentPOI = tmpPoi;
	}
}

/**
 Handler, wenn Neuladen der XML Daten erfolgreich abgeschlossen wurde und das NotificationCenter eine Nachricht sendet
 @param note Notification des NotificationCenters mit Informationen zum Ladestatus
 */
- (void)handleXMLReloaded:(NSNotification *)note {
	// Karte mit der Route inialisieren
	[self initMapWithRoute];
}

/**
 Zeichnet den aktuellen GPSPunkt currentGPSPoint auf die Karte und initiert Abstandsberechnungen zu allen vorhandenen POIs,
 wird kein POI gefunden, wird currentPOI auf nil gesetzt, sonst enthält diese Variable den nächsten POI. Weiterhin wird geprüft, ob
 der aktuelle currentPOI dem neu berechneten ist, so dass z.B. der Stream nicht neue gestartet wird. Werden mehr als 1 POI in näherer Umgebung
 gefunden, wird erst der aktuelle zuende gestreamt und dann mit dem nächsten weiter gearbeitet (vorausgesetzt, diese befindet sich noch in der Nähe).
 Diese kann vom Nutzer übersprungen werden, indem er einen Button "Zum nächsten POI springen" anklickt
 */
-(void) setGPSPoint {
	
	if(currentGPSPoint != nil) {
			
		[mapView removeAnnotation:currentGPSPoint];
			
		// aktueller GPS Punkt, wird später ersetzt durch GPS Modul Abfrage
		if(settings.useGPS == NO) {
			currentGPSPoint = [appDelegate.gpspoints objectAtIndex:currentGPSPointPos];
		}
			
		[mapView addAnnotation:currentGPSPoint];
	}
		
	if([appDelegate.currentRoute.pois count] > 0 && appDelegate.currentRoute != nil) {
		
		if(currentGPSPoint != nil) {
			// Berechnen des kürzesten POIs zum aktuellen GPS Punkt
			foundPOI = [gpsCalc nearestPOIExists:appDelegate.currentRoute.pois gpspoint:currentGPSPoint];
		}
		
		if(foundPOI == YES) {
			
			// POI gefunden, LOG ausgeben
			//NSLog(@"POI %hi", foundPOI);
			
			//	Prüfen, ob aktueller POI bereits der jetzt gefundene ist
			//	wenn YES: speichere nicht den POI, gib keinen Hinweis aus, denn dieser ist bereits ausgegeben
			//	wenn NO: speichere in currentPOI, rufe weitere Methoden auf
			
			POI *tmpPOI = gpsCalc.nearestPOI;
			
			if([tmpPOI isMemberOfClass:[POI class]]) 
			{
				BOOL equal = [currentPOI isEqual:tmpPOI];
				
				[currentPOIList removeAllObjects];
				[currentPOIList addObjectsFromArray:gpsCalc.nearestPOIList];
				
				// Punkt ist nicht der aktuelle
				if(equal == NO) {
					
					// Prüfung, ob besuchte Punkte noch einmal angezeigt werden sollen (Hier: NO)
					if(settings.showVisitedPOIsAgain == NO) {
						
						BOOL alreadyVisited = [self poiWasVisited:tmpPOI];
						
						// Punkt wurde noch nie besucht und wird das erste mal angezeigt
						if(alreadyVisited == NO) {
							
							// Aktueller POI ist jetzt der gefundene
							currentPOI = tmpPOI;
							
							[self playAudioOfPOI];
							
							// POI zur Liste mit besuchten POIs hinzufügen, so dass dieser nicht noch einmal angezeigt wird
							[visitedPois addObject:currentPOI];
							
							// aktuellen POI in der Map anzeigen und callout auslösen
							[self showCurrentPOIInMap];
							
							gpsStatus.text = [NSString stringWithFormat:@"Neuer POI: %@", [currentPOI title]];
							
						} else {
							//currentPOI = nil;
							
							gpsStatus.text = [NSString stringWithFormat:@"POI bereits besucht: %@", [tmpPOI title]];
						}
						
					} else {
						[visitedPois removeAllObjects];
						
						// Aktueller POI ist jetzt der gefundene
						currentPOI = tmpPOI;
						
						[self playAudioOfPOI];
						
						gpsStatus.text = [NSString stringWithFormat:@"Neuer POI: %@", [currentPOI title]];
					}
					
					
					// aktuellen POI in der Map anzeigen und callout auslösen
					if(currentPOI != nil) {
						[self showCurrentPOIInMap];
					}
					
				} else {
					// aktuellen POI in der Map anzeigen und callout auslösen
					
					[self showCurrentPOIInMap];
					
					gpsStatus.text = [NSString stringWithFormat:@"Aktueller POI: %@", [currentPOI title]];
				}
				
				[self setToolbarContent];
			}
			
		} else {
			
			[self playAudioOfPOI];
			
			if(currentPOI != nil) {
				[mapView deselectAnnotation:currentPOI animated:YES];
			}
			
			currentPOI = nil;
			gpsStatus.text = @"Kein POI in der Nähe gefunden";
		}
		
		// Nur die Karte auf den User zentrieren, wenn kein POI gefunden wurde
		[mapView setCenterCoordinate:currentGPSPoint.coordinate animated:YES];
		
		
		if(settings.useGPS == NO) {
			
			if(currentGPSPointPos < (appDelegate.gpspoints.count - 1)) {
				currentGPSPointPos = currentGPSPointPos + 1;
			} else {
				currentGPSPointPos = 0;
			}
		}
		
		foundPOI = NO;
	} else {
		[self fitMapToRegion];
	}
}

// HELPER METHODS

/**
 Gibt die Position des aktuellen POIs zurück, wenn mehr als ein POI im Suchradius gefunden wurden. Damit der Audiostream des aktuellen POIs nicht unterbrochen werden muss,
 werden alle gefunden POIs als Array zurückgegeben. Jedoch kann der Benutzer auch den Stream des aktuellen abbrechen und zum nächsten "gefundenen" springen. Deswegen muss hier 
 die Position des aktuellen ausgelesen werden damit ein umschalten zwischen den gefundenen POIs möglich ist
 @return int mit der Position im Array currentPOIList des aktuellen POIs
 */
- (int)getPosOfCurrentPOIinList {
	
	int i = 0;
	
	if(self.currentPOIList.count > 1) {
		for(POI *poi in self.currentPOIList) {
			
			if([poi isMemberOfClass:[POI class]]) {
				if([poi isEqual:currentPOI]) {
					return i;		
				}
			}
			
			i++;
		}
	}
	
	return -1;
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touchesBegan");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touchesMoved");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touchesEnded");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *touch = [event allTouches];
	int nb = [touch count];
	
	NSLog(@"Touch Count %hi", nb);
}
*/

/**
 Prüfen, ob poi in Array visitedPois ist, wenn nicht, NO zurückgeben
 wenn poi bereits besucht wurde, YES zurückgeben
 @param poi zu prüfender Punkt
 */

- (BOOL)poiWasVisited:(POI *)poi {
	BOOL poiAlreadyVisited = NO;
	
	if ([visitedPois containsObject:poi]) {
		poiAlreadyVisited = YES;
	}
	
	return poiAlreadyVisited;
}

/**
 Audiostream abspielen, wenn POI gefunden wird. Dies darf nur geschehen, wenn auch in den Settings die Funktion eingeschaltet ist
 */
- (void)playAudioOfPOI {
	
	if(settings.playAudioAutomatic == YES) {
		if(foundPOI == YES) {
			[self.currentPOI playSound];
		} else {
			[self.currentPOI stopSound];
		}
	}
}

/**
 Öffnet das Infofenster der aktuellen Annotation auf der Karte
 */
- (void)showCurrentPOIInMap {
	/*
	for(id<MKAnnotation> currentAnnotation in mapView.annotations) {
		if([currentAnnotation isMemberOfClass:[POI class]]) {
			if([currentPOI isEqual:currentAnnotation]) {
				[mapView selectAnnotation:currentAnnotation animated:YES];
			}
		}
	}
	*/
	if(currentPOI != nil) {
		[mapView selectAnnotation:currentPOI animated:YES];
	}
}

/**
 Setzt die Karte auf den voreingestellten Auschnitt, so dass alle POIs zu sehen sind
 @todo: - Ausschnitt so anpassen, dass Route auch in den Ausschnitt passt
 */
-(void)fitMapToRegion {
	//Passenden Ausschnitt ermitteln
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	
	span.latitudeDelta = 0.004;
	span.longitudeDelta = 0.004;
	
	if(currentGPSPoint != nil) {
		CLLocationCoordinate2D location = currentGPSPoint.coordinate;
		
		region.span=span;
		region.center=location;
		
		[mapView setRegion:region animated:TRUE];
		[mapView regionThatFits:region];
	}
}

/** 
 Anzeigen von Detailinfos zu einem POI
 @param mapView aktuelle karte
 @param view aktueller Annotationpunkt = pin
 @param control
 */
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	//POI *tmpPoi = (POI *)view.annotation;
	
	//NSLog(@"[MapViewController] - annotationAction() - Selected POI -> %@", [tmpPoi title]);
	poiDetailsView = nil;
	poiDetailsView = [[POIDetailsViewController alloc] initWithNibName:@"POIDetailsViewController" bundle:nil];
	poiDetailsView.poi = (POI *)view.annotation;
	
	// Animation aufsetzen und Listenansicht der POIs auf den Stack schieben
	[self.navigationController pushViewController:poiDetailsView animated:YES];
	
	[poiDetailsView release];
}

/**
 Berechnen des Kartenausschnitts aufgrund der eingefügten Pins auf der Karte
 @param annotations alle Pins der Karte (in diesem Fall POIs)
 */

- (MKCoordinateRegion) regionMakeFromMarks:(NSMutableArray *) annotations{
	
	double lat_min = 90.0;	
	double lon_min = 90.0;
	double lat_max = 0.0;
	double lon_max = 0.0;
	double lat_delta = 2.0;
	double lon_delta = 2.0;
	
	CLLocationCoordinate2D coord;
	
	for (id <MKAnnotation> mark in annotations){
		coord = mark.coordinate;
		
		if(coord.latitude < lat_min){
			lat_min = coord.latitude; 
		}
		if(coord.longitude < lon_min){
			lon_min = coord.longitude;
		}
		if(coord.latitude > lat_max){
			lat_max = coord.latitude;
		}
		if(coord.longitude > lon_max){
			lon_max = coord.longitude;
		}
	}
	
	CLLocationCoordinate2D center;
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	
	if(lat_max > lat_min && lon_max > lon_min){
		center.latitude = lat_min + (lat_max - lat_min)/2;
		center.longitude = lon_min + (lon_max - lon_min)/2;
		
		span.latitudeDelta = (lat_max - center.latitude)*1.2;
		span.longitudeDelta = (lon_max - center.longitude)*1.2;
		
		//span.latitudeDelta = lat_delta;
		//span.longitudeDelta = lon_delta;
	}
	else if(lat_max == lat_min && lon_max == lon_min){
		center = coord;
		
		span.latitudeDelta = lat_delta;
		span.longitudeDelta = lon_delta;
	}
	
	region.span = span;
	region.center = center;
	
	return region;
}

/**
 Annotations auf der Karte initalisieren und zurückgeben
 @param mapView aktuelle Referenz auf die Karte
 @param annotation aktuelle Annotation, welche initalisiert werden soll (kann ein GPSPoint, POI usw. sein)
 */

- (MKAnnotationView *) mapView:(MKMapView *)mapView2 viewForAnnotation:(id <MKAnnotation>) annotation{
	
	MKAnnotationView *annView = nil;
	
	if([annotation isMemberOfClass:[CSRouteAnnotation class]])
	{
		CSRouteAnnotation* routeAnnotation = (CSRouteAnnotation*) annotation;
		
		annView = [_routeViews objectForKey:routeAnnotation.routeID];
		
		if(nil == annView)
		{
			CSRouteView *routeView = [[[CSRouteView alloc] initWithFrame:CGRectMake(50, 50, mapView.frame.size.width, mapView.frame.size.height) drawArrows:YES] autorelease];
			
			routeView.annotation = routeAnnotation;
			routeView.mapView = mapView;
			
			[_routeViews setObject:routeView forKey:routeAnnotation.routeID];
			
			annView = routeView;
			
			[routeAnnotation release];
		}
	}
	
	if([annotation isMemberOfClass:[CSMapAnnotation class]])
	{
		CSMapAnnotation* csAnnotation = (CSMapAnnotation*)annotation;
		
		if(csAnnotation.annotationType == CSMapAnnotationTypeImage)
		{
			NSString* identifier = @"Image";
			
			CSImageAnnotationView *imageAnnotationView = (CSImageAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
			
			imageAnnotationView = [[[CSImageAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];	
			imageAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
						
			annView = imageAnnotationView;
		}
		
		[annView setEnabled:YES];
		[annView setCanShowCallout:NO];
	}
	
	if([annotation isMemberOfClass:[GPSPoint class]]){
		
		// GPS Punkt
		annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"GPS"];
		[annView setImage:[UIImage imageNamed:@"person.png"]];
		annView.canShowCallout = NO;
	} 
	
	if([annotation isMemberOfClass:[POI class]]){
		
		// POI Pins
		UIButton *annotationButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		
		CSImageAnnotationView *imageAnnotationView = [[[CSImageAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"POI"] autorelease];
		
		imageAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		imageAnnotationView.canShowCallout = YES;
		imageAnnotationView.rightCalloutAccessoryView = annotationButton;
		
		annView = imageAnnotationView;

	}
	
	return annView;
}

/** 
 Aktuelle Position anhand des LocationManagers aus dem Objekt GPSCalc
*/
- (void)locationUpdate:(CLLocation *)location {
	
	if(settings.useGPS == YES && currentGPSPoint != nil) {
		gpsStatus.text = [location description];
		currentGPSPoint.coordinate = location.coordinate;
		[self setGPSPoint];
	}
}

- (void)locationError:(NSError *)error {
    gpsStatus.text = [error description];
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
 Funktion zum einblenden der Route, NACHDEM Karte gezoomt oder per Pan verschoben wird
 @param mapView aktuelle Referenz auf die Karte
 @param regionWillChangeAnimated Nutzen der Animation
 */
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	CSRouteView* routeView;
	for(NSObject* key in [_routeViews allKeys])
	{
		routeView = [_routeViews objectForKey:key];
		routeView.hidden = NO;
		[routeView regionChanged];
	}	
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
	
	for(id<MKAnnotation> currentAnnotation in views) {
		if([currentAnnotation isMemberOfClass:[CSRouteView class]]) {
			
			CSRouteView* routeView;
			for(NSObject* key in [_routeViews allKeys])
			{
				routeView = [_routeViews objectForKey:key];
				routeView.hidden = NO;
				[routeView regionChanged];
			}
			
			break;
		}
	}
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

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setToolbarHidden:NO animated:YES];
	[self initMapWithRoute];
}

- (void)viewWillDisappear:(BOOL)animated {
	
}


- (void)dealloc {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	
	[currentPOI release];
	[visitedPois release];
	[currentPOIList release];
	[_routeViews release];
    [super dealloc];
}

@end
