//
//  SettingsViewController.h
//  SoundCity
//
//  Created by René Kann on 16.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundCityAppDelegate.h"
#import "AppSettings.h"
#import "SettingsGPSStatusDetailsViewController.h"

@interface SettingsViewController : UITableViewController <GPSCalculatorDelegate> {
	SoundCityAppDelegate *appDelegate;
	AppSettings *settings;
	// Klasse zur Berechnung des Abstandes zwischen GPS Pos. und POI
	GPSCalculator *gpsCalc;
	SettingsGPSStatusDetailsViewController *gpsDetailsView;
	
	UILabel *gpsStatus;
	UILabel *labelCurrentEpsilon;
}

@property (nonatomic, retain) AppSettings *settings;
@property (nonatomic, retain) UILabel *labelCurrentEpsilon;
@property (nonatomic, retain) UILabel *gpsStatus;
@property (nonatomic ,retain) GPSCalculator *gpsCalc;
@property (nonatomic ,retain) SettingsGPSStatusDetailsViewController *gpsDetailsView;

- (void)changeEpsilonSlider:(id)sender;
- (void)setPlayAudioAutomatic:(id)sender;
- (void)setShowVisitedPoisAgain:(id)sender;
- (void)setUseGPS:(id)sender;
- (void)setValues;
@end
