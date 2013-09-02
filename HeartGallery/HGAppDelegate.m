//
//  HGAppDelegate.m
//  HeartGallery
//
//  Created by Andrew Davis on 7/3/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGAppDelegate.h"
#import "HGRemoteDataController.h"
#import "HGHomeViewController.h"

static NSString *kStoreFile = @"HGCoreDataStore.sqlite";

@implementation HGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Create the main window.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Create a remote data controller to manage fetching children from the web.
    NSManagedObjectContext *managedObjectContext = [self createManagedObjectContext];
    HGRemoteDataController *remoteDataController = [[HGRemoteDataController alloc] init];
    remoteDataController.managedObjectContext = managedObjectContext;
    
    // Create a navigation controller as the root view controller and insert the home screen into it.
    HGHomeViewController *homeViewController = [[HGHomeViewController alloc] init];
    homeViewController.managedObjectContext = managedObjectContext;
    homeViewController.remoteDataController = remoteDataController;
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    
    [self.window makeKeyAndVisible];
    return YES;
}

// Create a managed object context to store child data.
- (NSManagedObjectContext *)createManagedObjectContext {
    // Load the managed object model from a file.
    NSURL *modelFileURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelFileURL];

//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MyApp" withExtension:@"momd"];
//    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    
    // Create a persistent store in the documents directory.
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    NSURL *documentDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentDir URLByAppendingPathComponent:kStoreFile];
    
    // Try to add the sqlite store.
    NSError *error = nil;
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        //  If it fails, try deleting the sqlite file. If it still fails, just log the error.
		[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
		if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            NSLog(@"Error creating store: %@, %@", error, error.userInfo);
		}
    }
    
    // Add the persistent store coordinator to a managed object context.
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    return managedObjectContext;
}

@end
