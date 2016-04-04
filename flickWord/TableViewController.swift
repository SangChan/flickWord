//
//  TableViewController.swift
//  flickWord
//
//  Created by SangChan Lee on 4/4/16.
//  Copyright © 2016 sangchan. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController,UIGestureRecognizerDelegate {
    //var sectionKeywords;
    //var wordsWithSection;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Flick Word"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.enabled = false;
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationController?.interactivePopGestureRecognizer?.enabled = false;
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.enabled = true;
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //NSArray *sectionArray = [wordsWithSection objectForKey:[sectionKeywords objectAtIndex:section]];
        //return [sectionArray count];
        return 0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //return [sectionKeywords count];
        return 1
    }
    
    
//    
//    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
//    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
//    
//    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//    {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    
//    //WordDictionary *word = [words objectAtIndex:indexPath.row];
//    NSArray *sectionArray = [wordsWithSection objectForKey:[sectionKeywords objectAtIndex:indexPath.section]];
//    EnglishWord *word = [sectionArray objectAtIndex:indexPath.row];
//    cell.textLabel.text = [word word];
//    cell.detailTextLabel.text = [word wordDescription];
//    return cell;
//    
//    }
//    
//    - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//    {
//    return [sectionKeywords objectAtIndex:section];
//    }
//    
//    - (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//    {
//    return sectionKeywords;
//    }
//    
//    #pragma mark - Segues
//    
//    - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:@"showDetail"]) {
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    NSArray *sectionArray = [wordsWithSection objectForKey:[sectionKeywords objectAtIndex:indexPath.section]];
//    EnglishWord *word = [sectionArray objectAtIndex:indexPath.row];
//    
//    if ([[segue destinationViewController] isKindOfClass:[SKViewController class]]) {
//    SKViewController *vc = (SKViewController *)[segue destinationViewController];
//    [vc setWord:word];
//    }
//    else {
//    NSArray *childArray = [[segue destinationViewController] childViewControllers];
//    for (id vc in childArray) {
//    if ([vc isKindOfClass:[SKViewController class]]) {
//    [(SKViewController *)vc setWord:word];
//    break;
//    }
//    }
//    }
//    }
//    }
}
