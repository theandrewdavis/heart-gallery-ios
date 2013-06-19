//
//  HGPortraitNavigationController.m
//  ToyJsonTable
//
//  Created by Andrew Davis on 6/19/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGPortraitNavigationController.h"

@interface HGPortraitNavigationController ()

@end

@implementation HGPortraitNavigationController

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
