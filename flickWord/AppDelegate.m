//
//  AppDelegate.m
//  flickWord
//
//  Created by SangChan on 2014. 8. 29..
//  Copyright (c) 2014년 sangchan. All rights reserved.
//

#import "AppDelegate.h"
#import "TableViewController.h"
#import "WordDictionary.h"
#import "SKViewController.h"
#import "MySpeechObject.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    MySpeechObject *speechObject = [MySpeechObject sharedInstance];
    [speechObject prepareSynthesizerWithWord:@"flick word"];
    
    NSArray *words = [self getWords];
    if ([words count] == 0) {
        [self makeDictionaryDB];
        words = [self getWords];
    }
    NSDictionary *wordsWithSection = [self getWordsWithSection:words];
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    TableViewController *mainVC = (TableViewController *)navigationController.topViewController;
    //[mainVC setManagedObjectContext:self.managedObjectContext];
    [mainVC setWords:words];
    [mainVC setSectionKeywords:[[wordsWithSection allKeys]sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    [mainVC setWordsWithSection:wordsWithSection];
    
    return YES;
}

- (void)makeDictionaryDB
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    NSCharacterSet *newlineCharSet = [NSCharacterSet newlineCharacterSet];
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"able.txt"];
    
    NSString* fileContents = [NSString stringWithContentsOfFile:sourcePath
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
    NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:newlineCharSet];
    
    int i = 0;
    for (NSString *line in lines) {
        NSLog(@"%d:%@",i,line);
        NSArray *words = [line componentsSeparatedByString:@"\t"];
        for (NSString *word in words) {
            NSLog(@"%@",word);
        }
        NSManagedObject *wordInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Dictionary" inManagedObjectContext:context];
        [wordInfo setValue:[words objectAtIndex:0] forKey:@"word"];
        [wordInfo setValue:[words objectAtIndex:1] forKey:@"word_description"];
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        i++;
    }
}

- (NSArray *)getWords
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dictionary" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *words = [context executeFetchRequest:fetchRequest error:&error];
    return words;
}

- (NSDictionary *)getWordsWithSection:(NSArray *)words
{
    NSMutableDictionary *_wordSectionDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *_wordSectionArray;
    for (WordDictionary *word in words) {
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
//    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
//    if ([navigationController.visibleViewController isKindOfClass:[SKViewController class]]) {
//        SKViewController *skVC = (SKViewController *)navigationController.visibleViewController;
//        SKView *skView = (SKView *)skVC.view;
//        skView.paused = YES;
//    }
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
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.verandastudio.TestCoreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WordDictionary" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WordDictionary.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
