//
//  HGMovieView.h
//  ToyMoviePlayer
//
//  Created by Andrew Davis on 6/4/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGMovieView : UIView
@property (weak, nonatomic) UIViewController* controller;
@property (strong, nonatomic) NSURL* movie;
@property (strong, nonatomic) NSURL* poster;

- (id)initWithFrame:(CGRect)frame controller:(UIViewController*)controller movieURL:(NSURL*)movie;
+ (CGRect)frameWithAspectRatio:(CGFloat)aspectRatio withinBounds:(CGRect)bounds withMargin:(CGFloat)margin yOffset:(CGFloat)yOffset;
@end
