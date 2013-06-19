//
//  HGChildDetailViewController.m
//  ToyJsonTable
//
//  Created by Andrew Davis on 6/19/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGChildDetailViewController.h"

@interface HGChildDetailViewController ()

@end

@implementation HGChildDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.label = [[UILabel alloc] initWithFrame:self.view.bounds];
    self.label.text = @"Hello!";
    [self.view addSubview:self.label];
    
}

@end
