//
//  SoundStreamController.h
//  SoundCity
//
//  Created by René Kann on 09.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AudioStreamer;

extern NSString * const NOT_YET_PLAYED;
extern NSString * const INITIALIZED;
extern NSString * const PLAYING;
extern NSString * const STOPPED;
extern NSString * const IDLE;
extern NSString * const BUFFERING;
extern NSString * const WAITING_FOR_DATA;
extern NSString * const WAITING_FOR_QUEUE_TO_START;
extern NSString * const PAUSED;

@interface SoundController : NSObject {
	AudioStreamer *streamer;
	NSTimer *progressUpdateTimer;
	NSString *url;
	NSString *soundstate;
}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *soundstate;
@property (nonatomic, retain) AudioStreamer *streamer;

- (void)startStream;
- (void)stopStream;
- (void)destroyStreamer;
- (void)createStreamer;

@end
