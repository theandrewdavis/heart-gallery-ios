//
//  HGMovieView.m
//  HeartGallery
//
//  Created by Andrew Davis on 4/7/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGMovieView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface HGMovieView()
@end

@implementation HGMovieView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Set a preview background view
    self.previewBackgroundView.frame = self.bounds;
    [self addSubview:self.previewBackgroundView];
    
    // Add the "play" overlay to indicate that this is a movie.
    UIImageView *playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PlayButton"]];
    playImageView.frame = self.bounds;
    playImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:playImageView];
    
    // Add a tap recognizer to allow the user to play the movie by tapping it.
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(movieTapped:)];
    [self addGestureRecognizer:tapRecognizer];
}

// Called when the user taps the movie frame.
- (void)movieTapped:(id)sender {
    // Play the movie. Beginning and ending an image context works around a bug described here:
    // http://stackoverflow.com/questions/13203336/iphone-mpmovieplayerviewcontroller-cgcontext-errors
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:self.movieURL];
    [self.rootViewController presentMoviePlayerViewControllerAnimated:movieController];
    UIGraphicsEndImageContext();
}
@end
