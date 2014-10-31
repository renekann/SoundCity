//
//  VideoPlayer.h
//  SoundCity
//
//  Created by René Kann on 06.11.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoPlayer : NSObject {
	NSString *videoURL;
}

@property (nonatomic, retain) NSString *videoURL;

- (void)play;

@end
