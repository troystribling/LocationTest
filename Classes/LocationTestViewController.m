//
//  LocationTestViewController.m
//  LocationTest
//
//  Created by Tom Horn on 11/08/10.
//  Copyright Cognethos Pty Ltd 2010. All rights reserved.
//

#import "LocationTestViewController.h"
#import "LogViewController.h"
#import "LocationTestAppDelegate.h"

@implementation LocationDelegate

- (id) initWithLabel:(UILabel*)label {
	resultsLabel = label;
	return [super init];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {	
	resultsLabel.text = [NSString stringWithFormat:@"(%@) %@ Failed to get location %@", ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) ? @"BG" : @"FG" , resultsLabel.tag == 0 ? @"GPS:" : @"SCLS", [error localizedDescription]];
	LocationTestAppDelegate * appDelegate = (LocationTestAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate log:resultsLabel.text];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeStyle:NSDateFormatterMediumStyle];		
	resultsLabel.text = [NSString stringWithFormat:@"(%@) %@ Location %.06f %.06f %@", ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) ? @"BG" : @"FG", resultsLabel.tag == 0 ? @"GPS:" : @"SCLS" , newLocation.coordinate.latitude, newLocation.coordinate.longitude, [formatter stringFromDate:newLocation.timestamp]];
	LocationTestAppDelegate * appDelegate = (LocationTestAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate log:resultsLabel.text];
}

@end


@implementation LocationTestViewController

@synthesize m_gpsResultsLabel;
@synthesize m_significantResultsLabel;
@synthesize m_significantSwitch;
@synthesize m_gpsSwitch;
@synthesize m_mapSwitch;
@synthesize m_map;
@synthesize m_distanceFilterButton, m_distanceFilterTextField;
@synthesize m_gpsLocations, m_sclsLocations;

- (void) log:(NSString*)msg andLabel:(UILabel*)label; {
	LocationTestAppDelegate * appDelegate = (LocationTestAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate log:msg];
	if(label) {
		label.text = msg;
    }
}

- (void)viewDidLoad {
	m_gpsDelegate = [[LocationDelegate alloc] initWithLabel:m_gpsResultsLabel];
	m_significantDelegate = [[LocationDelegate alloc] initWithLabel:m_significantResultsLabel];
    [super viewDidLoad];
}

- (void) significantOn {
	[self log:@"SCLS TRACKING ON: " andLabel:m_significantResultsLabel];
	m_significantManager = [[CLLocationManager alloc] init];
	m_significantManager.delegate = m_significantDelegate;
	[m_significantManager startMonitoringSignificantLocationChanges];
}

- (void) significantOff {
	[self log:@"SCLS TRACKING OFF:" andLabel:m_significantResultsLabel];
	[m_significantManager stopMonitoringSignificantLocationChanges];
}

- (void) gpsOn {
	[self log:@"GPS TRACKING ON:" andLabel:m_gpsResultsLabel];
	m_gpsManager = [[CLLocationManager alloc] init];
	m_gpsManager.delegate = m_gpsDelegate;
	[m_gpsManager startUpdatingLocation];
    self.m_distanceFilterTextField.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:m_gpsManager.distanceFilter]];
}

- (void) gpsOff {
	[self log:@"GPS TRACKING OFF:" andLabel:m_gpsResultsLabel];
	[m_gpsManager stopUpdatingLocation];
}

-(IBAction) actionGps:(id)sender {
	if (m_gpsSwitch.on) {
		[self gpsOn];
	} else {
		[self gpsOff];
    }
}

-(IBAction) actionSignificant:(id)sender {
	if (m_significantSwitch.on) {
		[self significantOn];
	} else {
		[self significantOff];
    }
}

-(IBAction) actionLog:(id)sender {
	LogViewController* pNewController=[[LogViewController alloc] initWithNibName:@"LogViewController" bundle:nil];
	[self presentViewController:pNewController animated:YES completion:nil];
}

-(IBAction) setDistanceFilter:(id)sender {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *distanceFiler = [numberFormatter numberFromString:self.m_distanceFilterTextField.text];
    m_gpsManager.distanceFilter = [distanceFiler doubleValue];
    self.m_distanceFilterTextField.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:m_gpsManager.distanceFilter]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
