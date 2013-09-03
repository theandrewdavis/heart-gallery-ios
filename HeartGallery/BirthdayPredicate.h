//
//  BirthdayPredicate.h
//  HeartGallery
//
//  Created by Andrew Davis on 9/3/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BirthdayPredicate : NSObject
+ (NSPredicate *)predicateForAgeAtMost:(NSUInteger)age;
+ (NSPredicate *)predicateForAgeAtLeast:(NSUInteger)age;
+ (NSPredicate *)predicateForAgeBetween:(NSUInteger)minAge maxAge:(NSUInteger)maxAge;
@end
