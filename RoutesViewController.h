//
//  RoutesViewController.h
//  SoundCity
//
//  Created by René Kann on 16.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppSettings.h"
#import "SoundCityAppDelegate.h";
#import "Route.h"
#import "POIDetailsViewController.h"
#import "POIListViewController.h";

@interface RoutesViewController : UITableViewController {
	AppSettings *settings;
	SoundCityAppDelegate *appDelegate;
	POIDetailsViewController *poiDetailsView;	
	POIListViewController *poiListView;
	
	IBOutlet UISearchBar *searchBar;
	
	BOOL searching;
	BOOL letUserSelectRow;
}

@property (nonatomic, retain) POIDetailsViewController *poiDetailsView;
@property (nonatomic, retain) POIListViewController *poiListView;
@property (nonatomic, retain) AppSettings *settings;
@property (nonatomic, retain) UISearchBar *searchBar;

- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;

@end
