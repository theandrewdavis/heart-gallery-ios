//
//  UIButton+ColorButton.m
//  HeartGallery
//
//  Created by Andrew Davis on 8/13/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "UIButton+ColorButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIButton (ColorButton)

+ (UIButton *)buttonWithColor:(UIColor *)color {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 0.5f;
    button.layer.cornerRadius = 5.0f; //10.0f;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    return button;
}

@end
