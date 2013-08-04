//
//  HGHomeViewController.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/3/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGHomeViewController.h"
#import "HGChildTableViewController.h"
#import "HGChild.h"

#define kHomeScreenMargin 20.0
#define kHomeScreenButtonHeight 80.0

@implementation HGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create a frame for the children button.
    CGFloat buttonY = self.view.bounds.size.height - kHomeScreenMargin - kHomeScreenButtonHeight;
    CGFloat buttonWidth = self.view.bounds.size.width - 2 * kHomeScreenMargin;
    CGRect childrenButtonFrame = CGRectMake(kHomeScreenMargin, buttonY, buttonWidth, kHomeScreenButtonHeight);
    
    // Add the children button.
    UIButton *childrenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    childrenButton.frame = childrenButtonFrame;
    childrenButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [childrenButton setTitle:@"Children" forState:UIControlStateNormal];
    [childrenButton addTarget:self action:@selector(showChildren) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:childrenButton];
}

// Hide the navigation bar for this view only.
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

// Restore the navigation bar so that it will be shown on other views in the navigation controller.
- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

// Open a table view of all children. Activated when the "Children" button is pressed.
- (void)showChildren {
    HGChildTableViewController *childTable = [[HGChildTableViewController alloc] init];
    childTable.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:childTable animated:YES];
}

@end
