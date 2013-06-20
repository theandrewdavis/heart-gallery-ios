//
//  HGViewController.m
//  ToyImageLoader
//
//  Created by Andrew Davis on 6/20/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGViewController.h"

@interface HGViewController ()

@end

@implementation HGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.text = @"Hello";
    [self.view addSubview:label];
}

@end
