//
//  TrackRouteSaveViewController.h
//  SoundCity
//
//  Created by René Kann on 29.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Route.h"

@interface TrackRouteSaveViewController : UITableViewController {
	Route *route;
}

@property (nonatomic, retain) Route *route;

@end
