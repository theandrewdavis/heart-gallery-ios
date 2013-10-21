//
//  HGAboutViewController.m
//  HeartGallery
//
//  Created by Andrew Davis on 10/16/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGAboutViewController.h"

@implementation HGAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"About";
    
    NSString *loremIpsum = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum";
    
    UIWebView *aboutTextView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [aboutTextView loadHTMLString:loremIpsum baseURL:nil];
    [self.view addSubview:aboutTextView];

}

@end
