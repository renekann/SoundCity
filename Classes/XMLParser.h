//
//  XMLParser.h
//  SoundCity
//
//  Created by René Kann on 23.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SoundCityAppDelegate, POI, Route, RoutePoint;


@interface XMLParser : NSObject {
	NSMutableString *currentElementValue;
	NSString *currentElementTag;
	
	SoundCityAppDelegate *appDelegate;
	POI *poi;
	Route *route;
	RoutePoint *routepoint;
}

@property (nonatomic, retain) POI *poi;
@property (nonatomic, retain) Route *route;
@property (nonatomic, retain) RoutePoint *routepoint;

-(XMLParser *) initXMLParser;

@end
