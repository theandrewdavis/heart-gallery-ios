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

- (id)initWithChild:(NSDictionary *)child {
    self = [super init];
    if (self) {
        self.child = child;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Set the title to the child's name
    self.navigationItem.title = self.child[@"name"];

    // Add a full size image of the child
    NSString *imageName = [[self.child[@"image-full"] componentsSeparatedByString:@"/"] lastObject];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self.view addSubview:imageView];
}

@end
