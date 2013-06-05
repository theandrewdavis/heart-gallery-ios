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
    CGRect movieViewFrame = [HGMovieView frameWithAspectRatio:9.0 / 5.0 withinBounds:self.view.bounds withMargin:10.0 yOffset:200.0];
    HGMovieView *movieView = [[HGMovieView alloc] initWithFrame:movieViewFrame controller:self movieURL:movieURL];
    [self.view addSubview:movieView];
}

@end
