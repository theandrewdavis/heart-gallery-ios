//
//  HGMovieView.m
//  ToyMoviePlayer
//
//  Created by Andrew Davis on 6/4/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGMovieView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIImage+PDF.h"

@implementation HGMovieView

- (id)initWithFrame:(CGRect)frame controller:(UIViewController*)controller movieURL:(NSURL*)movie
{
    self = [super initWithFrame:frame];
    if (self) {
        self.controller = controller;
        self.movie = movie;
    }
    return self;
}

- (void)layoutSubviews
{
    // Use a black background.
    self.backgroundColor = [UIColor blackColor];
    
    // Add the play button
    CGFloat playButtonHeight = self.bounds.size.height * 0.25;
    CGRect playButtonFrame = CGRectMake((self.bounds.size.width - playButtonHeight) / 2.0, (self.bounds.size.height - playButtonHeight) / 2.0, playButtonHeight, playButtonHeight);
    UIImageView *playButtonView = [[UIImageView alloc] initWithImage:[UIImage imageWithPDFNamed:@"video-play.pdf" atHeight:playButtonHeight]];
    playButtonView.frame = playButtonFrame;
    [self addSubview:playButtonView];
    
    // Add a tap recognizer to allow the user to play the movie by tapping it.
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self addGestureRecognizer:tapRecognizer];
}

// Callback for when the view is tapped.
- (void)viewTapped:(id)sender
{
    // Play the movie. Beginning and ending an image context works around a bug described here:
    // http://stackoverflow.com/questions/13203336/iphone-mpmovieplayerviewcontroller-cgcontext-errors
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:self.movie];
    [self.controller presentViewController:movieController animated:NO completion:NULL];
    UIGraphicsEndImageContext();
}

@end
