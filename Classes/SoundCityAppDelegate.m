//
//  SoundCityAppDelegate.m
//  SoundCity
//
//  Created by René Kann on 09.10.09.
//  Copyright init ag 2009. All rights reserved.
//

#import "AppSettings.h"
#import "SoundCityAppDelegate.h"
#import "POI.h"
#import "GPSPoint.h"
#import "DatabaseController.h"
#import "XMLParser.h"
#import "MLog.h"
#import "SoundController.h"

@implementation SoundCityAppDelegate

@synthesize window, tabBarController, databaseController, gpspoints, settings, soundController, routes, currentRoute, routeChanged, hasInternetConnection;

#define MLogString(s,...) \
[MLog logFile:(char *)__FUNCTION__ lineNumber:__LINE__ \
format:(s),##__VA_ARGS__]

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	self.settings = [AppSettings sharedAppSettings];
	
	self.soundController = [[SoundController alloc] init];
	self.routes = [[NSMutableArray alloc] init];
	self.routeChanged = NO;
	self.hasInternetConnection = NO;
	
	// Prüfen der Internetverbindung
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	hostReach = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
	[hostReach startNotifer];
	
	//POIs werden aus einer SQL Datenbank gelesen, Alternative dazu ist, diese aus einer XML Datei zu parsen, welche im Netz hängt
	
	self.databaseController = [[DatabaseController alloc] init];
	
	self.databaseController.databaseName = @"POI_3.sql";
	[self.databaseController openDatabase];
	[self.databaseController checkAndCreateDatabase];
	
	[self readGPSPointsFromDatabase];
	//[self readPOIFromDatabase];
	
	// XML Datei Parser
	//BOOL success = [self loadXML];
	
	// Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
	
	CGRect cgRect =[[UIScreen mainScreen] bounds];
	loadingView = [[LoadingView alloc] initWithFrame:cgRect];
	[loadingView setHidden:YES];
	[loadingView addLoadingSpinner];
	[loadingView addLabel];
	[window addSubview:loadingView];
}

/**
 NotificationCallback wenn sich der Status der Internetverbindung geändert hat
 */
- (void) reachabilityChanged: (NSNotification* )note
{
	
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
	switch (netStatus)
    {
        case NotReachable:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Keine Internetverbindung verfügbar!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
			[alert show]; 
			[alert release];
			
			self.hasInternetConnection = NO;
			
			if(soundController.soundstate == PLAYING || soundController.soundstate == WAITING_FOR_DATA) {
				[soundController stopStream];
			}
            break;
        }
			
		case ReachableViaWWAN:
        {
            self.hasInternetConnection = YES;
            break;
        }
        case ReachableViaWiFi:
        {
			self.hasInternetConnection = YES;
            break;
		}
    }
}

- (void) reloadXML {
	
	[loadingView setHidden:NO];
	routes = [[NSMutableArray alloc] init];
	
	[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadXMLByTimer:) userInfo:nil repeats:NO]; 
}

-(void)loadXMLByTimer:(NSTimer*)timer { 
	NSNumber *success = [[NSNumber alloc] initWithBool:[self loadXML]];
	
	NSDictionary *d = [NSDictionary dictionaryWithObject:success forKey:@"loadingStatus"];
	
	if([success boolValue] == YES) {
		[self setRouteChanged:YES];
	}
	
	[loadingView setHidden:YES];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"XMLReloaded" object:self userInfo:d];
}

- (BOOL) loadXML {
	NSURL *url = [[NSURL alloc] initWithString:@"http://soundcity.soraxdesign.de/routes.xml"];
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	
	//Initialize the delegate.
	XMLParser *parser = [[XMLParser alloc] initXMLParser];
	
	//Set delegate
	[xmlParser setDelegate:parser];
	
	//Start parsing the XML file.
	BOOL success = [xmlParser parse];
	
	if(success)
		NSLog(@"No Errors");
	else
		NSLog(@"Error Error Error!!!");
	
	NSLog(@"Number of Routes... %hi", [routes count]);
	
	return success;
}



-(void) readPOIFromDatabase {
	sqlite3 *database;
	NSLog(@"Read POIS from Database...");
	
	//pois = [[NSMutableArray alloc] init];
	
	if(sqlite3_open([databaseController.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "select * from poi";
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				
				NSNumberFormatter *formatter =[[NSNumberFormatter alloc] init];
				[formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
				[formatter setGeneratesDecimalNumbers:YES];
				
				NSInteger primaryKey = sqlite3_column_int(compiledStatement, 0);
				
				NSString *pName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				
				double latitudeDN = [[formatter numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)]] doubleValue];
				double longitudeDN = [[formatter numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)]] doubleValue];				
				
				NSString *pSoundURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
				
				POI *poi = [[POI alloc] initWithPrimaryKey:primaryKey];
				[poi setData:pName latitude:latitudeDN longitude:longitudeDN soundURL:pSoundURL];
				
				//[pois addObject:poi];
				[poi release];
				
			}
			
			//NSLog(@"#Objekte %i",[pois count]);	
			
			
		}
		
		sqlite3_finalize(compiledStatement);
	}
	
	sqlite3_close(database);
}

-(void) readGPSPointsFromDatabase {
	sqlite3 *database;
	NSLog(@"Read GPS Points...");
	
	gpspoints = [[NSMutableArray alloc] init];
	
	if(sqlite3_open([databaseController.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "select * from GPS_dummy_points";
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				
				NSNumberFormatter *formatter =[[NSNumberFormatter alloc] init];
				[formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
				//[formatter setGeneratesDecimalNumbers:YES];
				
				NSInteger primaryKey = sqlite3_column_int(compiledStatement, 0);
				
				NSString *pName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				
				double latitudeDN = [[formatter numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)]] doubleValue];	
				double longitudeDN = [[formatter numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)]] doubleValue];				
				
				//NSLog(@"latitude %@, %f %s",latitudeDN, [latitudeDN doubleValue], sqlite3_column_text(compiledStatement, 2));
				
				GPSPoint *gpspoint = [[GPSPoint alloc] initWithPrimaryKey:primaryKey];
				
				[gpspoint setData:pName latitude:latitudeDN longitude:longitudeDN];
				[gpspoints addObject:gpspoint];
				[gpspoint release];
			}
			
			//NSLog(@"#Objekte %i",[gpspoints count]);	
			
			
		}
		
		sqlite3_finalize(compiledStatement);
	}
	
	sqlite3_close(database);
}

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void)dealloc {
	[gpspoints release];
	[tabBarController release];
    [window release];
    [super dealloc];
}

@end

