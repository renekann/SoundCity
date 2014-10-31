//
//  POI.m
//  SoundCity
//
//  Created by René Kann on 12.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "POI.h"
#import "SoundController.h"
#import "MLog.h"
#include <math.h>

@implementation POI

@synthesize pid, title, subtitle, soundURL, coordinate, latitude, longitude, appDelegate, distance, userData, videoURL, details, imageURL, detailsTextLength;

#define MLogString(s,...) \
[MLog logFile:(char *)__FUNCTION__ lineNumber:__LINE__ \
format:(s),##__VA_ARGS__]

- (id) initWithPrimaryKey:(NSInteger) pk {
	
	[super init];
	pid = pk;
	userData = nil;
	[self setDistance:9999999];
	
	return self;
}

- (void)setData:(NSString *)t latitude :(double)lat longitude:(double) lon soundURL:(NSString *) _soundURL {
	latitude = lat;
	longitude = lon;
	self.title = t;
	self.soundURL = _soundURL;
	
	CLLocationCoordinate2D location;
	
	location.latitude = lat;
	location.longitude = lon;
	coordinate = location;
}

-(void)initCoordinate {
	CLLocationCoordinate2D location;
	
	location.latitude = [self latitude];
	location.longitude = [self longitude];
	coordinate = location;
}

- (void)playSound {
	// Globalen Soundcontroller auf lokale Sounddaten setzen
	[self.appDelegate.soundController destroyStreamer];
	[self.appDelegate.soundController setUrl:self.soundURL];
	[self.appDelegate.soundController createStreamer];
	[self.appDelegate.soundController startStream];
}

- (void)stopSound {
	[self.appDelegate.soundController stopStream];
}

- (NSString *)getLatitude {
	return [[NSString alloc] initWithFormat:@"%f", latitude];
}

- (NSString *)getLongitude {
	return [[NSString alloc] initWithFormat:@"%f", longitude];
}
/*
- (void)setDetails:(NSString *)d {
	details = d;
	subtitle = d;
}
 */
/*
- (NSString *)description {
	return [[NSString alloc] initWithFormat:@"POI: %@ | %hi | %@ | %f", self, self.pid, self.title, self.distance];
}
*/
- (BOOL)isEqual:(POI *)poi {
	
	//MLogString(@"Check %@", poi);
	if([poi isMemberOfClass:[POI class]]) {
		if([self pid] == [poi pid]) {
			return YES;
		} else {
			return NO;
		}		
	}
		
	return NO;
}

- (CGContextRef)drawPOI:(CGContextRef)context {
	
	int circleSize = 10;
	int fontSize = (int)(circleSize);
	
	NSString *c_pid = [[NSString alloc] initWithFormat:@"%hi",self.pid];
	
	CGContextSaveGState(context);
	CGContextSetRGBFillColor(context, 0.06,0.31,0.55,1);
	
	CGContextDrawPath(context,kCGPathStroke); 
	CGContextAddArc(context, circleSize + 2, circleSize + 2, circleSize, 0, 2*M_PI, 0);
	CGContextFillPath(context);
	
	int textPosX = (int)(circleSize - fontSize/6);
	int textPosY = circleSize + fontSize/2;
	
	if(c_pid.length == 2) {
		textPosX = (circleSize - fontSize/3);
	}
	
	CGContextSelectFont(context, "Helvetica", fontSize,  kCGEncodingMacRoman);
	CGFloat white[] = {1.0, 1.0, 1.0, 1.0};
	CGContextSetFillColor(context, white);
	CGContextSetTextMatrix (context, CGAffineTransformMake(1, 0, 0, -1, 0, 0));
	CGContextShowTextAtPoint(context, textPosX, textPosY, [c_pid UTF8String], c_pid.length);
	CGContextRestoreGState(context);
	
	return context;
}

- (void) dealloc {
	[title release];
	[soundURL release];
	[super dealloc];
}
@end

