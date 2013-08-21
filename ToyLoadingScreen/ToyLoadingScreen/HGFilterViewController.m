//
//  HGFilterViewController.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 8/19/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGFilterViewController.h"

static int kNavigationBarHeight = 44;

@interface HGFilterViewController ()
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *filters;
@property (strong, nonatomic) NSMutableArray *checkedRows;
@end

@implementation HGFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add a navigation bar to the view.
    CGRect navigationBarFrame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, kNavigationBarHeight);
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:navigationBarFrame];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"Filter"];
    navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];
    
    // Create a table of filter groups.
    CGRect tableViewFrame = CGRectMake(0.0, kNavigationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - kNavigationBarHeight);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    // List all filters in the table.
    if (!self.filters) {
        self.filters = @[
            @{
                @"title": @"Filter by siblings",
                @"filters": @[
                    @{@"title": @"Individual or Siblings", @"predicate": [NSPredicate predicateWithValue:YES]},
                    @{@"title": @"Individual", @"predicate": [NSPredicate predicateWithFormat:@"type = %@", @"individual"]},
                    @{@"title": @"Siblings", @"predicate": [NSPredicate predicateWithFormat:@"type = %@", @"sibling"]}
                ]
            },
            @{
                @"title": @"Filter by gender",
                @"filters": @[
                    @{@"title": @"Boys or girls", @"predicate": [NSPredicate predicateWithValue:YES]},
                    @{@"title": @"Boys", @"predicate": [NSPredicate predicateWithFormat:@"gender = %@", @"male"]},
                    @{@"title": @"Girls", @"predicate": [NSPredicate predicateWithFormat:@"gender = %@", @"female"]}
                ]
            },
            @{
                @"title": @"Filter by age",
                @"filters": @[
                    @{@"title": @"All ages", @"predicate": [NSPredicate predicateWithValue:YES]},
                    @{@"title": @"12 & Younger", @"predicate": [NSPredicate predicateWithFormat:@"age <= %@", @12]},
                    @{@"title": @"13 - 15", @"predicate": [NSPredicate predicateWithFormat:@"age >= %@ && age <= %@", @13, @15]},
                    @{@"title": @"16 & Older", @"predicate": [NSPredicate predicateWithFormat:@"age >= %@", @16]}
                ]
            }
        ];
        self.checkedRows = [NSMutableArray arrayWithObjects:@0, @0, @0, nil];
    }
}

- (void)done {
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    for (int section = 0; section < self.filters.count; section++) {
        int row = [self.checkedRows[section] intValue];
        NSPredicate *predicate = self.filters[section][@"filters"][row][@"predicate"];
        [predicates addObject:predicate];
    }
    [self.delegate didChangePredicate:[NSCompoundPredicate andPredicateWithSubpredicates:predicates]];
    [self dismissModalViewControllerAnimated:YES];
}

-  (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.filters.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionFilters = self.filters[section][@"filters"];
    return sectionFilters.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.filters[section][@"title"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FilterViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    NSArray *sectionFilters = self.filters[indexPath.section][@"filters"];
    cell.textLabel.text = sectionFilters[indexPath.row][@"title"];
    NSNumber *checkedRow = self.checkedRows[indexPath.section];
    cell.accessoryType = ([checkedRow intValue] == indexPath.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Uncheck old row.
    NSNumber *checkedRow = self.checkedRows[indexPath.section];
    UITableViewCell *previousCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[checkedRow intValue] inSection:indexPath.section]];
    previousCell.accessoryType = UITableViewCellAccessoryNone;
    
    // Check new row.
    self.checkedRows[indexPath.section] = [NSNumber numberWithInt:indexPath.row];
    UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // Un-highlight the currently selected cell.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
