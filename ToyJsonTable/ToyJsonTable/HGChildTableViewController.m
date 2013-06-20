//
//  HGChildTableViewController.m
//  ToyJsonTable
//
//  Created by Andrew Davis on 6/15/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGChildTableViewController.h"
#import "HGChildDetailViewController.h"

#define kChildTableViewRowHeight 90
#define kChildTableViewLabelLeftMargin 8
#define kChildTableViewLabelRightMargin 20
#define kChildTableCellImageViewTag 1
#define kChildTableCellLabelTag 2

@interface HGChildTableViewController ()

@end

@implementation HGChildTableViewController

// Load table data from a JSON file on initialization.
- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.tableView.rowHeight = kChildTableViewRowHeight;
        
        // Set the title of the navigation bar.
        self.navigationItem.title = @"Children";
        
        // Load children dictionary from JSON file.
        NSError *error = nil;
        NSString* responsePath = [[NSBundle mainBundle] pathForResource:@"response" ofType:@"json"];
        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:responsePath encoding:NSUTF8StringEncoding error:&error];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        self.children = json[@"children"];
    }
    return self;
}

// Set the number of sections in the table.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Set the number of rows in each section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.children.count;
}

// Create a cell for the given section and row.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChildTableCell";

    // Get a cached cell layout if it is availble. Create one if it is not yet available.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // Create child thumbnail image.
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.rowHeight - 1, tableView.rowHeight - 1)];
        imageView.tag = kChildTableCellImageViewTag;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setClipsToBounds:YES];
        [cell.contentView addSubview:imageView];

        // Create label for child name.
        CGFloat labelWidth = tableView.bounds.size.width - tableView.rowHeight - kChildTableViewLabelLeftMargin - kChildTableViewLabelRightMargin;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tableView.rowHeight + kChildTableViewLabelLeftMargin, 0, labelWidth, tableView.rowHeight)];
        label.tag = kChildTableCellLabelTag;
        label.font = [UIFont boldSystemFontOfSize:20];
        label.numberOfLines = 0;
        [cell.contentView addSubview:label];
    }
    
    // Configure the cell.
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:kChildTableCellImageViewTag];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:kChildTableCellLabelTag];
    NSDictionary *child = self.children[indexPath.row];
    NSString *imageName = [[child[@"image-thumbnail"] componentsSeparatedByString:@"/"] lastObject];
    imageView.image = [UIImage imageNamed:imageName];
    label.text = child[@"name"];
    
    return cell;
}

// On selection, show a detail view of the child.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *child = self.children[indexPath.row];
    HGChildDetailViewController *childDetailView = [[HGChildDetailViewController alloc] initWithChild:child];
    [self.navigationController pushViewController:childDetailView animated:YES];
}

@end
