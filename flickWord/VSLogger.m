//
//  VSLogger.m
//  flickWord
//
//  Created by SangChan Lee on 1/15/16.
//  Copyright © 2016 sangchan. All rights reserved.
//

#import "VSLogger.h"

@implementation VSLogger

+(void)initialize {
    [super initialize];
}

+(void)log:(NSString *)format, ... {
    
    @try {
        if (format != nil) {
            va_list args;
            va_start(args, format);
            NSLogv(format, args);
            va_end(args);
        }
    } @catch (...) {
        NSLogv(@"Caught an exception in VSLogger", nil);
    }
    
}

@end
