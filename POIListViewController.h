//
//  POIListViewController.h
//  SoundCity
//
//  Created by René Kann on 12.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POIDetailsViewController.h"
#import "SoundCityAppDelegate.h";
#import "Route.h"

@interface POIListViewController : UITableViewController {
	SoundCityAppDelegate *appDelegate;
	POIDetailsViewController *poiDetailsView;
	Route *route;
}

@property (nonatomic, retain) POIDetailsViewController *poiDetailsView;
@property (nonatomic, retain) Route *route;

@end
