//
//  HGCalendarDetailViewController.h
//  HeartGallery
//
//  Created by Andrew Davis on 3/27/14.
//  Copyright (c) 2014 Andrew Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGCalendarDetailViewController : UIViewController <UIWebViewDelegate>
- (id)initWithEvent:(NSManagedObject *)event;
@end
