//
//  LogViewController.h
//  SoundCity
//
//  Created by René Kann on 17.11.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@interface LogViewController : UIViewController {
	IBOutlet UITextView *logWindowTextField;
	IBOutlet UIButton *btnLogIt;
}

@property (nonatomic, retain) UITextView *logWindowTextField;
@property (nonatomic, retain) UIButton *btnLogIt;

- (void)setControlls;
- (IBAction)logIt:(id)sender;
- (void)readFile;

@end
