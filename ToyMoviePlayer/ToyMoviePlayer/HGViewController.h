//
//  HGViewController.h
//  ToyMoviePlayer
//
//  Created by Andrew Davis on 6/2/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface HGViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

@end
