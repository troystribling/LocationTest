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
#import "LocationDelegate.h"

@implementation LocationTestViewController

@synthesize m_gpsLabel;
@synthesize m_significantLabel;
@synthesize m_significantSwitch;
@synthesize m_gpsSwitch;
@synthesize m_map;
@synthesize m_distanceFilterButton, m_distanceFilterTextField;

- (void)viewDidLoad {
	m_gpsDelegate = [[LocationDelegate alloc] initWithName:@"GPS"];
    m_gpsDelegate.m_map = self.m_map;
	m_significantDelegate = [[LocationDelegate alloc] initWithName:@"SCLS"];
    m_significantDelegate.m_map = self.m_map;
    [super viewDidLoad];
}

- (void) significantOn {
	[LogViewController log:@"SCLS TRACKING ON"];
	m_significantManager = [[CLLocationManager alloc] init];
	m_significantManager.delegate = m_significantDelegate;
	[m_significantManager startMonitoringSignificantLocationChanges];
}

- (void) significantOff {
	[LogViewController log:@"SCLS TRACKING OFF"];
	[m_significantManager stopMonitoringSignificantLocationChanges];
}

- (void) gpsOn {
	[LogViewController log:@"GPS TRACKING ON"];
	m_gpsManager = [[CLLocationManager alloc] init];
	m_gpsManager.delegate = m_gpsDelegate;
    m_gpsManager.distanceFilter = kCLDistanceFilterNone;
	[m_gpsManager startUpdatingLocation];
    self.m_distanceFilterTextField.text = [NSString stringWithFormat:@"%f", m_gpsManager.distanceFilter];
}

- (void) gpsOff {
	[LogViewController log:@"GPS TRACKING OFF"];
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
    self.m_distanceFilterTextField.text = [NSString stringWithFormat:@"%f", m_gpsManager.distanceFilter];
    [self.m_distanceFilterTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
