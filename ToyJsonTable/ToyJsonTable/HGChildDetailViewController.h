//
//  HGChildDetailViewController.h
//  ToyJsonTable
//
//  Created by Andrew Davis on 6/19/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGChildDetailViewController : UIViewController

@property (strong, nonatomic) NSDictionary *child;

- (id)initWithChild:(NSDictionary *)child;
    
@end
