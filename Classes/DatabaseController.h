//
//  DatabaseController.h
//  SoundCity
//
//  Created by René Kann on 14.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DatabaseController : NSObject {
	NSString *databaseName;
	NSString *databasePath;
}

@property (nonatomic, retain) NSString *databasePath;
@property (nonatomic, retain) NSString *databaseName;

- (void)openDatabase;
- (void)checkAndCreateDatabase;

@end
