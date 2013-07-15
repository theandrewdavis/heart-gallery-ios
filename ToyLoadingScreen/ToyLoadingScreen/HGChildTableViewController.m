//
//  HGChildTableViewController.m
//  ToyJsonTable
//
//  Created by Andrew Davis on 6/15/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGChildTableViewController.h"
#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"
#import "Child.h"

#define kChildFetchRequestBatchSize 40
#define kChildTableViewRowHeight 90

@implementation HGChildTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the title of the navigation controller.
    self.navigationItem.title = @"Children";
    
    // Display the children stored on the device then check the web for updates.
    [self fetchLocalData];
    [self fetchRemoteData];
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
    
    Child *child = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = child.name;

    return cell;
}

// When the fetched results controller's data changes, update the table with the new data.
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

// Fetch a list of all children stored on the device with Core Data.
- (void)fetchLocalData {
    // Prepare a fetch request.
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[Child entityName]];
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
- (void)fetchRemoteData {
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8081/api.php"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // If the request is successful, update the children in the local store and hide the loading indicator.
        [Child replaceAllFromDictionary:JSON inContext:self.managedObjectContext];
        [SVProgressHUD showSuccessWithStatus:@"Complete"];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // If the request fails, log the error and inform the user that the update failed.
        NSLog(@"Request failed: %@, %@", error.localizedDescription, error.userInfo);
        [SVProgressHUD showErrorWithStatus:@"Could not connect"];
    }];
    [operation start];
    
}


// On selection, show a detail view of the child.
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *child = self.children[indexPath.row];
//    HGChildDetailViewController *childDetailView = [[HGChildDetailViewController alloc] initWithChild:child];
//    [self.navigationController pushViewController:childDetailView animated:YES];
//}

@end
