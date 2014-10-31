//
//  AppSettings.m
//  SoundCity
//
//  Created by René Kann on 16.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "AppSettings.h"

@implementation AppSettings

@synthesize epsilon, playAudioAutomatic, showVisitedPOIsAgain, useGPS;
static AppSettings *sharedAppSettingsClass = nil;

+ (AppSettings*)sharedAppSettings
{
    if (sharedAppSettingsClass == nil) {
        sharedAppSettingsClass = [[super allocWithZone:NULL] init];
    }
    return sharedAppSettingsClass;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedAppSettings] retain];
}

/** Standardeinstellungen der Applikation
 */
- (id)init {
	
	self.epsilon = 120;
	self.playAudioAutomatic = YES;
	self.showVisitedPOIsAgain = YES;
	self.useGPS = NO;
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

@end
