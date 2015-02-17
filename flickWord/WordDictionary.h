//
//  TestCoreData.h
//  TestCoreData
//
//  Created by SangChan on 2015. 2. 17..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WordDictionary : NSManagedObject

@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSString * word_description;

@end
