//
//  AppDelegate.m
//  flickWord
//
//  Created by SangChan on 2014. 8. 29..
//  Copyright (c) 2014년 sangchan. All rights reserved.
//

#import "AppDelegate.h"
#import "TableViewController.h"
#import "SKViewController.h"
#import "MySpeechObject.h"
#import "EnglishWord.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
    
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    MySpeechObject *speechObject = [MySpeechObject sharedInstance];
    [speechObject prepareSynthesizerWithWord:@"flick word"];
    
    [self makeDictionaryDB];
    RLMResults *words = [self getAllWords];
    
    NSDictionary *wordsWithSection = [self getWordsWithSection:words];
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    TableViewController *mainVC = (TableViewController *)navigationController.topViewController;
    [mainVC setWords:words];
    [mainVC setSectionKeywords:[[wordsWithSection allKeys]sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    [mainVC setWordsWithSection:wordsWithSection];
    
    return YES;
}

- (void)makeDictionaryDB
{
    NSCharacterSet *newlineCharSet = [NSCharacterSet newlineCharacterSet];
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"able.txt"];
    
    NSString* fileContents = [NSString stringWithContentsOfFile:sourcePath
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
    NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:newlineCharSet];
    RLMResults *words = [self getAllWords];
    if (words.count == lines.count) {
        return;
    }
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    int i = 0;
    for (NSString *line in lines) {
        NSArray *words = [line componentsSeparatedByString:@"\t"];
        if([EnglishWord objectsInRealm:realm where:@"word = %@",[words objectAtIndex:0]].count == 0) {
            EnglishWord *word = [[EnglishWord alloc]initWithValue:@{@"wordID": [NSNumber numberWithInt:i], @"word" : [words objectAtIndex:0], @"wordDescription" : [words objectAtIndex:1]}];
            [realm addObject:word];
        }
        i++;
    }
    [realm commitWriteTransaction];
}


- (RLMResults *)getAllWords
{
    RLMResults<EnglishWord *> *realmWords = [EnglishWord allObjects];
    return realmWords;
}

- (NSDictionary *)getWordsWithSection:(RLMResults *)words
{
    NSMutableDictionary *_wordSectionDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *_wordSectionArray;
    for (EnglishWord *word in words) {
        NSString *headCharacter = [[[word word] substringToIndex:1]uppercaseString];
        if ([_wordSectionDictionary objectForKey:headCharacter]) {
            _wordSectionArray = (NSMutableArray *)[_wordSectionDictionary objectForKey:headCharacter];
            [_wordSectionArray addObject:word];
        }
        else {
            _wordSectionArray = [NSMutableArray arrayWithObject:word];
        }
        [_wordSectionDictionary setValue:_wordSectionArray forKey:headCharacter];
    }
    return _wordSectionDictionary;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
