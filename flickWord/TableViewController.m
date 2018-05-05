//
//  TableViewController.m
//  flickWord
//
//  Created by SangChan on 2015. 2. 17..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import "TableViewController.h"
#import "SKViewController.h"
#import "EnglishWord.h"

@interface TableViewController ()

@end

@implementation TableViewController

@synthesize words;
@synthesize sectionKeywords;
@synthesize wordsWithSection;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FlickWord";
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Disable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Disable iOS 8 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    // Enable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = [wordsWithSection objectForKey:[sectionKeywords objectAtIndex:section]];
    return [sectionArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sectionKeywords count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //WordDictionary *word = [words objectAtIndex:indexPath.row];
    NSArray *sectionArray = [wordsWithSection objectForKey:[sectionKeywords objectAtIndex:indexPath.section]];
    EnglishWord *word = [sectionArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [word word];
    cell.detailTextLabel.text = [word wordDescription];
    return cell;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionKeywords objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return sectionKeywords;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSArray *sectionArray = [wordsWithSection objectForKey:[sectionKeywords objectAtIndex:indexPath.section]];
        EnglishWord *word = [sectionArray objectAtIndex:indexPath.row];
        
        if ([[segue destinationViewController] isKindOfClass:[SKViewController class]]) {
            SKViewController *vc = (SKViewController *)[segue destinationViewController];
            [vc setWord:word];
        }
        else {
            NSArray *childArray = [[segue destinationViewController] childViewControllers];
            for (id vc in childArray) {
                if ([vc isKindOfClass:[SKViewController class]]) {
                    [(SKViewController *)vc setWord:word];
                    break;
                }
            }
        }
    }
}
@end
