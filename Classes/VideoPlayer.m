//
//  VideoPlayer.m
//  SoundCity
//
//  Created by René Kann on 06.11.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "VideoPlayer.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation VideoPlayer

@synthesize videoURL;

-(void) play {
	MPMoviePlayerController* film =[[MPMoviePlayerController alloc] initWithContentURL : [NSURL URLWithString: self.videoURL]];
	
	film.scalingMode = MPMovieScalingModeAspectFill;
	film.controlStyle = MPMovieControlStyleDefault;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:film];
	[film play];
}
				   
-(void)myMovieFinishedCallback:(NSNotification *)aNotification {
	MPMoviePlayerController* film = [aNotification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:film];
	[film release];
} 

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}




@end
