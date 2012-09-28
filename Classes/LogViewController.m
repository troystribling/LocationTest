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

- (id)init {
	return [super init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
}

-(IBAction) actionClear:(id)sender {
	[self.class clearLog];
	[m_tableView reloadData];
}

-(IBAction) actionClose:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Logging

+ (NSString*)locationPath {
	NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	return [path stringByAppendingPathComponent:@"locationPath.txt"];
}

+ (void)clearLog {
	NSString * content = @"";
	NSString * fileName = [self locationPath];
	[content writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
}

+ (NSArray*)getLogArray {
	NSString * fileName = [self locationPath];
	NSString *content = [NSString stringWithContentsOfFile:fileName usedEncoding:nil error:nil];
	NSMutableArray * array = (NSMutableArray *)[content componentsSeparatedByString:@"\n"];
	NSMutableArray * newArray = [[NSMutableArray alloc] init];
	for (int i = 0; i < [array count]; i++) {
		NSString * item = [array objectAtIndex:i];
		if ([item length])
			[newArray addObject:item];
	}
	return (NSArray*)newArray;
}
+ (void)log:(NSString*)msg {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeStyle:NSDateFormatterMediumStyle];
	NSString *logMessage = [NSString stringWithFormat:@"(%@) %@", [formatter stringFromDate:[NSDate date]], msg];
    NSLog(@"%@", logMessage);
	NSString *fileName = [self locationPath];
	FILE * f = fopen([fileName UTF8String], "at");
	fprintf(f, "%s\n", [logMessage UTF8String]);
	fclose (f);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray * logArray = [self.class getLogArray];
    return [logArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSArray * logArray = [self.class getLogArray];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	cell.textLabel.text = [logArray objectAtIndex:[logArray count] - indexPath.row - 1];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

