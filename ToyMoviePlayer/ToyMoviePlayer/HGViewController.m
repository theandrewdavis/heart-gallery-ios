//
//  HGViewController.m
//  ToyMoviePlayer
//
//  Created by Andrew Davis on 6/2/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGViewController.h"

@interface HGViewController ()

@end

@implementation HGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add the text field
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 30.0f, 300.0f, 30.0f)];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    
    // Add the button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(110.0f, 100.0f, 100.0f, 30.0f);
    [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Press Me!" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    // Add the label
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(115.0f, 150.0f, 200.0f, 30.0f)];
    self.label.text = @"Hello World!";
    [self.view addSubview:self.label];
    
    // Add a movie player
    NSURL *movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"acacia-video" ofType:@"mp4"]];
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    self.moviePlayer.view.frame = [self findMovieViewFrame:self.view.bounds horizontalMargin:10.0f aspectRatio:9.0f / 5.0f offset:200.0f];
    [self.view addSubview:self.moviePlayer.view];
}

// Make the keyboard disappear when return is pressed.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

// Callback for when the button is pressed.
- (void)buttonPressed {
    NSLog(@"Play movie.");
    [self.moviePlayer play];
}

// Find the movie player's view frame
- (CGRect)findMovieViewFrame:(CGRect)parentBounds horizontalMargin:(CGFloat)horizontalMargin aspectRatio:(CGFloat)aspectRatio offset:(CGFloat)offset {
    CGRect childFrame = parentBounds;
    childFrame.size.width -= 2 * horizontalMargin;
    childFrame.size.height = (1.0f / aspectRatio) * childFrame.size.width;
    childFrame.origin.x = horizontalMargin;
    childFrame.origin.y = offset;
    return childFrame;
}

@end
