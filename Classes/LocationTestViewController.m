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
#import "LocationAnnotation.h"

@implementation LocationTestViewController

@synthesize m_gpsLabel;
@synthesize m_significantLabel;
@synthesize m_significantSwitch;
@synthesize m_gpsSwitch;
@synthesize m_map;
@synthesize m_distanceFilterButton, m_distanceFilterTextField;

- (void)viewDidLoad {
    m_map.delegate = self;
	m_gpsDelegate = [[LocationDelegate alloc] initWithName:@"GPS"];
    m_gpsDelegate.m_map = m_map;
    m_gpsDelegate.m_pinColor = MKPinAnnotationColorGreen;
	m_significantDelegate = [[LocationDelegate alloc] initWithName:@"SCLS"];
    m_significantDelegate.m_map = m_map;
    m_significantDelegate.m_pinColor = MKPinAnnotationColorPurple;
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
    [m_map removeAnnotations:m_map.annotations];
    [m_significantDelegate.m_locations removeAllObjects];
	[m_significantManager stopMonitoringSignificantLocationChanges];
}

- (void) gpsOn {
	[LogViewController log:@"GPS TRACKING ON"];
	m_gpsManager = [[CLLocationManager alloc] init];
	m_gpsManager.delegate = m_gpsDelegate;
    m_gpsManager.distanceFilter = [self getEnteredDistanceFilter];
    self.m_distanceFilterTextField.text = [NSString stringWithFormat:@"%f", m_gpsManager.distanceFilter];
	[m_gpsManager startUpdatingLocation];
}

- (void) gpsOff {
	[LogViewController log:@"GPS TRACKING OFF"];
    [m_map removeAnnotations:m_map.annotations];
    [m_gpsDelegate.m_locations removeAllObjects];
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

-(IBAction)setDistanceFilter:(id)sender {
    if (m_gpsManager) {
        [m_gpsManager stopUpdatingLocation];
        m_gpsManager.distanceFilter = [self getEnteredDistanceFilter];
        self.m_distanceFilterTextField.text = [NSString stringWithFormat:@"%f", m_gpsManager.distanceFilter];
        [m_gpsManager startUpdatingLocation];
        [m_map removeAnnotations:m_map.annotations];
    } else {
        self.m_distanceFilterTextField.text = [NSString stringWithFormat:@"%f", [self getEnteredDistanceFilter]];
    }
    [self.m_distanceFilterTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (MKAnnotationView *)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *result = nil;
    if ([annotation isKindOfClass:[LocationAnnotation class]] == NO) {
        return result;
    }
    if ([mapView isEqual:self.m_map] == NO) {
        return result;
    }
    LocationAnnotation *senderAnnotation = (LocationAnnotation*)annotation;
    NSString *pinReusableIdentifier = [LocationAnnotation reusableIdentifierforPinColor:senderAnnotation.pinColor];
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinReusableIdentifier];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:senderAnnotation reuseIdentifier:pinReusableIdentifier];
        [annotationView setCanShowCallout:YES];
    }
    annotationView.pinColor = senderAnnotation.pinColor;
    result = annotationView;
    return result;
}

- (CLLocationDistance)getEnteredDistanceFilter {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *distanceFiler = [numberFormatter numberFromString:self.m_distanceFilterTextField.text];
    return [distanceFiler doubleValue];
}

@end
