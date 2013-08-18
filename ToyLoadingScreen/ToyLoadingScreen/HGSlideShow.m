//
//  HGSlideShow.m
//  SlideShowDemo
//
//  Created by Andrew Davis on 4/2/13.
//  Copyright (c) 2013 Kiwi Apps. All rights reserved.
//

#import "HGSlideShow.h"

@interface HGSlideShow()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (nonatomic) BOOL pageControlBeingPressed;
@end

@implementation HGSlideShow

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Number of child views in the slideshow
    NSUInteger childViewCount = [self.dataSource numberOfViews];
    
    // Tracks whether the page control is being used to change the page. This is used to prevent flashing of the page control
    // which is caused by the scrollViewDidScroll method being called
    self.pageControlBeingPressed = NO;
    
    // Add a scroll view
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * childViewCount, self.bounds.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];

    // Add the child views
    for (NSUInteger idx = 0; idx < childViewCount; idx++) {
        CGRect childViewFrame = CGRectMake(self.scrollView.bounds.size.width * idx, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        UIView *childView = [self.dataSource viewForIndex:idx];
        childView.frame = childViewFrame;
        [self.scrollView addSubview:childView];
    }
    
    // Set up the page control
    self.pageControl.numberOfPages = childViewCount;
    self.pageControl.hidesForSinglePage = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // If the page control is being used to change the page, don't send it a message to change pages, since it handles that iself.
    if (self.pageControlBeingPressed) {
        return;
    }
    
    // When the user changes pages by scrolling, send the page control a message to update the page it's on.
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

// Called when a dot on the page control is pressed.
- (void)changePage {
    // The page control is being used to change pages. This is saved so that the scrollViewDidScroll message knows not to
    // manually change the page control's page.
    self.pageControlBeingPressed = YES;

    // Scroll the scroll frame to the requested page.
    CGPoint origin = CGPointMake(self.scrollView.frame.size.width * self.pageControl.currentPage, 0);
    CGRect frameRect = CGRectMake(origin.x, origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView scrollRectToVisible:frameRect animated:YES];
}

// When the user starts scrolling, we know they aren't using the page control to change pages.
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.pageControlBeingPressed = NO;
}

// When the scroll frame stops scrolling, we know the user isn't changing pages with the page control.
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControlBeingPressed = NO;
}

@end
