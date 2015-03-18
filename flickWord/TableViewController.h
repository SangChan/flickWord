//
//  TableViewController.h
//  flickWord
//
//  Created by SangChan on 2015. 2. 17..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController <UIGestureRecognizerDelegate>

@property (nonatomic,strong) NSArray *words;
@property (nonatomic,strong) NSArray *sectionKeywords;
@property (nonatomic,strong) NSDictionary *wordsWithSection;
@end
