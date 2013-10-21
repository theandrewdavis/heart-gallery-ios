//
//  HGMenuViewController.m
//  HeartGallery
//
//  Created by Andrew Davis on 10/14/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGMenuViewController.h"
#import "NVSlideMenuController.h"
#import "HGAboutViewController.h"
#import "HGHomeViewController.h"
#import "HGChildTableViewController.h"

static NSString *kMenuCellIdentifier = @"Menu Cell";

@interface HGMenuViewController ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuControllers;
@end

@implementation HGMenuViewController

// Prepare the table view and the names and view controllers that will be used for each menu option.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kMenuCellIdentifier];
    self.menuTitles = @[@"Home", @"About Us", @"Contact Us", @"Children", @"How Can You Help?", @"News & Events"];
    self.menuControllers = @[[HGHomeViewController class], [HGAboutViewController class], [HGAboutViewController class], [HGChildTableViewController class], [HGAboutViewController class], [HGAboutViewController class]];
}

// Set the number of sections in the table.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Set the number of rows in the table.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuTitles.count;
}

// Create the table cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMenuCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.menuTitles[indexPath.row];
    return cell;
}

// When a row is selected, launch the appropriate view controller.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showViewControllerClass:self.menuControllers[indexPath.row]];
}

// Show the given view controller, or close menu pane if it is already showing.
- (void)showViewControllerClass:(Class)viewControllerClass {
    if ([self isViewControllerActive:viewControllerClass]) {
        [self.slideMenuController toggleMenuAnimated:self];
    } else {
        UIViewController *viewController = [[viewControllerClass alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self.slideMenuController closeMenuBehindContentViewController:navigationController animated:YES bounce:NO completion:nil];
    }
}

// Check whether the given viewController is currently showing.
- (BOOL)isViewControllerActive:(Class)viewControllerClass {
    if ([self.slideMenuController.contentViewController isKindOfClass:[UINavigationController class]]) {
        return [[(UINavigationController *)self.slideMenuController.contentViewController visibleViewController] isKindOfClass:viewControllerClass];
    }
    return [self.slideMenuController.contentViewController isKindOfClass:viewControllerClass];
}

@end
