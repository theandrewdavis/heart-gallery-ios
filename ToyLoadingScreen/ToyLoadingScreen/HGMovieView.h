//
//  HGMovieView.h
//  SlideShowDemo
//
//  Created by Andrew Davis on 4/7/13.
//  Copyright (c) 2013 Kiwi Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGMovieView : UIView
@property (strong, nonatomic) UIView *previewBackgroundView;
@property (strong, nonatomic) NSURL *movieURL;
@property (weak, nonatomic) UIViewController *rootViewController;
@end
