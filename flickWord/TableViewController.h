//
//  TableViewController.h
//  flickWord
//
//  Created by SangChan on 2015. 2. 17..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController

@property (nonatomic,strong) NSArray *words;
@property (strong, nonatomic) NSArray *navBarItems;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
