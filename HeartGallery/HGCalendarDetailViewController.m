//
//  HGCalendarDetailViewController.m
//  HeartGallery
//
//  Created by Andrew Davis on 3/27/14.
//  Copyright (c) 2014 Andrew Davis. All rights reserved.
//

#import "HGCalendarDetailViewController.h"
#import "HGCalendarEventDates.h"

@interface HGCalendarDetailViewController ()
@property (strong, nonatomic) NSManagedObject *event;
@property (strong, nonatomic) HGCalendarEventDates *dates;
@end

@implementation HGCalendarDetailViewController

- (id)initWithEvent:(NSManagedObject *)event {
    self = [super init];
    if (self) {
        self.event = event;
        self.dates = [[HGCalendarEventDates alloc] initWithStartDate:[event valueForKey:@"start"]  andEndDate:[event valueForKey:@"end"]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set up event details as an HTML string.
    NSMutableString *content = [[NSMutableString alloc] init];
    [content appendString:@"<style>h2 {font-family: sans-serif; text-align: center;}\nli {padding-right: 2em;}\np {padding: 0 1em 0 1em;}</style>"];
    [content appendString:[NSString stringWithFormat:@"<h2>%@</h2>", [self.event valueForKey:@"summary"]]];
    [content appendString:@"<ul>"];
    if (!self.dates.multiday) {
        [content appendString:[NSString stringWithFormat:@"<li>Date: %@</li>", self.dates.startDate]];
    } else {
        [content appendString:[NSString stringWithFormat:@"<li>Dates: %@ - %@</li>", self.dates.startDate, self.dates.endDate]];
    }
    if ([self.event valueForKey:@"location"]) {
        [content appendString:[NSString stringWithFormat:@"<li>Location: %@</li>", [self.event valueForKey:@"location"]]];
    }
    [content appendString:@"</ul>"];
    if ([self.event valueForKey:@"details"]) {
        [content appendString:[NSString stringWithFormat:@"<p>%@</p>", [self.event valueForKey:@"details"]]];
    }

    // Display HTML string in a web view.
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    [self.view addSubview:webView];
    [webView loadHTMLString:content baseURL:nil];
}

@end
