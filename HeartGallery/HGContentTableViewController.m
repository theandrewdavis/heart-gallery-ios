//
//  HGContentTableViewController.m
//  HeartGallery
//
//  Created by Andrew Davis on 10/21/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGContentTableViewController.h"
#import "NVSlideMenuController.h"

@implementation HGContentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up the navigation menu title bar.
    UIImage *buttonImage = [UIImage imageNamed:@"menu-icon.png"];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:buttonImage style:UIBarButtonItemStyleBordered target:self action:@selector(toggleMenu:)];
    self.navigationItem.leftBarButtonItem = buttonItem;
}

// When the menu button is pressed, slide out the menu pane.
- (void)toggleMenu:(id)sender {
    [self.slideMenuController toggleMenuAnimated:self];
}

@end
