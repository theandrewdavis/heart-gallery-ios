//
//  UIScrollView+Resize.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 8/18/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "UIScrollView+Resize.h"

@implementation UIScrollView (Resize)

// Resize to fit the size of child views.
- (void)resizeToFitContent {
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.contentSize = contentRect.size;
}

@end
