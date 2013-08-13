//
//  HGHomeViewController.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/3/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGHomeViewController.h"
#import "HGChildTableViewController.h"
#import "UIButton+ColorButton.h"

#define kHomeScreenMargin 20.0
#define kHomeScreenButtonHeight 60.0

static int kBorderSize = 3;
static int kButtonWellEdgeMargin = 15;
static int kButtonWellInnerMargin = 5;
static int kButtonWellButtonHeight = 60;

@implementation HGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:160.0f/255.0f green:0.0f blue:0.0f alpha:1.0f]; // [UIColor redColor]
    CGFloat bodyWidth = self.view.bounds.size.width - 2 * kBorderSize;
    
    // Add the button well.
    CGFloat buttonWellHeight = kButtonWellEdgeMargin * 2 + kButtonWellInnerMargin + kButtonWellButtonHeight * 2;
    CGFloat buttonWellY = self.view.bounds.size.height - buttonWellHeight - kBorderSize;
    UIImageView *buttonWell = [[UIImageView alloc] initWithFrame:CGRectMake(kBorderSize, buttonWellY, bodyWidth, buttonWellHeight)];
    buttonWell.image = [UIImage imageNamed:@"gray-background.png"];
    [self.view addSubview:buttonWell];
    
    CGRect donateButtonFrame = CGRectMake(kButtonWellEdgeMargin, kButtonWellEdgeMargin, buttonWell.bounds.size.width - 2 * kButtonWellEdgeMargin, kButtonWellButtonHeight);
    CGRect childrenButtonFrame = CGRectMake(kButtonWellEdgeMargin, kButtonWellEdgeMargin + kButtonWellButtonHeight + kButtonWellInnerMargin, buttonWell.bounds.size.width - 2 * kButtonWellEdgeMargin, kButtonWellButtonHeight);
    
    // Add a "Children" button.
    UIButton *childrenButton = [UIButton buttonWithColor:[UIColor redColor]];
    childrenButton.frame = childrenButtonFrame;
    [childrenButton setTitle:@"Children" forState:UIControlStateNormal];
    [childrenButton addTarget:self action:@selector(showChildren) forControlEvents:UIControlEventTouchUpInside];
    [buttonWell addSubview:childrenButton];
    
    // Add a "Donate" button.
    UIButton *donateButton = [UIButton buttonWithColor:[UIColor colorWithRed:90.0f/255.0f green:124.0f/255.0f blue:194.0f/255.0f alpha:1.0f]];
    donateButton.frame = donateButtonFrame;
    [donateButton setTitle:@"Donate" forState:UIControlStateNormal];
    [donateButton addTarget:self action:@selector(donate) forControlEvents:UIControlEventTouchUpInside];
    [buttonWell addSubview:donateButton];
    
    // Add the title image.
    NSString *titleName = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"ipad-title.png" : @"iphone-title.png";
    UIImage *titleImage = [UIImage imageNamed:titleName];
    CGFloat titleImageViewHeight = bodyWidth * titleImage.size.height / titleImage.size.width;
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kBorderSize, kBorderSize, bodyWidth, titleImageViewHeight)];
    titleImageView.image = titleImage;
    [self.view addSubview:titleImageView];

    // Fill in remaining space with images.
    NSArray *imageNames = @[@"iphone-image1.jpg", @"iphone-image2.jpg", @"iphone-image3.jpg"];
    CGSize sampleImageSize = [UIImage imageNamed:imageNames[0]].size;
    CGFloat sampleImageIdealHeight = bodyWidth * sampleImageSize.height / sampleImageSize.width;
    CGFloat totalAvailableImageHeight = buttonWell.frame.origin.y - titleImageView.frame.origin.y - titleImageView.bounds.size.height - 2 * kBorderSize;
    int fillImagesCount = MIN(imageNames.count, roundf(totalAvailableImageHeight / sampleImageIdealHeight));
    CGFloat actualImageHeight = (totalAvailableImageHeight - (fillImagesCount - 1) * kBorderSize) / fillImagesCount;
    
    CGFloat fillImagesY = titleImageView.frame.origin.y + titleImageView.bounds.size.height + kBorderSize;
    for (int index = 0; index < fillImagesCount; index++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kBorderSize, fillImagesY + (actualImageHeight + kBorderSize) * index, bodyWidth, actualImageHeight)];
        imageView.image = [UIImage imageNamed:imageNames[index]];
        [self.view addSubview:imageView];
    }
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
    childTable.dataController = self.dataController;
    [self.navigationController pushViewController:childTable animated:YES];
}

- (void)donate {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.heartgalleryalabama.com/support.php"]];
}

@end
