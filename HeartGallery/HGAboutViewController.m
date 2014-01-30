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

    self.navigationItem.title = @"About Us";
    
    NSString *text = @"<style>p {font-size: 18px}</style><p>For many reasons beyond their control - including neglect, abuse and abandonment - hundreds of children have found themselves in the Alabama foster care system. Heart Gallery Alabama's mission is to promote adoption of these children by recruiting professional photographers & videographers to take meaningful portraits and interviews that capture the individuality and personality of each child.</p><p>These portraits are featured in \"galleries\" hosted in various venues across the state. The portraits and interviews with the children allow prospective adoptive families to learn more about the Alabama children who are waiting for their forever families because Heart Gallery Alabama believes that if given the opportunity to spread their wings, these children will soar!</p>";

    UIWebView *textView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [textView loadHTMLString:text baseURL:nil];
    [self.view addSubview:textView];

}

@end
