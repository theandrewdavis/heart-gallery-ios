//
//  HGViewController.m
//  ToyJsonTable
//
//  Created by Andrew Davis on 6/10/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGViewController.h"

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
    self.children = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];

    for (NSDictionary *child in self.children[@"children"]) {
        NSLog(@"%@", child[@"name"]);
    }

}

@end
