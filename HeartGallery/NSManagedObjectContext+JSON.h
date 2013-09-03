//
//  NSManagedObjectContext+JSON.h
//  HeartGallery
//
//  Created by Andrew Davis on 9/3/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (JSON)
- (NSManagedObject *) addEntity:(NSString *)entityName fromJSON:(NSDictionary *)json;
@end
