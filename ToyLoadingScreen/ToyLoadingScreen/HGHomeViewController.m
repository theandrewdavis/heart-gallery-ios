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
#import "Child.h"

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
    
    // 1. Use the same column names as MySQL
    // 2. Use NSFetchRequest to display children in a table
    // 3. Setup core data to work with multiple entities like media
    
    // 1. Start the table view as empty with a loading dialog.
    // 2. Show an error when reachability is off or a server error, timeout.
    // 3. Populate/update table on call success.
    // 4. Ignore 304 not modifieds
    // 5. Pull to refresh.
    
    
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
    
    NSLog(@"Before...");
    // Load all children from Core Data and print them.
    for (Child *child in [Child allFromContext:self.managedObjectContext]) {
        NSLog(@"Name: %@, id: %@", child.name, child.childID);
    }
    
}

- (void)showChildren {
    //
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8081/api.php"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        NSLog(@"success!");

        // Replace locally stored child list with the updated version.
        NSArray *childrenJSON = ((NSDictionary *) JSON)[@"children"];
        [Child replaceAllWith:childrenJSON inContext:self.managedObjectContext];
        NSLog(@"Done saving!");

        [SVProgressHUD showSuccessWithStatus:@"Complete"];
        
        NSLog(@"After...");
        // Load all children from Core Data and print them.
        for (Child *child in [Child allFromContext:self.managedObjectContext]) {
            NSLog(@"Name: %@, id: %@", child.name, child.childID);
        }


    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure");
        NSLog(@"%@", error.localizedDescription);
        [SVProgressHUD showErrorWithStatus:@"Could not connect"];
    }];
    
    [operation start];
}

@end
