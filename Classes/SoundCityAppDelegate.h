//
//  SoundCityAppDelegate.h
//  SoundCity
//
//  Created by René Kann on 09.10.09.
//  Copyright init ag 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "AppSettings.h"
#import "Route.h"
#import "GPSCalculator.h"
#import "Reachability.h"
#import "LoadingView.h"

@class DatabaseController;
@class SoundController;

@interface SoundCityAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
	DatabaseController *databaseController;
	AppSettings *settings;
	GPSCalculator *gpsCalc;
	
	UIWindow *window;
    UITabBarController *tabBarController;
	
	NSMutableArray *gpspoints;
	NSMutableArray *routes;
	Route *currentRoute;
	BOOL *routeChanged;
	
	LoadingView *loadingView;
	BOOL hasInternetConnection;
	
	SoundController *soundController; // Soundcontroller für die mp3 Wiedergabe
	Reachability* hostReach; // Zum Prüfen der Internetverbindung
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) NSMutableArray *gpspoints;
@property (nonatomic, retain) NSMutableArray *routes;
@property (nonatomic, retain) Route *currentRoute;

@property (nonatomic, retain) DatabaseController *databaseController;
@property (nonatomic, retain) AppSettings *settings;
@property (nonatomic, retain) GPSCalculator *gpsCalc;

@property (nonatomic, retain) SoundController *soundController;
@property (nonatomic, readwrite) BOOL *routeChanged;
@property (nonatomic, readwrite) BOOL hasInternetConnection;

- (BOOL) loadXML;
- (void) reloadXML;
- (void) readGPSPointsFromDatabase;

@end
