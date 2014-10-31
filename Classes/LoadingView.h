//
//  LoadingView.h
//  SoundCity
//
//  Created by René Kann on 03.11.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingView : UIView {
	UILabel *loadingStatus;
	UIActivityIndicatorView *loadingSpinner;
}

@property (nonatomic, retain) UILabel *loadingStatus;

- (void) addLabel;
- (void) addLoadingSpinner;

@end
