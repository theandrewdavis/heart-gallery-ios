//
//  HGSlideShow.h
//  SlideShowDemo
//
//  Created by Andrew Davis on 4/2/13.
//  Copyright (c) 2013 Kiwi Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HGSlideShowDataSource
- (NSUInteger)numberOfViews;
- (UIView *)viewForIndex:(NSUInteger)index;
@end

@interface HGSlideShow : UIView <UIScrollViewDelegate>
@property (weak, nonatomic) id<HGSlideShowDataSource> dataSource;
@property (strong, nonatomic) UIPageControl *pageControl;

- (void)changePage;
@end
