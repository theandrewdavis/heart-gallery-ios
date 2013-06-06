//
//  HGViewController.m
//  ToyMoviePlayer
//
//  Created by Andrew Davis on 6/2/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGViewController.h"
#import "HGMovieView.h"

@interface HGViewController ()

@end

@implementation HGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add the movie view
    NSURL *movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"acacia-video" ofType:@"mp4"]];
    CGRect movieViewFrame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.width / 9.0 * 5.0);
    HGMovieView *movieView = [[HGMovieView alloc] initWithFrame:movieViewFrame controller:self movieURL:movieURL];
    [self.view addSubview:movieView];
}

@end
