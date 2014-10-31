//
//  MLog.m
//  SoundCity
//
//  Created by René Kann on 02.11.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "MLog.h"

static BOOL __MLogOn=NO;

@implementation MLog
+(void)initialize
{
	char * env=getenv("MLogOn");
	if(strcmp(env==NULL?"":env,"NO")!=0)
		__MLogOn=YES;
}

+(void)logFile:(char*)sourceFile lineNumber:(int)lineNumber format:(NSString*)format, ...;
{
	va_list ap;
	NSString *print,*file;
	
	if(__MLogOn==NO)
		return;
	va_start(ap,format);
	file=[[NSString alloc] initWithBytes:sourceFile 
								  length:strlen(sourceFile) 
								encoding:NSUTF8StringEncoding];
	
	//function = [NSString stringWithCString: fName];
	
	print=[[NSString alloc] initWithFormat:format arguments:ap];
	
	
	va_end(ap);
	//NSLog handles synchronization issues
	NSLog(@"%s > %d: %@",[[file lastPathComponent] UTF8String], lineNumber,print);
	
	// Notification senden
	NSDictionary *d = [NSDictionary dictionaryWithObject:print forKey:@"logtext"];
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"Log" object:self userInfo:d];
	
	[print release];
	//[function release];
	[file release];
	
	return;
}

+(void)setLogOn:(BOOL)logOn
{
	__MLogOn=logOn;
}



@end
