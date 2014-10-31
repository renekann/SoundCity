//
//  XMLParser.m
//  SoundCity
//
//  Created by René Kann on 23.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "XMLParser.h"
#import "SoundCityAppDelegate.h"
#import "POI.h"
#import "Route.h"
#import "RoutePoint.h"

@implementation XMLParser

@synthesize route, poi, routepoint;

- (XMLParser *) initXMLParser {
	
	[super init];
	currentElementTag = [[NSString alloc] init];
	
	appDelegate = (SoundCityAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"routes"]) {
		currentElementTag = @"routes";
	}
	
	if([elementName isEqualToString:@"route"]) {
		route = [[Route alloc] init];
		
		currentElementTag = @"route";
		//NSLog(@"<route> gefunden");
	}
	
	if([elementName isEqualToString:@"routepoints"]) {
		currentElementTag = @"routepoints";
		//NSLog(@"<routepoints> gefunden");
	}
	
	if([elementName isEqualToString:@"point"]) {
		routepoint = [[RoutePoint alloc] init]; 
		currentElementTag = @"point";
		//NSLog(@"<point> gefunden. RoutePoint init");
	}
	
	if([elementName isEqualToString:@"poi"]) {
		//NSLog(@"<poi> gefunden");
		
		poi = [[POI alloc] init];
		currentElementTag = @"poi";
	}
	
	//NSLog(@"Processing Element: %@", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else if(string != nil) {
		[currentElementValue appendString:string];
		//[currentElementValue  appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
	}
	
	//NSLog(@"currentElementValue: %@", currentElementValue);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	//NSLog(@" elementName %@ %@", elementName, currentElementValue);
	
	if([elementName isEqualToString:@"pois"])
		return;
	
	if([elementName isEqualToString:@"routepoints"])
		return;
	
	if([elementName isEqualToString:@"\n"]) 
	return;
	
	/* Zeiger befindet sich im Tag "poi"
	 * values sind: pid, title, soundURL, latitude, longitude
	 */
	if([currentElementTag isEqualToString:@"poi"]) {
		
		if([elementName isEqualToString:@"latitude"]) {
			[poi setLatitude:[currentElementValue doubleValue]];
		}
		else if([elementName isEqualToString:@"longitude"]) {
			[poi setLongitude:[currentElementValue doubleValue]];
		}
		else if([elementName isEqualToString:@"pid"]) {
			[poi setPid:[currentElementValue intValue]];
		}
		else {
			if(currentElementValue != nil) {
				[poi setValue:currentElementValue forKey:elementName];
			}
		}
	}
	
	/* Zeiger befindet sich im Tag "route"
	 * values sind: name, description, image
	 * untertags sind: routepoints, pois
	 */
	//NSLog(@"Routen Element %@ %@ %@ ", elementName, currentElementValue, currentElementTag);
	
	
	if([currentElementTag isEqualToString:@"route"]) {
		
		if([elementName isEqualToString:@"name"] || [elementName isEqualToString:@"image"] || [elementName isEqualToString:@"details"]) {
			[route setValue:currentElementValue forKey:elementName];
		}
	}
	
	/* Zeiger befindet sich im Tag "point"
	 * values sind: latitude, longitude
	 */
	if([currentElementTag isEqualToString:@"point"]) {
		//NSLog(@"RoutePoint Element %@ %@", elementName, currentElementValue);
		
		if([elementName isEqualToString:@"latitude"]) {
			[routepoint setLatitude:[currentElementValue doubleValue]];
		}
		else if([elementName isEqualToString:@"longitude"]) {
			[routepoint setLongitude:[currentElementValue doubleValue]];
		}
		else {
			if(currentElementValue != nil) {
				//[routepoint setValue:currentElementValue forKey:elementName];
			}
		}
	}
		
	// Abfragen, wenn ein Zweig geschlossen wird
	
	if([elementName isEqualToString:@"route"]) {
		//NSLog(@"</route> gefunden %@", route);
		
		[appDelegate.routes addObject:route];
		
		[route release];
		route = nil;
	}
	
	if([elementName isEqualToString:@"point"]) {
		//NSLog(@"</point> gefunden %@", routepoint);
		
		[routepoint initCoordinate];
		[route.routepoints addObject:routepoint];
		
		[routepoint release];
		routepoint = nil;
	}
	
	if([elementName isEqualToString:@"poi"]) {
		NSLog(@"</poi> gefunden");
		
		//NSLog(@"XML Parser Poi Details -> %@", poi.details);
		
		[poi initCoordinate];
		[poi setAppDelegate:appDelegate];
		
		[route.pois addObject:poi];
		
		[poi release];
		poi = nil;
	}
	
	[currentElementValue release];
	currentElementValue = nil;
}


@end
