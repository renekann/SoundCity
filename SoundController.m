//
//  SoundController.m
//  SoundCity
//
//  Created by René Kann on 09.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "SoundController.h"
#import "AudioStreamer.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>

NSString * const NOT_YET_PLAYED = @"NOT_YET_PLAYED";
NSString * const INITIALIZED = @"INITIALIZED";
NSString * const PLAYING = @"PLAYING";
NSString * const STOPPED = @"STOPPED";
NSString * const IDLE = @"IDLE";
NSString * const BUFFERING = @"BUFFERING";
NSString * const WAITING_FOR_DATA = @"WAITING_FOR_DATA";
NSString * const WAITING_FOR_QUEUE_TO_START = @"WAITING_FOR_QUEUE_TO_START";
NSString * const PAUSED = @"PAUSED";

@implementation SoundController

@synthesize url, soundstate, streamer;

- (id)init {
	soundstate = [[NSString alloc] init];
	[self setSoundstate:NOT_YET_PLAYED];
	return self;
}

-(void)startStream {
	[streamer start];
}

-(void)stopStream {
	[streamer stop];
}

/** Notifications empfangen */

- (void)handleStreamStatus:(NSNotification *)note {
	
}

//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	if (streamer)
	{
		/**
		 [[NSNotificationCenter defaultCenter]
		 removeObserver:self
		 name:ASStatusChangedNotification
		 object:streamer];
		 [progressUpdateTimer invalidate];
		 progressUpdateTimer = nil;
		 **/
		
		[streamer stop];
		[streamer release];
		streamer = nil;
	}
}

//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamer
{
	if (streamer)
	{
		return;
	}
	
	//[streamer setDelegate:self];
	[self destroyStreamer];
	
	
	NSString *escapedValue =
	[(NSString *)CFURLCreateStringByAddingPercentEscapes(
														 nil,
														 (CFStringRef) url,
														 NULL,
														 NULL,
														 kCFStringEncodingUTF8)
	 autorelease];
	
	NSURL *tmpurl = [NSURL URLWithString:escapedValue];
	streamer = [[AudioStreamer alloc] initWithURL:tmpurl];
	
	/**
	 progressUpdateTimer =
	 [NSTimer
	 scheduledTimerWithTimeInterval:0.1
	 target:self
	 selector:@selector(updateProgress:)
	 userInfo:nil
	 repeats:YES];
	  **/
	
	 [[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(playbackStateChanged:)
	 name:ASStatusChangedNotification
	 object:streamer];
	
}

//
// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	NSLog(@"SoundState %hi", streamer.state);
	
	if (streamer.state == 0)
	{
		[self setSoundstate:INITIALIZED];
	}
	
	if (streamer.state == 2)
	{
		[self setSoundstate:WAITING_FOR_DATA];
	}
	
	if (streamer.state == 3)
	{
		[self setSoundstate:WAITING_FOR_QUEUE_TO_START];
	}
	
	if (streamer.state == 4)
	{
		[self setSoundstate:PLAYING];
	}
	
	if (streamer.state == 5)
	{
		[self setSoundstate:BUFFERING];
	}
	
	if (streamer.state == 7)
	{
		[self setSoundstate:STOPPED];
	}
	
	if (streamer.state == 8)
	{
		[self setSoundstate:PAUSED];
	}
	
	NSDictionary *d = [NSDictionary dictionaryWithObject:soundstate forKey:@"soundstate"];
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"soundStateChanged" object:self userInfo:d];

}

- (void)dealloc {
	[super dealloc];
}


@end
