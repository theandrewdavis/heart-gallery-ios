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

@interface HGHomeViewController()
@property (strong, nonatomic) NSArray *socialButtons;
@end

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
    CGFloat kButtonHeight = 45;
    UIButton *childrenButton = [UIButton buttonWithColor:[UIColor redColor]];
    childrenButton.frame = CGRectMake(kButtonMargin, self.view.frame.size.height - kButtonHeight - kButtonMargin, self.view.frame.size.width - 2 * kButtonMargin, kButtonHeight);
    [childrenButton setTitle:@"Children" forState:UIControlStateNormal];
    [childrenButton addTarget:self action:@selector(showChildren) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:childrenButton];

    // Add social buttons.
    self.socialButtons = @[
        @{@"image": @"Facebook.png", @"link": @"https://www.facebook.com/heartgalleryal"},
        @{@"image": @"Twitter.png", @"link": @"https://twitter.com/heartgal"},
        @{@"image": @"Instagram.png", @"link": @"https://instagram.com/heartgalleryal"},
        @{@"image": @"Linkedin.png", @"link": @"http://www.linkedin.com/company/heart-gallery-alabama"},
        @{@"image": @"Blogger.png", @"link": @"http://heartgalleryal.blogspot.com/"},
    ];
    CGFloat buttonPadding = (childrenButton.frame.size.width - self.socialButtons.count * kButtonHeight) / (self.socialButtons.count - 1);
    for (int buttonIndex = 0; buttonIndex < self.socialButtons.count; buttonIndex++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = buttonIndex;
        NSString *imageName = self.socialButtons[buttonIndex][@"image"];
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickSocialButton:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonFrameX = childrenButton.frame.origin.x + (kButtonHeight + buttonPadding) * buttonIndex;
        button.frame = CGRectMake(buttonFrameX, childrenButton.frame.origin.y - kButtonHeight - kButtonMargin / 2, kButtonHeight, kButtonHeight);
        [self.view addSubview:button];
    }
}

- (void)showChildren {
    UIViewController *viewController = [[HGChildTableViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.slideMenuController closeMenuBehindContentViewController:navigationController animated:YES bounce:NO completion:nil];
}

- (void)clickSocialButton:(id)sender {
    NSString *linkText = self.socialButtons[[(UIButton *)sender tag]][@"link"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkText]];
}

@end
