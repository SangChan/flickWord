//
//  TableViewController.m
//  flickWord
//
//  Created by SangChan on 2015. 2. 17..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import "TableViewController.h"
#import "ViewController.h"
#import "WordDictionary.h"

@interface TableViewController ()

@end

@implementation TableViewController

@synthesize managedObjectContext;
@synthesize words;
@synthesize navBarItems;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"단어선택";
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [words count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    WordDictionary *word = [words objectAtIndex:indexPath.row];
    cell.textLabel.text = [word word];
    cell.detailTextLabel.text = [word word_description];
    return cell;

}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        WordDictionary *word = [words objectAtIndex:indexPath.row];
        //DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        ViewController *controller = (ViewController *)[[segue destinationViewController] topViewController];
        [controller setWord:word];

        //controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}



//-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
//{
//    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f){
//        return;
//    }
//    
//    CGRect frame = self.navigationController.navigationBar.frame;
//    frame.origin.y = 20;
//    
//    if(self.navBarItems.count > 0){
//        [self setNavigationBarHidden:NO];
//    }
//    
//    [self.navigationController.navigationBar setFrame:frame];
//}
//
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f){
//        return;
//    }
//    
//    CGRect frame = self.navigationController.navigationBar.frame;
//    CGFloat size = frame.size.height - 21;
//    
//    if([scrollView.panGestureRecognizer translationInView:self.view].y < 0)
//    {
//        frame.origin.y = -size;
//        
//        if(self.navigationController.navigationBar.items.count > 0){
//            self.navBarItems = [self.navigationController.navigationBar.items copy];
//            [self setNavigationBarHidden:YES];
//        }
//    }
//    else if([scrollView.panGestureRecognizer translationInView:self.view].y > 0)
//    {
//        frame.origin.y = 20;
//        
//        if(self.navBarItems.count > 0){
//            [self setNavigationBarHidden:NO];
//        }
//    }
//    
//    [UIView beginAnimations:@"toggleNavBar" context:nil];
//    [UIView setAnimationDuration:0.2];
//    [self.navigationController.navigationBar setFrame:frame];
//    [UIView commitAnimations];
//}
//
//-(void)setNavigationBarHidden:(BOOL)hidden
//{
//    for (UIView *view in [self.navigationController.navigationBar subviews]) {
//        if (view != [self.navigationController.navigationBar.subviews objectAtIndex:0]) {
//            [view setHidden:hidden];
//        }
//    }
//}

@end
