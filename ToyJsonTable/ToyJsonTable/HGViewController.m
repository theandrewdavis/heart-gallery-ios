//
//  HGViewController.m
//  ToyJsonTable
//
//  Created by Andrew Davis on 6/10/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGViewController.h"
#import "HGChildTableViewController.h"

@interface HGViewController ()

@end

@implementation HGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Hello!");

    // Load children dictionary from JSON file.
    NSError *error = nil;
    NSString* responsePath = [[NSBundle mainBundle] pathForResource:@"response" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:responsePath encoding:NSUTF8StringEncoding error:&error];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];

    // Display children in a table view.
    self.tableViewController = [[HGChildTableViewController alloc] initWithChildren:json[@"children"]];
    self.tableViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.tableViewController.view];
}

@end
