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
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // Add the background image.
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - navBarHeight)];
    background.image = [UIImage imageNamed:@"background.jpeg"];
    background.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:background];
    
    // Add the title logo.
    UIImage *logoImage = [UIImage imageNamed:@"logo.jpeg"];
    CGFloat logoHeight = logoImage.size.height / logoImage.size.width * self.view.bounds.size.width;
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, logoHeight)];
    logoView.image = logoImage;
    [self.view addSubview:logoView];
}

@end
