//
//  NSDictionary+Utility.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 8/4/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "NSDictionary+Utility.h"

@implementation NSDictionary (Utility)

// Retrieve a value from a dictionary, replacing NSNull results with nil.
- (id)objectForKeyNotNull:(id)key {
    id object = [self objectForKey:key];
    return ([object isEqual:[NSNull null]]) ? nil : object;
}

@end
