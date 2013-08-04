//
//  HGChildTableViewController.m
//  ToyJsonTable
//
//  Created by Andrew Davis on 6/15/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGChildTableViewController.h"
#import "HGChildViewController.h"
#import "HGManagedObjectContext.h"
#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"
#import "CKRefreshControl.h"
#import "HGChild.h"
#import "Reachability.h"

#define kChildApiUrl @"http://ec2-54-221-46-93.compute-1.amazonaws.com/api.php"
#define kChildApiHostName @"ec2-54-221-46-93.compute-1.amazonaws.com"
#define kChildFetchRequestBatchSize 40

@implementation HGChildTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the title of the navigation controller.
    self.navigationItem.title = @"Children";
    
    // Display the children stored on the device.
    [self fetchLocalData];
    
    // Set up pull to refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchRemoteData:) forControlEvents:UIControlEventValueChanged];
    
    // Get updates from the web and start the pull to refresh spinner.
    [self.refreshControl beginRefreshing];
    [self fetchRemoteData:self.refreshControl];
}

// Set the number of sections in the table.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

// Set the number of rows in each section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedResultsController.sections[section] numberOfObjects];
}

// Create a cell for the given section and row.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ChildTableCell";

    // Get a cached cell layout if it is availble. Create one if it is not yet available.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    HGChild *child = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = child.name;

    return cell;
}

// On selection, show a detail view of the child.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HGChildViewController *childViewController = [[HGChildViewController alloc] init];
    childViewController.child = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:childViewController animated:YES];
}

// When the fetched results controller's data changes, update the table with the new data.
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

// Fetch a list of all children stored on the device with Core Data.
- (void)fetchLocalData {
    // Prepare a fetch request.
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([HGChild class])];
    NSSortDescriptor *sortNameDescending = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    request.sortDescriptors = @[sortNameDescending];
    request.fetchBatchSize = kChildFetchRequestBatchSize;
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
    // Perform the fetch request.
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Fetch request failed: %@, %@", error.localizedDescription, error.userInfo);
    }
}

// Fetch a list of all children from the web API. While the request is loading, show an activity indicator
// and prevent all user interaction.
- (void)fetchRemoteData:(UIRefreshControl *)refreshControl {
    // Don't try to connect if the network is not reachable.
    if (![self networkReachable]) {
        
        NSLog(@"NOT REACHABLE");
        
        [self hidePullToRefresh];
        [self showNetworkFailure];
        return;
    }

    // Download a list of all children. If successful, update the local store. If unsuccessful, show an error.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kChildApiUrl]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSString *version = response.allHeaderFields[@"ETag"];
        [self.managedObjectContext update:JSON version:version];
        [self hidePullToRefresh];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request failed: %@, %@", error.localizedDescription, error.userInfo);
        [self hidePullToRefresh];
        [self showNetworkFailure];
    }];
    [operation start];
}

// Hide the pull to refresh spinner.
- (void)hidePullToRefresh {
    [self.refreshControl performSelector:@selector(endRefreshing) withObject:nil];
}

// Pop up a message to inform the app could not connect to the remote server.
- (void)showNetworkFailure {
    [SVProgressHUD showErrorWithStatus:@"Could not connect"];
}

// Check if the network is currently reachable.
- (BOOL)networkReachable {
    Reachability *reachability = [Reachability reachabilityWithHostname:kChildApiHostName];
    return [reachability currentReachabilityStatus] != NotReachable;
}

@end
