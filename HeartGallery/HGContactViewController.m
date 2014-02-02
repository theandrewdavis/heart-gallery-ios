//
//  HGContactViewController.m
//  HeartGallery
//
//  Created by Andrew Davis on 1/29/14.
//  Copyright (c) 2014 Andrew Davis. All rights reserved.
//

#import "HGContactViewController.h"

@implementation HGContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Contact Us";

    NSString *text = @"<style>p {font-size: 18px}</style><p>For more information on Heart Gallery Alabama visit our website, <a href=\"http://www.heartgalleryalabama.com\">www.heartgalleryalabama.com</a>, or email <a href=\"mailto:info@heartgalleryalabama.com\">info@heartgalleryalabama.com</a>.</p><p>Do you have a story of how Heart Gallery Alabama has helped build your family? Do you want to share the story of how your child(ren) joined your family? Are you an adoptee who would like to share your unique story? What lessons have you learned through your adoption experience that others may benefit from?</p><p>These are just a few questions that you may have answers to but we welcome you to be creative. <a href=\"mailto:info@heartgalleryalabama.com\">Send</a> us your story and it may be featured on our Heart Gallery Alabama blog.</p>";

    UIWebView *textView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    textView.delegate = self;
    [textView loadHTMLString:text baseURL:nil];
    [self.view addSubview:textView];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}

@end
