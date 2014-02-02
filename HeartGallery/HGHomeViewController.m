//
//  HGHomeViewController.m
//  HeartGallery
//
//  Created by Andrew Davis on 7/3/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGHomeViewController.h"
#import "HGChildTableViewController.h"
#import "UIButton+ColorButton.h"
#import "NVSlideMenuController.h"

@implementation HGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the navigation bar text.
    self.navigationItem.title = @"Heart Gallery";

    // Don't extend the view underneath the navigation bar.
    CGFloat newFrameHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        newFrameHeight -= [UIApplication sharedApplication].statusBarFrame.size.height;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, newFrameHeight);

    // Add the background image.
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpeg"]];
    background.contentMode = UIViewContentModeScaleAspectFill;
    background.frame = self.view.bounds;
    [self.view addSubview:background];

    // Add the title logo.
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    CGFloat logoHeight = logoImage.size.height / logoImage.size.width * self.view.bounds.size.width;
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, logoHeight)];
    logoView.image = logoImage;
    [self.view addSubview:logoView];

    // Add a "Children" button.
    CGFloat kButtonMargin = 12;
    CGFloat kButtonHeight = 50;
    UIButton *childrenButton = [UIButton buttonWithColor:[UIColor redColor]];
    childrenButton.frame = CGRectMake(kButtonMargin, self.view.frame.size.height - kButtonHeight - kButtonMargin, self.view.frame.size.width - 2 * kButtonMargin, kButtonHeight);
    [childrenButton setTitle:@"Children" forState:UIControlStateNormal];
    [childrenButton addTarget:self action:@selector(showChildren) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:childrenButton];
}

- (void)showChildren {
    UIViewController *viewController = [[HGChildTableViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.slideMenuController closeMenuBehindContentViewController:navigationController animated:YES bounce:NO completion:nil];
}

@end
