//
//  POIListViewController.m
//  SoundCity
//
//  Created by René Kann on 12.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "POIListViewController.h"
#import "SoundCityAppDelegate.h"
#import "POI.h"

@implementation POIListViewController

@synthesize poiDetailsView, route;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return route.pois.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	POI *poi = (POI *)[route.pois objectAtIndex:indexPath.row];
	
	NSURL *url = [NSURL URLWithString:poi.imageURL];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *image = [[UIImage alloc] initWithData:data];
	
	UILabel *topLabel = [[[UILabel alloc] initWithFrame: CGRectMake(85, -5 , 210, 30)] autorelease];
	UILabel	*descLabel = [[UILabel alloc] initWithFrame: CGRectMake(85, 22 , 210, 30)];
	
	[topLabel setText:poi.title];
	topLabel.backgroundColor = [UIColor clearColor];
	topLabel.textColor = [UIColor orangeColor];
	topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
	
	[descLabel setText:poi.details];
	descLabel.backgroundColor = [UIColor clearColor];
	descLabel.textColor = [UIColor darkGrayColor];
	descLabel.font = [UIFont fontWithName:@"Arial" size:11];
	descLabel.numberOfLines = 2;
	
	for(UIView *subview in cell.contentView.subviews) {
		[subview removeFromSuperview];
	}
	
	[cell.contentView addSubview:topLabel];
	[cell.contentView addSubview:descLabel];
	[cell setImage:image];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic -- create and push a new view controller
	
	POI *poi = (POI *)[route.pois objectAtIndex:indexPath.row];
	
	poiDetailsView = nil;
	poiDetailsView = [[POIDetailsViewController alloc] initWithNibName:@"POIDetailsViewController" bundle:nil];
	poiDetailsView.poi = poi;
	
	// Setup the animation
	[self.navigationController pushViewController:self.poiDetailsView animated:YES];
	
	[poiDetailsView release];
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
   
	appDelegate = (SoundCityAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[self.navigationController setToolbarHidden:YES animated:YES];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	// Button "Karte" hinzfügen
	UIBarButtonItem *btnShowPOIsInMap = [[UIBarButtonItem alloc] initWithTitle:@"Kartensicht"
																			   style:UIBarButtonItemStylePlain 
																			  target:self
																			  action:@selector(showPOIsInMap)];
	
	self.navigationItem.rightBarButtonItem = btnShowPOIsInMap;

	self.title = @"POI Liste";
	
	[super viewDidLoad];
}

- (void)showPOIsInMap {
	[appDelegate setRouteChanged:YES];
	[appDelegate setCurrentRoute:route];
	[appDelegate.tabBarController setSelectedIndex:1]; 
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
    [super dealloc];
}


@end
