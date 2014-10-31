//
//  SettingsGPSStatusDetailsViewController.h
//  SoundCity
//
//  Created by René Kann on 02.11.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppSettings.h"
#import "GPSCalculator.h"

@interface SettingsGPSStatusDetailsViewController : UITableViewController <GPSCalculatorDelegate> {
	// Klasse zur Berechnung des Abstandes zwischen GPS Pos. und POI
	GPSCalculator *gpsCalc;
}

@property (nonatomic ,retain) GPSCalculator *gpsCalc;

@end
