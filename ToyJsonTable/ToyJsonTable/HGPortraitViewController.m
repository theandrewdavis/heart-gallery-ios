//
//  HGPortraitViewController.m
//  ToyMoviePlayer
//
//  Created by Andrew Davis on 6/6/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGPortraitViewController.h"

@interface HGPortraitViewController ()
@end

@implementation HGPortraitViewController

// Require portrait view for iOS 6.
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

// Require portrait view for iOS 4 and 5.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
