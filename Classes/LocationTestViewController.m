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
#import "GPSLocationDelegate.h"
#import "SignificantLocationChangeDelegate.h"
#import "LocationAnnotation.h"

@implementation LocationTestViewController

@synthesize m_gpsLabel;
@synthesize m_significantLabel;
@synthesize m_significantSwitch, m_trackSwitch;
@synthesize m_gpsSwitch;
@synthesize m_map;
@synthesize m_distanceFilterButton, m_distanceFilterTextField, m_sendLocationButton, m_logButton;

-(void)restartSCLSManager {
    [LogViewController log:@"RESTARTING SCL LOCATION SERVICES"];
    if (m_significantSwitch.on) {
        [m_significantManager stopMonitoringSignificantLocationChanges];
        [m_significantManager startMonitoringSignificantLocationChanges];
    }
}

-(void)restartGPSSManager {
    [LogViewController log:@"RESTARTING GPS LOCATION SERVICES"];
    if (m_gpsSwitch.on) {
        [m_gpsManager stopUpdatingLocation];
        [m_gpsManager startUpdatingLocation];
    }
}

- (void)ping {
    double delayInSeconds = 120.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [LogViewController log:[NSString stringWithFormat:@"(%@) PING", [LocationDelegate applicationState]]];
        [self ping];
    });
}

- (void)viewDidLoad {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if (screenRect.size.height < 560.0f) {
        m_map.frame = CGRectMake(20.0f, 144.0f, 280.0f, 255.0f);
        m_logButton.frame = CGRectMake(20.0f, 405.0f, 280.0f, 37.0f);
    }
    m_map.delegate = self;
	m_gpsDelegate = [GPSLocationDelegate create];
    m_gpsDelegate.m_map = m_map;
    m_gpsDelegate.m_pinColor = MKPinAnnotationColorGreen;
    m_gpsDelegate.m_statusLabel = m_gpsLabel;
    m_gpsDelegate.m_viewController = self;
	m_significantDelegate = [SignificantLocationChangeDelegate createWithName:@"SCLS"];
    m_significantDelegate.m_map = m_map;
    m_significantDelegate.m_pinColor = MKPinAnnotationColorPurple;
    m_significantDelegate.m_statusLabel = m_significantLabel;
    m_significantDelegate.m_viewController = self;
    [self ping];
    [super viewDidLoad];
}

- (void)significantOn {
    m_sendLocationButton.enabled = YES;
	[LogViewController log:@"SCLS ON"];
    [m_significantDelegate.m_locations removeAllObjects];
    [m_map removeAnnotations:m_map.annotations];
	m_significantManager = [[CLLocationManager alloc] init];
	m_significantManager.delegate = m_significantDelegate;
	[m_significantManager startMonitoringSignificantLocationChanges];
}

- (void)significantOff {
    if (!m_gpsSwitch.on) {
        m_sendLocationButton.enabled = NO;
    }
	[LogViewController log:@"SCLS OFF"];
	[m_significantManager stopMonitoringSignificantLocationChanges];
}

- (void)gpsOn {
    m_sendLocationButton.enabled = YES;
	[LogViewController log:@"GPS ON"];
    [m_map removeAnnotations:m_map.annotations];
    [m_gpsDelegate.m_locations removeAllObjects];
	m_gpsManager = [[CLLocationManager alloc] init];
	m_gpsManager.delegate = m_gpsDelegate;
    m_gpsManager.distanceFilter = [self getEnteredDistanceFilter];
    m_distanceFilterTextField.text = [NSString stringWithFormat:@"%f", m_gpsManager.distanceFilter];
	[m_gpsManager startUpdatingLocation];
}

- (void)gpsOff {
    if (!m_significantSwitch.on) {
        m_sendLocationButton.enabled = NO;
    }
	[LogViewController log:@"GPS OFF"];
	[m_gpsManager stopUpdatingLocation];
}

- (void)trackGPSOn {
	[LogViewController log:@"TRACKING GPS ON"];
    m_sendLocationButton.enabled = YES;
	m_gpsManager = [[CLLocationManager alloc] init];
	m_gpsManager.delegate = m_gpsDelegate;
    m_gpsManager.distanceFilter = [self getEnteredDistanceFilter];
    m_distanceFilterTextField.text = [NSString stringWithFormat:@"%f", m_gpsManager.distanceFilter];
	[m_gpsManager startUpdatingLocation];
}

- (void)trackGPSOff {
    m_sendLocationButton.enabled = NO;
	[LogViewController log:@"TRACKING GPS OFF"];
	[m_gpsManager stopUpdatingLocation];
}

- (void)trackSCLSOn {
	[LogViewController log:@"TRACKING SCLS ON"];
	m_significantManager = [[CLLocationManager alloc] init];
	m_significantManager.delegate = m_significantDelegate;
	[m_significantManager startMonitoringSignificantLocationChanges];
}

- (void)trackSCLSOff {
	[LogViewController log:@"TRACK SCLS OFF"];
	[m_significantManager stopMonitoringSignificantLocationChanges];
}

-(void)setSwitchesEnabled {
	if (m_gpsSwitch.on || m_significantSwitch.on) {
        m_trackSwitch.enabled = NO;
    } else {
        m_trackSwitch.enabled = YES;
    }
    if (m_trackSwitch.on) {
        m_gpsSwitch.enabled = NO;
        m_significantSwitch.enabled = NO;
    } else {
        m_gpsSwitch.enabled = YES;
        m_significantSwitch.enabled = YES;
    }
}

- (void)trackOn {
	[LogViewController log:@"TRACKING ON"];
    [m_map removeAnnotations:m_map.annotations];
    [m_gpsDelegate.m_locations removeAllObjects];
    [m_significantDelegate.m_locations removeAllObjects];
    [self trackGPSOn];
}

- (void)trackOff {
    [self trackGPSOff];
}

-(IBAction)actionGps:(id)sender {
    [self setSwitchesEnabled];
	if (m_gpsSwitch.on) {
		[self gpsOn];
	} else {
		[self gpsOff];
    }
}

-(IBAction)actionSignificant:(id)sender {
    [self setSwitchesEnabled];
	if (m_significantSwitch.on) {
		[self significantOn];
	} else {
		[self significantOff];
    }
}

-(IBAction)actionTrack:(id)sender {
    [self setSwitchesEnabled];
	if (m_trackSwitch.on) {
		[self trackOn];
	} else {
		[self trackOff];
    }
}

-(IBAction)actionLog:(id)sender {
	LogViewController* pNewController=[[LogViewController alloc] initWithNibName:@"LogViewController" bundle:nil];
	[self presentViewController:pNewController animated:YES completion:nil];
}

-(IBAction)setDistanceFilter:(id)sender {
    if (m_gpsManager) {
        [m_gpsManager stopUpdatingLocation];
        m_gpsManager.distanceFilter = [self getEnteredDistanceFilter];
        m_distanceFilterTextField.text = [NSString stringWithFormat:@"%f", m_gpsManager.distanceFilter];
        [m_gpsManager startUpdatingLocation];
        [m_map removeAnnotations:m_map.annotations];
    } else {
        m_distanceFilterTextField.text = [NSString stringWithFormat:@"%f", [self getEnteredDistanceFilter]];
    }
    [m_distanceFilterTextField resignFirstResponder];
}

-(IBAction)sendLocation:(id)sender {
 	MFMessageComposeViewController *composer = [[MFMessageComposeViewController alloc] init];
	composer.messageComposeDelegate = self;
    CLLocation *location = nil;
    if (m_gpsSwitch.on) {
        location = [m_gpsDelegate.m_locations lastObject];
    } else if (m_significantSwitch.on) {
        location = [m_significantDelegate.m_locations lastObject];
    }
    composer.body = [NSString stringWithFormat:@"I am here: http://maps.apple.com/maps?q=%.6f,%.6f. Sent from LocationTest.", location.coordinate.latitude, location.coordinate.longitude];
	[self presentViewController:composer animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (MKAnnotationView *)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *result = nil;
    if ([annotation isKindOfClass:[LocationAnnotation class]] == NO) {
        return result;
    }
    if ([mapView isEqual:m_map] == NO) {
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
    NSNumber *distanceFiler = [numberFormatter numberFromString:m_distanceFilterTextField.text];
    CLLocationDistance distance = [distanceFiler doubleValue];
    if (distance < 1.0f) {
        distance = kCLDistanceFilterNone;
    }
    return distance;
}

- (void)messageComposeViewController:(MFMessageComposeViewController*)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
