//
//  DatabaseController.m
//  SoundCity
//
//  Created by René Kann on 14.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "DatabaseController.h"


@implementation DatabaseController

@synthesize databaseName, databasePath;

- (void)openDatabase {
	NSLog(@"Open Databasepath...");
	
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
}

- (void)checkAndCreateDatabase {
	/**
	 BOOL success;
	 NSLog(@"Check Database");	
	 
	 NSFileManager *fileManager = [NSFileManager defaultManager];
	 success = [fileManager fileExistsAtPath:databasePath];
	 
	 if(success) return;
	 
	 
	 
	 
	 NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	 [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	 [fileManager release];
	 **/
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = databasePath;
	NSString *defaultDBPath;
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	if(!success) {
        defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
        if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		
        return; // loaded new file
	}
	
	success = FALSE;
	// compare files
	defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	success = [fileManager contentsEqualAtPath: defaultDBPath andPath: dbPath ];
	
	if(!success) { // files not same
        // delete old file first
        [fileManager removeItemAtPath:dbPath error:&error];
		
		
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
        if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
	
	NSLog(@"Checked Database");
}

@end
