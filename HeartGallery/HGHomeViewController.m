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

static NSInteger kMarginHorizontal = 8;
static NSInteger kMarginVertical = 8;
static NSInteger kButtonHeight = 50;
static NSInteger kButtonPadding = 4;

@implementation HGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add the background image.
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.bounds];
    background.image = [UIImage imageNamed:@"background.jpeg"];
    [self.view addSubview:background];
    
    // Add a "Children" button.
    UIButton *childrenButton = [UIButton buttonWithColor:[UIColor redColor]];
    CGFloat buttonWidth = self.view.bounds.size.width - 2 * kMarginHorizontal;
    childrenButton.frame = CGRectMake(kMarginHorizontal, self.view.bounds.size.height - kMarginVertical - kButtonHeight, buttonWidth, kButtonHeight);
    [childrenButton setTitle:@"Children" forState:UIControlStateNormal];
    [childrenButton addTarget:self action:@selector(showChildren) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:childrenButton];

    // Add a "Donate" button.
    UIButton *donateButton = [UIButton buttonWithColor:[UIColor colorWithRed:90.0f/255.0f green:124.0f/255.0f blue:194.0f/255.0f alpha:1.0f]];
    donateButton.frame = CGRectMake(kMarginHorizontal, childrenButton.frame.origin.y - kButtonPadding - kButtonHeight, buttonWidth, kButtonHeight);
    [donateButton setTitle:@"Donate" forState:UIControlStateNormal];
    [donateButton addTarget:self action:@selector(donate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:donateButton];
    
    // Add the title text.
    NSString *titleText = @"Heart Gallery of Alabama";
    CGFloat minFontSize = 1;
    CGFloat maxFontSize = 100;
    CGFloat titleFontSize;
    UIFont *titleFont = [UIFont fontWithName:@"GillSans-Light" size:maxFontSize];
    CGFloat titleWidth = self.view.bounds.size.width * 0.8;
    [titleText sizeWithFont:titleFont minFontSize:minFontSize actualFontSize:&titleFontSize forWidth:titleWidth lineBreakMode:UILineBreakModeWordWrap];
    titleFont = [titleFont fontWithSize:titleFontSize];
    CGFloat titleHeight = [titleText sizeWithFont:titleFont].height;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleWidth, titleHeight)];
    title.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.1);
    title.font = [titleFont fontWithSize:titleFontSize];
    title.text = titleText;
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    [self.view addSubview:title];
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
    childTable.remoteDataController = self.dataController;
    [self.navigationController pushViewController:childTable animated:YES];
}

// Open the donate page of the Heart Gallery website in Safari.
- (void)donate {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.heartgalleryalabama.com/support.php"]];
}

@end
