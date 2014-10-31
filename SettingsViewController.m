//
//  SettingsViewController.m
//  SoundCity
//
//  Created by René Kann on 16.10.09.
//  Copyright 2009 init ag. All rights reserved.

//

#import "AppSettings.h"
#import "SettingsViewController.h"
#import "GPSCalculator.h"

@implementation SettingsViewController

@synthesize settings, labelCurrentEpsilon, gpsStatus, gpsCalc, gpsDetailsView;

// SETTING FUNCTIONS

- (id) init {
	settings = [AppSettings sharedAppSettings];
	
	return self;
}

- (void)changeEpsilonSlider:(id)sender {
	[settings setEpsilon:(int)((UISlider*)sender).value];
	[self setValues];
	
}

- (void)setPlayAudioAutomatic:(id)sender {
	//NSLog(@" %hi", ((UISwitch *)sender).on );
	
	[settings setPlayAudioAutomatic:((UISwitch *)sender).on];
	[self setValues];
}

- (void)setShowVisitedPoisAgain:(id)sender {
	//NSLog(@" %hi", switchShowVisitedPoisAgain.on );
	
	[settings setShowVisitedPOIsAgain:((UISwitch *)sender).on];
	[self setValues];
}


- (void)setUseGPS:(id)sender {
	[settings setUseGPS:((UISwitch *)sender).on];
	[self setValues];
}

- (void)setValues {
	// labels setzen
	labelCurrentEpsilon.text = [NSString stringWithFormat:@"%hi m", [settings epsilon]];
}

// REIMPLEMENTED METHODS

/** 
 Aktuelle Position anhand des LocationManagers aus dem Objekt GPSCalc
 */
- (void)locationUpdate:(CLLocation *)location {
	[gpsStatus setText:gpsCalc.gpsStatus];
}

- (void)locationError:(NSError *)error {
	
}

// TABLE VIEW METHODS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if(section == 0)
		return 5;
	
	return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case(0):
			return @"Einstellungen";
			break;
		case(1):
			return @"Informationen";
			break;
	}
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
		/**
		if(indexPath.section == 1 && indexPath.row == 2) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		} 
		else if(indexPath.section == 1 && indexPath.row == 1) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		}
		else {
			**/
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		//}
		
	
	[[cell textLabel] setFont: [UIFont systemFontOfSize:13]];
	
	
		if(indexPath.section == 0)
		{
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			if(indexPath.row == 0) {
				
				labelCurrentEpsilon.textAlignment = UITextAlignmentRight;
				labelCurrentEpsilon.backgroundColor = [UIColor clearColor];
				labelCurrentEpsilon.adjustsFontSizeToFitWidth = NO;
				labelCurrentEpsilon.text = [NSString stringWithFormat:@"%hi m", [settings epsilon]];
				labelCurrentEpsilon.font = [UIFont boldSystemFontOfSize:18];
				labelCurrentEpsilon.tag = 30;
				[cell addSubview: labelCurrentEpsilon];
				
				
				[cell.textLabel setText:@"Aktueller Radius:"];
				//[labelCurrentEpsilon release];
			}
			
			if(indexPath.row == 1) {
				
				// Slider zum Einstellen des Suchradius
				UISlider *sliderEpsilon = [[ UISlider alloc ] initWithFrame: CGRectMake(135, 7, 165, 35) ];
				
				sliderEpsilon.minimumValue = 15.0;
				sliderEpsilon.maximumValue = 300.0;
				sliderEpsilon.tag = 31;
				sliderEpsilon.value = settings.epsilon;
				sliderEpsilon.continuous = YES;
				[sliderEpsilon addTarget:self action:@selector(changeEpsilonSlider:) forControlEvents:UIControlEventValueChanged];
				
				[cell addSubview: sliderEpsilon ];
				[cell.textLabel setText:@"Suchradius in m"]; 
				
				[sliderEpsilon release];
			}
			
			if(indexPath.row == 2) {
				UISwitch *switchPlayAudioAutomatic = [[ UISwitch alloc ] initWithFrame: CGRectMake(205, 10, 100, 35) ];
				switchPlayAudioAutomatic.on = settings.playAudioAutomatic;
				switchPlayAudioAutomatic.tag = 32;
				[switchPlayAudioAutomatic addTarget:self action:@selector(setPlayAudioAutomatic:) forControlEvents:UIControlEventValueChanged];
				
				[cell addSubview: switchPlayAudioAutomatic];
				
				[cell.textLabel setText:@"Starte Audio sofort:"];
				[switchPlayAudioAutomatic release];
			}
			
			if(indexPath.row == 3) {
				UISwitch *switchShowVisitedPoisAgain = [[ UISwitch alloc ] initWithFrame: CGRectMake(205, 10, 100, 35) ];
				switchShowVisitedPoisAgain.on = settings.showVisitedPOIsAgain;
				switchShowVisitedPoisAgain.tag = 33;
				[switchShowVisitedPoisAgain addTarget:self action:@selector(setShowVisitedPoisAgain:) forControlEvents:UIControlEventValueChanged];
				
				[cell addSubview: switchShowVisitedPoisAgain];
				
				[cell.textLabel setText:@"Zeige besuchte POIs erneut:"];
				
				[switchShowVisitedPoisAgain release];
			}
			
			if(indexPath.row == 4) {
				UISwitch *switchUseGPS = [[ UISwitch alloc ] initWithFrame: CGRectMake(205, 10, 100, 35) ];
				switchUseGPS.on = settings.useGPS;
				switchUseGPS.tag = 34;
				//switchUseGPS.enabled = NO;
				[switchUseGPS addTarget:self action:@selector(setUseGPS:) forControlEvents:UIControlEventValueChanged];
				
				[cell addSubview: switchUseGPS];
				
				[cell.textLabel setText:@"Nutze GPS Signal:"];
				[switchUseGPS release];
			}
		}
		
		if(indexPath.section == 1)
		{
			
			if(indexPath.row == 0) {
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				
				gpsStatus = [[UILabel alloc] initWithFrame:CGRectMake(150, 4, 130, 35)];
				gpsStatus.textAlignment = UITextAlignmentRight;
				gpsStatus.backgroundColor = [UIColor clearColor];
				gpsStatus.adjustsFontSizeToFitWidth = NO;
				gpsStatus.text = gpsCalc.gpsStatus;
				gpsStatus.font = [UIFont boldSystemFontOfSize:16];
				gpsStatus.tag = 35;
				gpsStatus.textColor = [UIColor lightGrayColor];
				[cell addSubview: gpsStatus];
				
				[cell.textLabel setText:@"GPS Status"];
				[gpsStatus release];
			}
			
			if(indexPath.row == 1) {
				//Read plist file
				NSString *build = [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
				NSString *version = [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
				
				UILabel *textlabel =  [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 250, 35)];
				textlabel.textAlignment = UITextAlignmentRight;
				textlabel.backgroundColor = [UIColor clearColor];
				textlabel.textColor = [UIColor lightGrayColor];
				textlabel.adjustsFontSizeToFitWidth = NO;
				textlabel.text = [[NSString alloc] initWithFormat:@"%@ (Build %@)", version, build];
				textlabel.font = [UIFont boldSystemFontOfSize:14];
				textlabel.tag = 36;
				[cell addSubview: textlabel];
				
				[cell.textLabel setText:@"SoundCity"];
				[textlabel release];
			}
			
			if(indexPath.row == 2) {
				[cell.textLabel setText:@""];
				
				UILabel *textlabel =  [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 300, 140)];
				textlabel.textAlignment = UITextAlignmentLeft;
				textlabel.backgroundColor = [UIColor clearColor];
				textlabel.textColor = [UIColor darkGrayColor];
				textlabel.adjustsFontSizeToFitWidth = NO;
				textlabel.text = @"- inApp Audiostreams abspielen\n- Kartendarstellung mit POIs\n- Tracking des GPS Signals\n- Laden & Auslesen von XML Dateien\n- inApp Videostream\n- Internetverbindung kontrollieren\n- Invidiuelle Tabellendarstellungen";
				textlabel.font = [UIFont systemFontOfSize:14];
				textlabel.tag = 37;
				textlabel.numberOfLines = 9;
				[cell addSubview: textlabel];
				[textlabel release];
			}
		}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch(indexPath.section) {
		case 1:
			
			switch(indexPath.row) {
				case 2:
					return 150;
					break;
			}
			
			break;
	}
	
	return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch(indexPath.section) {
		case 1:
			
			switch(indexPath.row) {
				case 0:
					[self showGPSStatus];
					break;
			}
			
			break;
	}
}


// VIEW METHODS

- (void) showGPSStatus {
	// Setup the animation
	[self.navigationController pushViewController:self.gpsDetailsView animated:YES];
}

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
    [super viewDidLoad];
	
	self.navigationItem.title = @"Einstellungen";
	
	// Singleton der AppSettings auf MapViewController laden
	settings = [AppSettings sharedAppSettings];
	
	//gpsCalc = [[GPSCalculator alloc] init];
	gpsCalc = [GPSCalculator sharedAppGPSCalc];
	gpsCalc.delegate = self;
	[gpsCalc.locationManager startUpdatingLocation];
	
	gpsDetailsView = [[SettingsGPSStatusDetailsViewController alloc] initWithNibName:@"SettingsGPSStatusDetailsViewController" bundle:nil];
	
	labelCurrentEpsilon = [[UILabel alloc] initWithFrame:CGRectMake(170, 7, 130, 35)];
	
	[self.navigationController.toolbar setTranslucent:YES];
	[self.navigationController.navigationBar setTranslucent:YES];
	[self.navigationController.toolbar setTintColor:[UIColor orangeColor]];
	[self.navigationController.navigationBar setTintColor:[UIColor orangeColor]];
	[self.navigationController.navigationBar setAlpha:0.8f];
	[self.navigationController.toolbar setAlpha:0.8f];
	
	[self setValues];
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
	[gpsStatus setText:gpsCalc.gpsStatus];
}

- (void)dealloc {
	[gpsDetailsView release];
    [super dealloc];
}


@end
