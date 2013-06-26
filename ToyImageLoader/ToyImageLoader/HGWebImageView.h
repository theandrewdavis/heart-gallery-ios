//
//  HGWebImageView.h
//  ToyImageLoader
//
//  Created by Andrew Davis on 6/25/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGWebImageView : UIView

@property (strong, nonatomic) NSString *urlString;

- (id)initWithFrame:(CGRect)frame urlString:(NSString *)urlString;

@end
