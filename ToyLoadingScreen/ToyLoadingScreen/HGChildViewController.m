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
#import "UIScrollView+Resize.h"

static int kPageControlHeight = 36;

@interface HGChildViewController()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) HGSlideShow *slideShow;
@property (strong, nonatomic) UIWebView *biographyView;
@end

@implementation HGChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set the title to the child's name
    self.navigationItem.title = self.child.name;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    
    // Add a slide show to display the child's media.
    CGRect slideShowFrame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.width * 2 / 3);
    self.slideShow = [[HGSlideShow alloc] initWithFrame:slideShowFrame];
    self.slideShow.backgroundColor = [UIColor blackColor];
    self.slideShow.dataSource = self;
    [self.scrollView addSubview:self.slideShow];

    // Add a page control to control the slide show.
    CGRect pageControlFrame = CGRectMake(0.0, slideShowFrame.origin.y + slideShowFrame.size.height, self.view.bounds.size.width, kPageControlHeight);
    self.slideShow.pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
    self.slideShow.pageControl.backgroundColor = [UIColor blackColor];
    [self.scrollView addSubview:self.slideShow.pageControl];
    
    // Add the biography text in a web view so that it will handle HTML line breaks.
    CGFloat biographyViewOriginY = pageControlFrame.origin.y + pageControlFrame.size.height;
    CGRect biographyViewFrame = CGRectMake(0.0, biographyViewOriginY, self.view.bounds.size.width, self.view.bounds.size.height - biographyViewOriginY);
    UIWebView *biographyView = [[UIWebView alloc] initWithFrame:biographyViewFrame];
    biographyView.delegate = self;
    biographyView.scrollView.userInteractionEnabled = NO;
    [self.scrollView addSubview:biographyView];

    // The content height of the UIWebView is off by about 3 lines. Add a margin to the bottom of the scroll view to work around this issue.
    NSString *htmlDoc = [NSString stringWithFormat:@"<html><body style='margin-bottom: 3em;'>%@</body></html>", self.child.biography];
    [biographyView loadHTMLString:htmlDoc baseURL:nil];
}

// Find the number of views in the slide show.
- (NSUInteger)numberOfViews {
    return self.child.media.count;
}

// Create a view for each media item in the slide show.
- (UIView *)viewForIndex:(NSUInteger)index {
    HGMediaItem *mediaItem = self.child.media.array[index];
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

// Called when the child biography view has loaded. Resizes the biography view and scroll view to fit their content.
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    webView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, webView.scrollView.contentSize.height);
    [self.scrollView resizeToFitContent];
}

@end
