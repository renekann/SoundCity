//
//  SettingsGPSStatusDetailsViewController.m
//  SoundCity
//
//  Created by René Kann on 02.11.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "AppSettings.h"
#import "SettingsGPSStatusDetailsViewController.h"
#import "GPSCalculator.h"

@implementation SettingsGPSStatusDetailsViewController

@synthesize gpsCalc;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void)viewDidLoad {
	
	gpsCalc = [GPSCalculator sharedAppGPSCalc];
	gpsCalc.delegate = self;
	[gpsCalc.locationManager startUpdatingLocation];
	
	// Hören, wenn sich der Status der GPS Verbindung ändert
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gpsStatusChanged:) name:@"gpsStatusChanged" object:gpsCalc];
	
	[super viewDidLoad];
	
	

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

// REIMPLEMENTED METHODS

/** 
 Aktuelle Position anhand des LocationManagers aus dem Objekt GPSCalc
 */
- (void)locationUpdate:(CLLocation *)location {
	[self.tableView reloadData];
}

-(void)gpsStatusChanged:(NSNotification *)note {
	NSLog(@"GPS Status %@", gpsCalc.gpsStatus);
	[self.tableView reloadData];
}

- (void)locationError:(NSError *)error {
	
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
	[[cell textLabel] setFont: [UIFont systemFontOfSize:13]];
	
	
	if(indexPath.section == 0)
	{
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		if(indexPath.row == 0) {
			[cell.textLabel setText:@"Status"]; 
			[cell.detailTextLabel setText:gpsCalc.gpsStatus];
		}
		
		if(indexPath.row == 1) {
			[cell.textLabel setText:@"Latitude"]; 
			[cell.detailTextLabel setText:[[NSString alloc] initWithFormat:@"%f", gpsCalc.currentLocation.coordinate.latitude]];
		}
		
		if(indexPath.row == 2) {
			[cell.textLabel setText:@"Longitude"]; 
			[cell.detailTextLabel setText:[[NSString alloc] initWithFormat:@"%f", gpsCalc.currentLocation.coordinate.longitude]];
		}
		
		if(indexPath.row == 3) {
			float accuracy = gpsCalc.currentLocation.horizontalAccuracy;
			[cell.textLabel setText:@"Genauigkeit"]; 
			[cell.detailTextLabel setText:[[NSString alloc] initWithFormat:@"%.1f m", accuracy]];
		}
		
	}
	
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"GPS Status Details";
}


- (void)dealloc {
    [super dealloc];
}


@end

