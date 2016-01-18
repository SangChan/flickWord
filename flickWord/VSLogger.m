//
//  VSLogger.m
//  flickWord
//
//  Created by SangChan Lee on 1/15/16.
//  Copyright © 2016 sangchan. All rights reserved.
//

#import "VSLogger.h"
#import <asl.h>

static NSString *_bundleName = nil;

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

#pragma mark - Application Log Collection

+ (NSString *)bundleName {
    if (!_bundleName)
        _bundleName = (NSString *)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    
    return _bundleName;
}

+ (void)setBundleName:(NSString *)bundleName {
    _bundleName = bundleName;
}



+ (NSArray *)getConsoleLogEntriesForBundleName:(NSString *)bundleName {
    NSMutableArray *logs = [NSMutableArray array];
    
    aslmsg q, m;
    int i;
    const char *key, *val;
    
    NSString *queryTerm = bundleName;
    
    q = asl_new(ASL_TYPE_QUERY);
    asl_set_query(q, ASL_KEY_SENDER, [queryTerm UTF8String], ASL_QUERY_OP_EQUAL);
    
    aslresponse r = asl_search(NULL, q);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    while (NULL != (m = (&asl_next != NULL) ? asl_next(r) : aslresponse_next(r))) {
#pragma clang diagnostic pop
        
        NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
        
        for (i = 0; (NULL != (key = asl_key(m, i))); i++) {
            NSString *keyString = [NSString stringWithUTF8String:(char *)key];
            
            val = asl_get(m, key);
            
            NSString *string = [NSString stringWithUTF8String:val];
            [tmpDict setObject:string forKey:keyString];
        }
        
        NSString *message = [tmpDict objectForKey:@"Message"];
        if (message)
            [logs addObject:message];
        
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (&asl_free != NULL)
        asl_free(r);
    else
        aslresponse_free(r);
#pragma clang diagnostic pop
    
    return logs;
}

+ (void)getApplicationLog:(void (^)(NSArray *logs))onComplete {
    dispatch_queue_t backgroundQueue = dispatch_queue_create("collect_log", 0);
    dispatch_async(backgroundQueue, ^{
        NSArray *logs = [VSLogger getConsoleLogEntriesForBundleName:[VSLogger bundleName]];
        onComplete(logs);
    });
}

+ (NSString *)applicationLog {
    NSArray *logs = [VSLogger getConsoleLogEntriesForBundleName:[VSLogger bundleName]];
    return [logs componentsJoinedByString:@"\n"];
}

@end
