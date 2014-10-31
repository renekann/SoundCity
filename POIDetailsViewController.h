//
//  POIDetailsViewController.h
//  SoundCity
//
//  Created by René Kann on 12.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundCityAppDelegate.h";
#import "VideoPlayer.h"

@class POI;

@interface POIDetailsViewController:UITableViewController {
	
	POI *poi;
	SoundCityAppDelegate *appDelegate;
	AppSettings *settings;
	UIView *footerView;
	VideoPlayer *videoPlayer;
	
	NSArray *contentArray;
	NSArray *sectionArray;
	
	UIButton *buttonSound;
	
}

@property (nonatomic, retain) POI *poi;
@property (nonatomic, readonly) AppSettings *settings;
@property (nonatomic, retain) NSArray *contentArray;
@property (nonatomic, retain) NSArray *sectionArray;
@property (nonatomic, assign) UIView *footerView;
@property (nonatomic, retain) VideoPlayer *videoPlayer;
@property (nonatomic, retain) UIButton *buttonSound;

- (float) calculateHeightOfTextFromWidth:(NSString*) text: (UIFont*)withFont: (float)width :(UILineBreakMode)lineBreakMode;
- (void) reloadTable;

@end
