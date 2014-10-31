//
//  MLog.h
//  SoundCity
//
//  Created by René Kann on 02.11.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MLog : NSObject
{
}
+(void)logFile:(char*)sourceFile lineNumber:(int)lineNumber format:(NSString*)format, ...;
+(void)setLogOn:(BOOL)logOn;
@end

