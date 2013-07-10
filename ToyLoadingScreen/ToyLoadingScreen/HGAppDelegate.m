//
//  HGAppDelegate.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/3/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGAppDelegate.h"
#import "HGManagedObjectModel.h"
#import "HGHomeViewController.h"

@implementation HGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Create the main window.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Set an HGHomeViewController as top level view controller.
    HGHomeViewController *viewController = [[HGHomeViewController alloc] init];
    self.window.rootViewController = viewController;
    
    self.managedObjectModel = [[HGManagedObjectModel alloc] init];
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSURL *documentDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentDir URLByAppendingPathComponent:@"HGCoreDataStore.sqlite"];
    NSError *error = nil;
    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        //[[NSFileManager defaultManager] removeItemAtURL:storeURL error:NULL];
        // then readd
        NSLog(@"Error creating persistent store.");
    }
    
    self.managedObjectContext = [[NSManagedObjectContext alloc] init];
    self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    viewController.managedObjectContext = self.managedObjectContext;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
