//
//  LoadingView.m
//  SoundCity
//
//  Created by René Kann on 03.11.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "LoadingView.h"


@implementation LoadingView

@synthesize loadingStatus;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
	
	[self setBackgroundColor:[UIColor grayColor]];
	[self setAlpha:0.65];
		
    return self;
}

- (void) addLabel {
	
	CGRect cgRect =[[UIScreen mainScreen] bounds];
	CGSize cgSize = cgRect.size;
	
	loadingStatus = [[[UILabel alloc] initWithFrame: CGRectMake(0, cgSize.height/2 + 20 , 320, 50)] autorelease];
	loadingStatus.text = @"Daten werden geladen...";
	loadingStatus.backgroundColor = [UIColor clearColor];
	loadingStatus.textColor = [UIColor whiteColor];
	loadingStatus.font = [UIFont fontWithName:@"Arial" size:20];
	loadingStatus.textAlignment = UITextAlignmentCenter;
	
	[self addSubview:loadingStatus];	
}

- (void) addLoadingSpinner {
	CGRect cgRect =[[UIScreen mainScreen] bounds];
	CGSize cgSize = cgRect.size;
	
	loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[loadingSpinner startAnimating];
	[loadingSpinner setCenter:CGPointMake(cgSize.width/2, cgSize.height/2)];
	[self addSubview:loadingSpinner];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
