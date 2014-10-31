//
//  AppSettings.h
//  SoundCity
//
//  Created by René Kann on 16.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject {
	int epsilon;
	BOOL playAudioAutomatic;
	BOOL showVisitedPOIsAgain;
	BOOL useGPS;
}

@property (nonatomic, readwrite) int epsilon;
@property (nonatomic, readwrite) BOOL playAudioAutomatic;
@property (nonatomic, readwrite) BOOL showVisitedPOIsAgain;
@property (nonatomic, readwrite) BOOL cancelCurrentStreamIfDetailsAppear;
@property (nonatomic, readwrite) BOOL useGPS;

+ (AppSettings *)sharedAppSettings;


@end
