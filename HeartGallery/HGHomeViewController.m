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

#define kHomeScreenMargin 20.0
#define kHomeScreenButtonHeight 60.0

static NSInteger kButtonMargin = 6;
static NSInteger kButtonPadding = 4;
static NSInteger kButtonHeight = 50;

@implementation HGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add the background image.
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.bounds];
    background.image = [UIImage imageNamed:@"background.jpeg"];
    [self.view addSubview:background];
    
    // Add the title logo.
    UIImage *logoImage = [UIImage imageNamed:@"logo.jpeg"];
    CGFloat logoHeight = logoImage.size.height / logoImage.size.width * self.view.bounds.size.width;
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, logoHeight)];
    logoView.image = logoImage;
    [self.view addSubview:logoView];
    
    // Add a "Donate" button.
    CGFloat buttonWidth = (self.view.bounds.size.width - 2 * kButtonMargin - kButtonPadding) / 2;
    UIButton *donateButton = [UIButton buttonWithColor:[UIColor colorWithRed:90.0f/255.0f green:124.0f/255.0f blue:194.0f/255.0f alpha:1.0f]];
    donateButton.frame = CGRectMake(kButtonMargin, self.view.bounds.size.height - kButtonMargin - kButtonHeight, buttonWidth, kButtonHeight);
    [donateButton setTitle:@"Donate" forState:UIControlStateNormal];
    [donateButton addTarget:self action:@selector(donate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:donateButton];
    
    // Add a "Children" button.
    UIButton *childrenButton = [UIButton buttonWithColor:[UIColor redColor]];
    childrenButton.frame = CGRectMake(kButtonMargin + buttonWidth + kButtonPadding, self.view.bounds.size.height - kButtonMargin - kButtonHeight, buttonWidth, kButtonHeight);
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
    childTable.remoteDataController = self.remoteDataController;
    [self.navigationController pushViewController:childTable animated:YES];
}

// Open the donate page of the Heart Gallery website in Safari.
- (void)donate {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.heartgalleryalabama.com/support.php"]];
}

@end
