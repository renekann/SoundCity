//
//  RoutesViewController.m
//  SoundCity
//
//  Created by René Kann on 16.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "RoutesViewController.h"
#import "MLog.h"

@implementation RoutesViewController

@synthesize settings, poiListView, poiDetailsView, searchBar;

#define MLogString(s,...) \
[MLog logFile:(char *)__FUNCTION__ lineNumber:__LINE__ \
format:(s),##__VA_ARGS__]

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return appDelegate.routes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
    // Set up the cell
	Route *route = (Route *)[appDelegate.routes objectAtIndex:indexPath.row];
	
	NSURL *url = [NSURL URLWithString:route.image];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *image = [[UIImage alloc] initWithData:data];
	
	UILabel *topLabel = [[[UILabel alloc] initWithFrame: CGRectMake(image.size.width + 5, -5 , 255, 30)] autorelease];
	UILabel	*descLabel = [[UILabel alloc] initWithFrame: CGRectMake(image.size.width + 5, 25 , 210, 30)];
	
	NSLog(@"Route name %@", route.name);
	[topLabel setText:route.name];
	topLabel.backgroundColor = [UIColor clearColor];
	topLabel.textColor = [UIColor purpleColor];
	topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
	
	[descLabel setText:route.details];
	descLabel.backgroundColor = [UIColor clearColor];
	descLabel.textColor = [UIColor darkGrayColor];
	descLabel.font = [UIFont fontWithName:@"Arial" size:11];
	descLabel.numberOfLines = 2;
	
	for(UIView *subview in cell.contentView.subviews) {
		[subview removeFromSuperview];
	}
	
	[cell.contentView addSubview:topLabel];
	[cell.contentView addSubview:descLabel];
	[cell.imageView setImage:image];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic -- create and push a new view controller
	
	Route *route = (Route *)[appDelegate.routes objectAtIndex:indexPath.row];
	
	self.poiListView = nil;
	self.poiListView = [[POIListViewController alloc] initWithNibName:@"POIListViewController" bundle:nil];
	poiListView.route = route;
	
	// Setup the animation
	[self.navigationController pushViewController:self.poiListView animated:YES];
	
	[poiListView release];
	[tableView deselectRowAtIndexPath:indexPath animated:YES]; 
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

- (void) addControls {
	
	NSArray *itemArray = [NSArray arrayWithObjects: @"Fertige Routen", @"Eigene Routen", nil];
	
	// Toolbarbuttons
	
	UISegmentedControl *routeControll = [[UISegmentedControl alloc] initWithItems:itemArray];
	routeControll.frame = CGRectMake(0, 0, 235, 25);
	routeControll.segmentedControlStyle = UISegmentedControlStyleBar;
	routeControll.selectedSegmentIndex = 0;
	[routeControll addTarget:self  action:@selector(pickRouteView:) forControlEvents:UIControlEventValueChanged];
	
	UIBarButtonItem *segmentedControlBarItem = [[UIBarButtonItem alloc] initWithCustomView: routeControll];
	
	
	// Navigationbar Buttons
	
	UIBarButtonItem *btnReloadXML = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadXML:)];
	
	//self.navigationItem.rightBarButtonItem = btnReloadXML;
	//self.toolbarItems = [NSArray arrayWithObjects:btnReloadXML,segmentedControlBarItem, nil];
	self.toolbarItems = [NSArray arrayWithObjects:btnReloadXML, nil];
	
	[routeControll release];
	[btnReloadXML release];
	[segmentedControlBarItem release];
}

- (void) reloadXML:(id)sender {
	[appDelegate reloadXML];
}

- (void) pickRouteView:(id)sender{
	//UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	//NSLog(@"SEGMENTED CONTROL %@", [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]]);
}

- (void)handleXMLReloaded:(NSNotification *)note {
	
	NSNumber *success = [[note userInfo] objectForKey:@"loadingStatus"];
	
	if([success intValue] == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Routen neu laden" message:@"Fehler beim Laden der Routen. Keine Internetverbindung?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show]; 
		[alert release];
	}
	
	[self.tableView reloadData];
	[self.tableView setNeedsDisplay];
}

// SEARCHING THE TABLE

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	
	//Remove all objects first.
	//[copyListOfItems removeAllObjects];
	
	if([searchText length] > 0) {
		
		searching = YES;
		letUserSelectRow = YES;
		self.tableView.scrollEnabled = YES;
		[self searchTableView];
	}
	else {
		
		searching = NO;
		letUserSelectRow = NO;
		self.tableView.scrollEnabled = NO;
	}
	
	[self.tableView reloadData];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	searching = YES;
	letUserSelectRow = NO;
	self.tableView.scrollEnabled = NO;
	
	//Add the done button.
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
											   target:self action:@selector(doneSearching_Clicked:)] autorelease];
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(letUserSelectRow)
		return indexPath;
	else
		return nil;
}

- (void) doneSearching_Clicked:(id)sender {
	
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.rightBarButtonItem = nil;
	self.tableView.scrollEnabled = YES;
	
	[self.tableView reloadData];
}

- (void) searchTableView {
	/*
	NSString *searchText = searchBar.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	
	for (NSDictionary *dictionary in listOfItems)
	{
		NSArray *array = [dictionary objectForKey:@"Countries"];
		[searchArray addObjectsFromArray:array];
	}
	
	for (NSString *sTemp in searchArray)
	{
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		if (titleResultsRange.length > 0)
			[copyListOfItems addObject:sTemp];
	}
	
	[searchArray release];
	searchArray = nil;
	 */
}

// END SEARCHING


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	// Hole Delegator der App
	appDelegate = (SoundCityAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// Hole Settings aus der AppSettings, hängt in AppDelegator
	settings = [[AppSettings alloc] init];
	
	[self addControls];
	
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	self.navigationItem.title = @"Routen";
	self.tabBarItem.title = @"Routen";

	// Notification Center konnectieren und auf Meldungen warten
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(handleXMLReloaded:) name:@"XMLReloaded" object:nil];
	
	searching = NO;
	letUserSelectRow = YES;
	
	[self.navigationController.toolbar setTranslucent:YES];
	[self.navigationController.navigationBar setTranslucent:YES];
	[self.navigationController.toolbar setTintColor:[UIColor orangeColor]];
	[self.navigationController.navigationBar setTintColor:[UIColor orangeColor]];
	[self.navigationController.navigationBar setAlpha:0.8f];
	[self.navigationController.toolbar setAlpha:0.8f];
	
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	[self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
	//[self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {

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
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	
    [super dealloc];
}


@end
