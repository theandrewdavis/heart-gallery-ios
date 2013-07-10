//
//  HGHomeViewController.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/3/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGHomeViewController.h"
#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"

#define kHomeScreenMarginWidth 20.0
#define kHomeScreenButtonHeight 80.0

@interface HGHomeViewController ()

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation HGHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1. Save JSON on disk
    // 2. Recognize 304s and use disk's JSON
    // 3. Recognize network failures and use disk's JSON
    // 4. Recognize offline mode and use disk's JSON
    
    // I'm learning CoreData to be my disk store.
    // Considered using RestKit to simplify this. May do it in the future, but it is complex in its own
    // right and requires knowledge of CoreData anyway, so I should start with CD.
    
    // Following tutorial here:
    // http://developer.apple.com/library/ios/#documentation/DataManagement/Conceptual/iPhoneCoreData01/Articles/02_RootViewController.html
    
    // Creating the MOM in code:
    // http://www.cocoanetics.com/2012/04/creating-a-coredata-model-in-code/
    
    //
//    NSManagedObject *child = [NSEntityDescription insertNewObjectForEntityForName:@"Child" inManagedObjectContext:self.managedObjectContext];
//    [child setValue:@24 forKey:@"id"];
//    [child setValue:@"Alicia" forKey:@"name"];
//    [child setValue:@"http://heartgalleryofalabama.com/thumbnails/alicia" forKey:@"imageThumbnail"];
//    [child setValue:@"http://heartgalleryofalabama.com/images/alicia" forKey:@"imageFull"];
//    
//    NSError *error = nil;
//    if (![self.managedObjectContext save:&error]) {
//        NSLog(@"Error!");
//    }
    
    // Create a frame for the children button.
    CGFloat buttonY = self.view.bounds.size.height - kHomeScreenMarginWidth - kHomeScreenButtonHeight;
    CGFloat buttonWidth = self.view.bounds.size.width - 2 * kHomeScreenMarginWidth;
    CGRect childrenButtonFrame = CGRectMake(kHomeScreenMarginWidth, buttonY, buttonWidth, kHomeScreenButtonHeight);
    
    // Add the children button.
    UIButton *childrenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    childrenButton.frame = childrenButtonFrame;
    [childrenButton setTitle:@"Children" forState:UIControlStateNormal];
    [childrenButton addTarget:self action:@selector(showChildren) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:childrenButton];
    
    // Load all children from Core Data and print them.
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Child"];
    NSSortDescriptor *sortNameDescending = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    request.sortDescriptors = @[sortNameDescending];

    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (results == nil) {
        NSLog(@"Error fetching from store: %@, %@", error, error.userInfo);
    }
    
    for (NSManagedObject *child in results) {
        NSLog(@"Name: %@, id: %@", (NSString *)[child valueForKey:@"name"], (NSNumber *)[child valueForKey:@"id"]);
    }

}

- (void)showChildren {
    //
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8081/api.php"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        [SVProgressHUD showSuccessWithStatus:@"Complete"];

        NSLog(@"success!");
        NSArray *childJSON = ((NSDictionary *) JSON)[@"children"];
        for (NSDictionary *child in childJSON) {
            NSLog(@"Name: %@", child[@"name"]);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure");
        NSLog(@"%@", error.localizedDescription);
        [SVProgressHUD showErrorWithStatus:@"Could not connect"];
    }];
    
    [operation start];
}

@end
