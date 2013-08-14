//
//  HGWebImageView.m
//  ToyImageLoader
//
//  Created by Andrew Davis on 6/25/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGWebImageView.h"
#import "UIImage+PDF.h"
#import "UIImageView+AFNetworking.h"

@implementation HGWebImageView

- (void)layoutSubviews {
    // Add a "loading" indicator as a placeholder while the image loads.
    UIImageView *placeholder = [[UIImageView alloc] initWithFrame:self.bounds];
    placeholder.contentMode = UIViewContentModeCenter;
    placeholder.image = [UIImage imageWithPDFNamed:@"loading.pdf" atHeight:self.bounds.size.width / 6];
    [self addSubview:placeholder];
    
    // Add the content image asynchronously from the web.
    UIImageView *content = [[UIImageView alloc] initWithFrame:self.bounds];
    content.contentMode = self.contentMode;
    [content setImageWithURL:self.url];
    [self addSubview:content];
}

@end
