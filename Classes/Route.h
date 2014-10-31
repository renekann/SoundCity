//
//  Route.h
//  SoundCity
//
//  Created by René Kann on 23.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Route : NSObject {
	NSInteger rid;
	NSString *name;
	NSString *image;
	NSString *details;
	NSMutableArray *pois;
	NSMutableArray *routepoints;
	
	NSMutableArray *dummyGPSPoints;
}

@property (nonatomic, readonly) NSInteger rid;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSString *details;
@property (nonatomic, retain) NSMutableArray *pois;
@property (nonatomic, retain) NSMutableArray *routepoints;
@property (nonatomic, retain) NSMutableArray *dummyGPSPoints;

@end
