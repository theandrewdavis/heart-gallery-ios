//
//  HGInvolvedViewController.m
//  HeartGallery
//
//  Created by Andrew Davis on 1/29/14.
//  Copyright (c) 2014 Andrew Davis. All rights reserved.
//

#import "HGInvolvedViewController.h"

@implementation HGInvolvedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Get Involved";

    NSString *text = @"<style>li {margin-left: -20px;} ul {font-size: 18px;}</style><ul><li>Make a tax deductible donation by clicking <a href=\"http://www.heartgalleryalabama.com/support.php\">here</a></li><li>If you would like to bring the exhibit to your area please <a href=\"mailto:info@heartgalleryalabama.com\">contact us!</a></li><li>Grant a wish from our <a href=\"http://www.amazon.com/wishlist/226536JX5Q1PP/ref=cm_sw_r_fa_ws_Yp5Dob0MPX9QJ\">wish list</a> on Amazon</li><li>Share your talent - <a href=\"mailto:info@heartgalleryalabama.com\">volunteer</a></li><li>Donate stock by <a href=\"mailto:info@heartgalleryalabama.com\">clicking here</a> for more information</li><li><a href=\"http://www.heartgalleryalabama.com/support.php\">Purchase</a> a Heart Gallery Alabama t-shirt (put the number of shirts and sizes in the information line)<ul><li>Short sleeve: $15</li><li>Long sleeve: $20</li></ul></li><li><a href=\"http://www.heartgalleryalabama.com/support.php\">Show</a> your love for adoption with a Heart Gallery decal<ul><li>Suggested donation of $3 ea. Add $1 for shipping</li></ul></li></ul>";

    UIWebView *textView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [textView loadHTMLString:text baseURL:nil];
    [self.view addSubview:textView];
    
}

@end
