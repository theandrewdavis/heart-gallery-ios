//
//  HGMovieView.m
//  ToyMoviePlayer
//
//  Created by Andrew Davis on 6/4/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGMovieView.h"
#import <MediaPlayer/MediaPlayer.h>

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
    // Use a black background for when no poster is given.
    self.backgroundColor = [UIColor blackColor];
    
    // TODO add the play button
    
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

// Create a frame for the movie view.
+ (CGRect)frameWithAspectRatio:(CGFloat)aspectRatio withinBounds:(CGRect)bounds withMargin:(CGFloat)margin yOffset:(CGFloat)yOffset
{
    CGRect childFrame = bounds;
    childFrame.size.width -= 2 * margin;
    childFrame.size.height = (1.0 / aspectRatio) * childFrame.size.width;
    childFrame.origin.x = margin;
    childFrame.origin.y = yOffset;
    return childFrame;
}

@end
