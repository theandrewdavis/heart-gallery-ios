//
//  HGChildTableViewController.m
//  ToyJsonTable
//
//  Created by Andrew Davis on 6/15/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGChildTableViewController.h"
#import "HGDataController.h"
#import "HGChildViewController.h"
#import "SVProgressHUD.h"
#import "CKRefreshControl.h"
#import "HGChild.h"
#import "HGWebImageView.h"

static int kTableRowHeight = 90;
static int kCellImageTag = 1;
static int kCellLabelTag = 2;
static int kCellLabelLeftMargin = 10;
static int kCellLabelRightMargin = 20;

@implementation HGChildTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = kTableRowHeight;
    
    // Set the title of the navigation controller.
    self.navigationItem.title = @"Children";
    
    // Display the children stored on the device.
    self.dataController.delegate = self;
    [self.dataController fetchLocalData];
    
    // Set up pull to refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self.dataController action:@selector(fetchRemoteData) forControlEvents:UIControlEventValueChanged];
    
    // Get updates from the web and start the pull to refresh spinner.
    [self.refreshControl beginRefreshing];
    [self.dataController fetchRemoteData];
}

// Set the number of sections in the table.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataController.fetchedResultsController.sections.count;
}

// Set the number of rows in each section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataController.fetchedResultsController.sections[section] numberOfObjects];
}

// Create a cell for the given section and row.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ChildTableCell";

    // Get a cached cell layout if it is availble. Create one if it is not yet available.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        // Create child thumbnail image.
        HGWebImageView *imageView = [[HGWebImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.rowHeight - 1, tableView.rowHeight - 1)];
        imageView.tag = kCellImageTag;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setClipsToBounds:YES];
        [cell.contentView addSubview:imageView];
        
        // Create label for child name.
        CGFloat labelWidth = tableView.bounds.size.width - tableView.rowHeight - kCellLabelLeftMargin - kCellLabelRightMargin;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tableView.rowHeight + kCellLabelLeftMargin, 0, labelWidth, tableView.rowHeight)];
        label.tag = kCellLabelTag;
        label.font = [UIFont boldSystemFontOfSize:20];
        label.numberOfLines = 0;
        [cell.contentView addSubview:label];
    }
    
    // Fill out the cached cell with the child's name and image.
    HGChild *child = (HGChild *)[self.dataController.fetchedResultsController objectAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:kCellLabelTag];
    HGWebImageView *imageView = (HGWebImageView *)[cell.contentView viewWithTag:kCellImageTag];
    label.text = child.name;
    imageView.url = [NSURL URLWithString:child.thumbnail];

    return cell;
}

// On selection, show a detail view of the child.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HGChild *child = [self.dataController.fetchedResultsController objectAtIndexPath:indexPath];
    HGChildViewController *childViewController = [[HGChildViewController alloc] init];
    childViewController.child = child; //[self.dataController.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:childViewController animated:YES];
}

// When the fetched results controller's data changes, update the table with the new data.
- (void)dataDidChange:(NSFetchedResultsController *)fetchedResultsController {
    [self.tableView reloadData];
}

// Hide the spinner when a remote request completes successfully.
- (void)remoteRequestSuccess {
    [self hidePullToRefresh];
}

// Hide the spinner and show an error message when a remote request fails.
- (void)remoteRequestFailure {
    [self hidePullToRefresh];
    [SVProgressHUD showErrorWithStatus:@"Could not connect"];
}

// Hide the pull to refresh spinner.
- (void)hidePullToRefresh {
    [self.refreshControl performSelector:@selector(endRefreshing) withObject:nil];
}

@end
