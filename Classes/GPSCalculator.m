//
//  DistanceCalculator.m
//  SoundCity
//
//  Created by René Kann on 14.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "AppSettings.h"
#import "GPSCalculator.h"
#import "POI.h"
#import "GPSPoint.h"

@implementation GPSCalculator

@synthesize locationManager, delegate, nearestPOI, settings, nearestPOIList, gpsStatus, currentLocation;
static GPSCalculator *sharedAppGPSCalcClass = nil;

- (id) init {
	settings = [AppSettings sharedAppSettings];
	
	nearestPOIList = [[NSMutableArray alloc] init];
		
    self = [super init];
    if (self != nil) {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self; // send loc updates to myself
		[self.locationManager setDistanceFilter:kCLDistanceFilterNone];
		[self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
		[self setGPSStatus:@"Suche..."];
	}
	
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location: %@", [newLocation description]);
	
	self.currentLocation = newLocation;
	
	// roughly an accuracy of 120 meters, we can adjust this.
	if (newLocation.horizontalAccuracy > 0.0f && newLocation.horizontalAccuracy < 120.0f) {
		[self setGPSStatus:@"Verbunden"];
		[delegate locationUpdate:newLocation];
	} else {
		[self setGPSStatus:@"Suche GPS Signal..."];
	}
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@", [error description]);
	[delegate locationError:error];
}

- (void)setGPSStatus:(NSString *)s {
	
	if(self.gpsStatus == nil) {
		gpsStatus = [[NSString alloc] init];
	}
	
	self.gpsStatus = s;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"gpsStatusChanged" object:self];
}

/**
	Prüft, ob einer GPS Punkt in der Nähe von genau einem POI ist
	Dazu darf der GPS Punkt maximal so weit entfernt sein, wie das Epsilon aus AppSettings vorgibt
	@param pois Array mit POIS aus der ApplicationDelegate Klasse
	@param gpspoint Aktueller GPS Punkt
 */

- (BOOL)nearestPOIExists:(NSMutableArray *) pois gpspoint:(GPSPoint *)gpspoint {
	
	NSLog(@"GPSCalculator %f | %f", gpspoint.coordinate.longitude, gpspoint.coordinate.latitude);
	NSLog(@"Current Epsilon %hi", settings.epsilon);
	
	CLLocation *startingLocation = [[[CLLocation alloc] initWithLatitude: gpspoint.coordinate.latitude longitude:gpspoint.coordinate.longitude] autorelease]; 
	CLLocationDistance distance;
	
	double nearestDistance = -1;
	BOOL foundNearestPOI = NO;
	
	[nearestPOIList removeAllObjects];
	
	for(int x = 0; x < [pois count]; x++) {
		POI *poi = [pois objectAtIndex:x];
		
		CLLocation *poiLocation = [[CLLocation alloc] initWithLatitude: poi.coordinate.latitude longitude:poi.coordinate.longitude]; 
			
		distance = [startingLocation getDistanceFrom:poiLocation];
			
		if((distance < nearestDistance || nearestDistance == -1) && distance <= settings.epsilon) {
			nearestDistance = distance;
			
			[poi setDistance:nearestDistance];
			
			nearestPOI = poi;
			foundNearestPOI = YES;
			
			[nearestPOIList addObject:poi];
			
			NSLog(@"[GPSCalculator] -> calculateDistance() | %@ | Distance: %f | %@", [poi title], distance, poi);
		}
	}
	
	// Sortieren des Arrays mit den gefundenen POIs
	if(self.nearestPOIList.count > 1) {
		
		NSSortDescriptor *sortDescriptor;
		sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES] autorelease];
		
		NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
		//NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
		
		[self setNearestPOIList:[self.nearestPOIList sortedArrayUsingDescriptors:sortDescriptors]];
		//[self.nearestPOIList sortUsingSelector:@selector(compareDistances:)];
		
		//nearestPOIList = sortedArray;
		
		NSLog(@"Sorted POIs %@", nearestPOIList);
		
		//[sortDescriptors release];
		//[sortedArray release];
	}
	
	return foundNearestPOI;
}

+ (GPSCalculator*)sharedAppGPSCalc
{
    if (sharedAppGPSCalcClass == nil) {
        sharedAppGPSCalcClass = [[super allocWithZone:NULL] init];
    }
    return sharedAppGPSCalcClass;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedAppGPSCalc] retain];
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

- (void)dealloc {
    [locationManager release];
	[nearestPOIList release];
	[nearestPOI release];
    [super dealloc];
}


@end
