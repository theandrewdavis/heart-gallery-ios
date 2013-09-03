//
//  Child+Utility.h
//  HeartGallery
//
//  Created by Andrew Davis on 9/2/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "Child.h"

@interface Child (Utility)
+ (NSPredicate *)predicateForAgeAtMost:(NSUInteger)age;
+ (NSPredicate *)predicateForAgeAtLeast:(NSUInteger)age;
+ (NSPredicate *)predicateForAgeBetween:(NSUInteger)minAge maxAge:(NSUInteger)maxAge;
@end
