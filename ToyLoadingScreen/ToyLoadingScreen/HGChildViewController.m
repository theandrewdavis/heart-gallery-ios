//
//  HGChildViewController.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/30/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGChildViewController.h"
#import "HGChild.h"
#import "HGMedia.h"

@implementation HGChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set the title to the child's name
    self.navigationItem.title = self.child.name;
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.numberOfLines = 0;
    for (HGMedia *mediaItem in self.child.media) {
        label.text = [NSString stringWithFormat:@"%@\n%@", label.text, mediaItem.name];
    }
    [self.view addSubview:label];
}

@end
