//
//  HGChildViewController.h
//  HeartGallery
//
//  Created by Andrew Davis on 7/30/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGSlideShow.h"

@class HGChild;

@interface HGChildViewController : UIViewController <HGSlideShowDataSource, UIWebViewDelegate>
@property (strong, nonatomic) HGChild *child;
@end
