//
//  HGWebImageView.m
//  HeartGallery
//
//  Created by Andrew Davis on 6/25/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGWebImageView.h"
#import "UIImage+PDF.h"
#import "UIImageView+AFNetworking.h"

@interface HGWebImageView ()
@property (strong, nonatomic) UIImageView *placeholder;
@property (strong, nonatomic) UIImageView *content;
@end

@implementation HGWebImageView

- (void)layoutSubviews {
    // Add a "loading" indicator as a placeholder while the image loads.
    self.placeholder = [[UIImageView alloc] initWithFrame:self.bounds];
    self.placeholder.contentMode = UIViewContentModeCenter;
    self.placeholder.image = [UIImage imageWithPDFNamed:@"loading.pdf" atHeight:self.bounds.size.width / 6];
    [self addSubview:self.placeholder];
    
    // Add the content image asynchronously from the web if URL is already set.
    self.content = [[UIImageView alloc] initWithFrame:self.bounds];
    self.content.contentMode = self.contentMode;
    [self addSubview:self.content];
    [self.content setImageWithURL:self.url];
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    [self.content setImageWithURL:self.url];
}

@end
