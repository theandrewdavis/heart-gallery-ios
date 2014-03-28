//
//  HGChildMasterViewController.m
//  HeartGallery
//
//  Created by Andrew Davis on 6/15/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGChildMasterViewController.h"
#import "HGChildDetailViewController.h"
#import "HGWebImageView.h"
#import "HGFilterViewController.h"
#import "HGManagedObjectContext.h"
#import "AFNetworking.h"

static NSInteger kTableRowHeight = 90;
static NSInteger kCellImageTag = 1;
static NSInteger kCellLabelTag = 2;
static NSInteger kCellLabelLeftMargin = 10;
static NSInteger kCellLabelRightMargin = 20;
static NSInteger kSearchBarHeight = 44;
static NSString *kChildApiUrl = @"http://heartgalleryalabama.com/api.php";

@interface HGChildMasterViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) HGFilterViewController *filterViewController;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSPredicate *filterPredicate;
@property (nonatomic, strong) NSPredicate *searchPredicate;
@property (nonatomic) BOOL clearButtonClicked;
@end

@implementation HGChildMasterViewController

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
    [self tableFiltersChanged];

    // Set up pull to refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(updateFromWeb) forControlEvents:UIControlEventValueChanged];
    [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:NO];
    [self.refreshControl beginRefreshing];
    [self updateFromWeb];
}

// Update list of children from web API.
- (void)updateFromWeb {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kChildApiUrl]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [HGManagedObjectContext updateChildren:JSON[@"children"]];
        [self.refreshControl endRefreshing];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self.refreshControl endRefreshing];
    }];
    [operation start];
}

// Called when the search or filter predicate change to update the fetched results controller.
- (void)tableFiltersChanged {
    self.fetchedResultsController = [HGManagedObjectContext createChildResultsControllerWithPredicates:@[self.searchPredicate, self.filterPredicate]];
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}

// Open a filter view to create a filter to pass to the fetched results controller.
- (void)filter {
    [self presentViewController:self.filterViewController animated:YES completion:nil];
}

#pragma mark - HGFilterViewControllerDelegate

// Reload table data when a new filter is selected.
- (void)didChangePredicate:(NSPredicate *)predicate {
    self.filterPredicate = predicate;
    [self tableFiltersChanged];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
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
    [self tableFiltersChanged];
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

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *child = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:kCellLabelTag];
    HGWebImageView *imageView = (HGWebImageView *)[cell.contentView viewWithTag:kCellImageTag];
    label.text = [child valueForKey:@"name"];
    imageView.url = [NSURL URLWithString:[child valueForKey:@"thumbnail"]];
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

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

// On selection, show a detail view of the child.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar resignFirstResponder];
    HGChildDetailViewController *childViewController = [[HGChildDetailViewController alloc] init];
    childViewController.child = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:childViewController animated:YES];
}

@end
