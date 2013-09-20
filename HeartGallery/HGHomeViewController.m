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
#import <Twitter/Twitter.h>

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

    // Add a Twitter button.
    UIButton *twitterButton = [UIButton buttonWithColor:[UIColor blueColor]];
    twitterButton.frame = CGRectMake(kButtonMargin, self.view.bounds.size.height - kButtonMargin - 2 * kButtonHeight - kButtonPadding, buttonWidth, kButtonHeight);
    [twitterButton setTitle:@"Tweet" forState:UIControlStateNormal];
    [twitterButton addTarget:self action:@selector(tweet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twitterButton];
    
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
    childTable.remoteDataController = self.remoteDataController;
    [self.navigationController pushViewController:childTable animated:YES];
}

// Open the donate page of the Heart Gallery website in Safari.
- (void)donate {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.heartgalleryalabama.com/support.php"]];
}

// Open the twitter dialog box.
- (void)tweet {
    if ([TWTweetComposeViewController canSendTweet]) {
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText: @"#heartgallery"];
	    [self presentModalViewController:tweetSheet animated:YES];
    } else {
        
        NSLog(@"Can't send tweet!");
    }
}

@end
