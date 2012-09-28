//
//  LogViewController.m
//  LocationTest
//
//  Created by Tom Horn on 12/08/10.
//  Copyright 2010 Cognethos Pty Ltd. All rights reserved.
//

#import "LogViewController.h"
#import "LocationTestAppDelegate.h"


@implementation LogViewController

@synthesize m_tableView;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(IBAction) actionClear:(id)sender {
	LocationTestAppDelegate * appDelegate = (LocationTestAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate clearLog];
	[m_tableView reloadData];
}

-(IBAction) actionClose:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	LocationTestAppDelegate * appDelegate = (LocationTestAppDelegate *)[UIApplication sharedApplication].delegate;
	NSArray * logArray = [appDelegate getLogArray];
    return [logArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	LocationTestAppDelegate * appDelegate = (LocationTestAppDelegate *)[UIApplication sharedApplication].delegate;
	NSArray * logArray = [appDelegate getLogArray];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
	cell.textLabel.text = [logArray objectAtIndex:[logArray count] - indexPath.row - 1];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}




@end

