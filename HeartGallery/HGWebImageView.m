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
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@end

@implementation HGWebImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Add an activity indicator to show then the image is loading.
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.center = self.center;
        self.activityIndicator.hidden = YES;
        [self addSubview:self.activityIndicator];
    }
    return self;
}

- (void)setUrl:(NSURL *)url {
    _url = url;

    // Start the activity indicator.
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;

    // Load a remote image.
    __weak typeof(self) weakSelf = self;
    NSURLRequest *imageRequest = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    [self setImageWithURLRequest:imageRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        // Stop the activity indicator when the image is done loading.
        weakSelf.activityIndicator.hidden = YES;
        [weakSelf.activityIndicator stopAnimating];
        weakSelf.image = image;
    } failure:nil];
}

@end
