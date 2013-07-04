//
//  HGHomeViewController.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/3/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGHomeViewController.h"
#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"

#define kHomeScreenMarginWidth 20.0
#define kHomeScreenButtonHeight 80.0

@interface HGHomeViewController ()

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation HGHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create a frame for the children button.
    CGFloat buttonY = self.view.bounds.size.height - kHomeScreenMarginWidth - kHomeScreenButtonHeight;
    CGFloat buttonWidth = self.view.bounds.size.width - 2 * kHomeScreenMarginWidth;
    CGRect childrenButtonFrame = CGRectMake(kHomeScreenMarginWidth, buttonY, buttonWidth, kHomeScreenButtonHeight);
    
    // Add the children button.
    UIButton *childrenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    childrenButton.frame = childrenButtonFrame;
    [childrenButton setTitle:@"Children" forState:UIControlStateNormal];
    [childrenButton addTarget:self action:@selector(showChildren) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:childrenButton];
}

- (void)showChildren {
    //
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8081/api.php"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        [SVProgressHUD showSuccessWithStatus:@"Complete"];

        NSLog(@"success!");
        NSArray *childJSON = ((NSDictionary *) JSON)[@"children"];
        for (NSDictionary *child in childJSON) {
            NSLog(@"Name: %@", child[@"name"]);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure");
        NSLog(@"%@", error.localizedDescription);
        [SVProgressHUD showErrorWithStatus:@"Could not connect"];
    }];
    
    [operation start];
}

@end
