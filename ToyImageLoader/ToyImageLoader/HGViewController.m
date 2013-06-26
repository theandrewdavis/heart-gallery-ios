//
//  HGViewController.m
//  ToyImageLoader
//
//  Created by Andrew Davis on 6/20/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGViewController.h"
#import "HGWebImageView.h"

@interface HGViewController ()

@end

@implementation HGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Add an image that loads from the web asynchronously.
    NSString *urlString = @"http://www.heartgalleryalabama.com/images/children/primary/1367953229_acacia.jpg";
    CGRect imageSize = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width);
    HGWebImageView *image = [[HGWebImageView alloc] initWithFrame:imageSize urlString:urlString];
    [self.view addSubview:image];
}

@end
