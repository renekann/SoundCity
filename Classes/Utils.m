//
//  Utils.m
//  SoundCity
//
//  Created by René Kann on 17.11.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "Utils.h"
#import "MLog.h"


@implementation Utils

#define MLogString(s,...) \
[MLog logFile:(char *)__FUNCTION__ lineNumber:__LINE__ \
format:(s),##__VA_ARGS__]

void FileLog(NSString *format, ...) {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"console.log"];
	freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}

@end
