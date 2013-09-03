//
//  HGChildTableViewController.m
//  ToyJsonTable
//
//  Created by Andrew Davis on 6/15/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGChildTableViewController.h"
#import "HGRemoteDataController.h"
#import "HGChildViewController.h"
#import "SVProgressHUD.h"
#import "CKRefreshControl.h"
#import "HGWebImageView.h"
#import "HGFilterViewController.h"

static NSInteger kTableRowHeight = 90;
static NSInteger kCellImageTag = 1;
static NSInteger kCellLabelTag = 2;
static NSInteger kCellLabelLeftMargin = 10;
static NSInteger kCellLabelRightMargin = 20;
static NSInteger kChildFetchRequestBatchSize = 40;
static NSInteger kSearchBarHeight = 44;

@interface HGChildTableViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) HGFilterViewController *filterViewController;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSPredicate *filterPredicate;
@property (nonatomic, strong) NSPredicate *searchPredicate;
@property (nonatomic) BOOL clearButtonClicked;
@end

@implementation HGChildTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.rowHeight = kTableRowHeight;

    // Set the title of the navigation controller.
    self.navigationItem.title = @"Children";

    // Add a filter button to the navigation bar.
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filter)];
    self.navigationItem.rightBarButtonItem = filterButton;

    // Save a filter view controller so that it's lifecycle will be tied to the lifecycle of this view controller.
    self.filterViewController = [[HGFilterViewController alloc] init];
    self.filterViewController.delegate = self;

    // Add a search bar to the table header.
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kSearchBarHeight)];
    self.tableView.tableHeaderView = self.searchBar;
    self.searchBar.delegate = self;
    for(UIView *subView in self.searchBar.subviews) {
        if([subView conformsToProtocol:@protocol(UITextInputTraits)]) {
            [(UITextField *)subView setEnablesReturnKeyAutomatically:NO];
            [(UITextField *)subView setReturnKeyType:UIReturnKeyDone];
        }
    }

    // Display the children stored on the device. Show all children by default.
    self.clearButtonClicked = NO;
    self.filterPredicate = [NSPredicate predicateWithValue:YES];
    self.searchPredicate = [NSPredicate predicateWithValue:YES];
    [self updateTable];

    // Set up pull to refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.remoteDataController.delegate = self;
    [self.refreshControl addTarget:self.remoteDataController action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];

    // If data is more than a day old, get updates from the web and start the pull to refresh spinner.
    if ([self.remoteDataController isDataStale]) {
        [self.refreshControl beginRefreshing];
        [self.remoteDataController fetchData];
    }
}

// Update table view to display children that pass the filter and search predicates.
- (void)updateTable {
    // Create a new fetched results controller.
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Child"];
    NSSortDescriptor *sortNameAscending = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortNameAscending];
    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[self.searchPredicate, self.filterPredicate]];
    request.fetchBatchSize = kChildFetchRequestBatchSize;
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;

    // Perform the fetch.
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Fetch request failed: %@, %@", error.localizedDescription, error.userInfo);
    }

    // Reload the table to display results.
    [self.tableView reloadData];
}

// Open a filter view to create a filter to pass to the fetched results controller.
- (void)filter {
    [self.navigationController presentModalViewController:self.filterViewController animated:YES];
}

// Hide the pull to refresh spinner.
- (void)hidePullToRefresh {
    [self.refreshControl performSelector:@selector(endRefreshing) withObject:nil];
}

#pragma mark - HGRemoteDataControllerDelegate

// Hide the spinner when a remote request completes successfully.
- (void)remoteRequestSuccess {
    [self hidePullToRefresh];
}

// Hide the spinner and show an error message when a remote request fails.
- (void)remoteRequestFailure {
    [self hidePullToRefresh];
    [SVProgressHUD showErrorWithStatus:@"Could not connect"];
}

#pragma mark - HGFilterViewControllerDelegate

// Reload table data when a new filter is selected.
- (void)didChangePredicate:(NSPredicate *)predicate {
    self.filterPredicate = predicate;
    [self updateTable];
}

#pragma mark - NSFetchedResultsControllerDelegate

// Update the table when data first loads.
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

// Filter the children by name when the search text changes.
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // If the text changes while the search bar is not the first responder, the clear button has been clicked.
    if (![searchBar isFirstResponder]) {
        self.clearButtonClicked = YES;
    }

    NSPredicate *textPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchText];
    self.searchPredicate = ([searchText isEqualToString:@""]) ? [NSPredicate predicateWithValue:YES] : textPredicate;
    [self updateTable];
}

// Hide the keyboard when the "Done" button is pressed.
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

// Don't open the keyboard if the clear button has been clicked.
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    BOOL shouldShowKeyboard = !self.clearButtonClicked;
    self.clearButtonClicked = NO;
    return shouldShowKeyboard;
}

#pragma mark - UITableViewDataSource

// Set the number of sections in the table.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

// Set the number of rows in each section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedResultsController.sections[section] numberOfObjects];
}

#pragma mark - UITableViewDelegate

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
    NSManagedObject *child = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:kCellLabelTag];
    HGWebImageView *imageView = (HGWebImageView *)[cell.contentView viewWithTag:kCellImageTag];
    label.text = [child valueForKey:@"name"];
    imageView.url = [NSURL URLWithString:[child valueForKey:@"thumbnail"]];

    return cell;
}

// On selection, show a detail view of the child.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar resignFirstResponder];
    HGChildViewController *childViewController = [[HGChildViewController alloc] init];
    childViewController.child = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:childViewController animated:YES];
}

@end
