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

static NSInteger kBorderSize = 3;
static NSInteger kButtonHeight = 60;
static NSInteger kWellMargin = 10;

@implementation HGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat bodyWidth = self.view.bounds.size.width - 2 * kBorderSize;
    
    // Add a button well.
    CGFloat wellHeight = 2 * kWellMargin + 2 * kButtonHeight + kBorderSize;
    UIImageView *well = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"well-background.png"]];
    well.frame = CGRectMake(kBorderSize, self.view.bounds.size.height - kBorderSize - wellHeight, bodyWidth, wellHeight);
    well.userInteractionEnabled = YES;
    [self.view addSubview:well];
    
    // Add a "Donate" button.
    UIButton *donateButton = [UIButton buttonWithColor:[UIColor colorWithRed:90.0f/255.0f green:124.0f/255.0f blue:194.0f/255.0f alpha:1.0f]];
    donateButton.frame = CGRectMake(kWellMargin, kWellMargin, bodyWidth - 2 * kWellMargin, kButtonHeight);
    [donateButton setTitle:@"Donate" forState:UIControlStateNormal];
    [donateButton addTarget:self action:@selector(donate) forControlEvents:UIControlEventTouchUpInside];
    [well addSubview:donateButton];
    
    // Add a "Children" button.
    UIButton *childrenButton = [UIButton buttonWithColor:[UIColor redColor]];
    childrenButton.frame = CGRectMake(kWellMargin, donateButton.frame.origin.y + kButtonHeight + kBorderSize, bodyWidth  - 2 * kWellMargin, kButtonHeight);
    [childrenButton setTitle:@"Children" forState:UIControlStateNormal];
    [childrenButton addTarget:self action:@selector(showChildren) forControlEvents:UIControlEventTouchUpInside];
    [well addSubview:childrenButton];
    
    // Add the title image.
    NSString *titleImageName = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"title-ipad.png" : @"title-iphone.png";
    UIImage *titleImage = [UIImage imageNamed:titleImageName];
    CGFloat titleImageViewHeight = bodyWidth * titleImage.size.height / titleImage.size.width;
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kBorderSize, kBorderSize, bodyWidth, titleImageViewHeight)];
    titleImageView.image = titleImage;
    [self.view addSubview:titleImageView];
    
    // Add the filler images.
    NSArray *fillImageNames = @[@"home-image-1.jpg", @"home-image-2.jpg"];
    CGFloat fillImagesYTop = titleImageView.frame.origin.y + titleImageView.bounds.size.height + kBorderSize;
    CGFloat fillImagesYBottom = well.frame.origin.y - kBorderSize;
    CGFloat fillImageHeight = (fillImagesYBottom - fillImagesYTop - (fillImageNames.count - 1) * kBorderSize) / fillImageNames.count;
    for (int index = 0; index < fillImageNames.count; index++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kBorderSize, fillImagesYTop + (fillImageHeight + kBorderSize) * index, bodyWidth, fillImageHeight)];
        imageView.image = [UIImage imageNamed:fillImageNames[index]];
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
    childTable.managedObjectContext = self.managedObjectContext;
    childTable.remoteDataController = self.dataController;
    [self.navigationController pushViewController:childTable animated:YES];
}

// Open the donate page of the Heart Gallery website in Safari.
- (void)donate {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.heartgalleryalabama.com/support.php"]];
}

@end
