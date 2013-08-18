//
//  HGChildViewController.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/30/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGChildViewController.h"
#import "HGChild.h"
#import "HGMediaItem.h"
#import "HGWebImageView.h"
#import "HGMovieView.h"

static int kPageControlHeight = 36;

@interface HGChildViewController()
@property (strong, nonatomic) HGSlideShow *slideShow;
@end

@implementation HGChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set the title to the child's name
    self.navigationItem.title = self.child.name;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    CGRect slideShowFrame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.width * 2 / 3);
    self.slideShow = [[HGSlideShow alloc] initWithFrame:slideShowFrame];
    self.slideShow.backgroundColor = [UIColor blackColor];
    self.slideShow.dataSource = self;
    [scrollView addSubview:self.slideShow];

    CGRect pageControlFrame = CGRectMake(0.0, self.slideShow.frame.origin.y + self.slideShow.bounds.size.height, self.view.bounds.size.width, kPageControlHeight);
    self.slideShow.pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
    self.slideShow.pageControl.backgroundColor = [UIColor blackColor];
    [scrollView addSubview:self.slideShow.pageControl];
}

- (NSUInteger)numberOfViews {
    return self.child.media.count;
}

- (UIView *)viewForIndex:(NSUInteger)index {
    HGMediaItem *mediaItem = self.child.media.allObjects[index];
    NSLog(@"Creating view for %@", mediaItem.url);
    if ([mediaItem.type isEqualToString:@"image"]) {
        HGWebImageView *view = [[HGWebImageView alloc] init];
        view.url = [NSURL URLWithString:mediaItem.url];
        view.contentMode = UIViewContentModeScaleAspectFit;
        return view;
    } else if ([mediaItem.type isEqualToString:@"video"] || [mediaItem.type isEqualToString:@"audio"]) {
        HGMovieView *movieView = [[HGMovieView alloc] init];
        movieView.movieURL = [NSURL URLWithString:mediaItem.url];
        movieView.rootViewController = self;
        return movieView;
    } else {
        HGWebImageView *view = [[HGWebImageView alloc] init];
        view.url = [NSURL URLWithString:self.child.thumbnail];
        view.contentMode = UIViewContentModeScaleAspectFit;
        return view;
    }
}

@end
