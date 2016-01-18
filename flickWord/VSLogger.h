//
//  VSLogger.h
//  flickWord
//
//  Created by SangChan Lee on 1/15/16.
//  Copyright © 2016 sangchan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VSLog( format, ... )    [VSLogger log:[NSString stringWithFormat:(f), ##__VA_ARGS__]]

#ifdef VSLOGGER_SWIZZLE_NSLOG
#define NSLog( s, ... )		VSLog( s, ##__VA_ARGS__ )
#endif

@interface VSLogger : NSObject

+ (void)log:(NSString *)format, ...; 
+ (void)getApplicationLog:(void (^)(NSArray *logs))onComplete;
+ (NSString *)applicationLog;

@end
