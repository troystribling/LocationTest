//
//  LocationDelegate.m
//  LocationTest
//
//  Created by Troy Stribling on 9/28/12.
//
//

#import "LocationDelegate.h"
#import "LogViewController.h"
#import "LocationAnnotation.h"

@implementation LocationDelegate

@synthesize m_locations, m_map, m_serviceName, m_statusLabel, m_pinColor;

- (id) initWithName:(NSString *)serviceName {
	m_serviceName = serviceName;
    m_locations = [NSMutableArray array];
	return [super init];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    m_statusLabel.textColor = [UIColor redColor];
	NSString* logMessage = [NSString stringWithFormat:@"(%@) %@ Failed to get location %@", [self applicationState], m_serviceName, [error localizedDescription]];
	[LogViewController log:logMessage];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)location fromLocation:(CLLocation *)oldLocation {
    m_statusLabel.textColor = [UIColor whiteColor];
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeStyle:NSDateFormatterMediumStyle];

    NSNumber *distance = [NSNumber numberWithInt:0];
    if ([m_locations count] > 0) {
        distance = [NSNumber numberWithDouble:[location getDistanceFrom:[m_locations lastObject]]];
    }
    [m_locations addObject:location];
    
    NSString* logMessage = [NSString stringWithFormat:@"(%@) %@ Location: %.06f %.06f %@",  [self applicationState], m_serviceName,
                            location.coordinate.latitude, location.coordinate.longitude, [formatter stringFromDate:location.timestamp]];
    [LogViewController log:logMessage];
    logMessage = [NSString stringWithFormat:@"%@ Travel Distance: %@ m", m_serviceName, distance];
    [LogViewController log:logMessage];
    if (m_map) {
        NSString *annotationTitle = [NSString stringWithFormat:@"(%@) %d %@", [self applicationState], [m_locations count], m_serviceName];
        NSString *annotationSubtitle = [NSString stringWithFormat:@"Distance: %d m", [distance integerValue]];
        LocationAnnotation *annotation = [[LocationAnnotation alloc] initWithCoordinates:location.coordinate
                                                                                   title:annotationTitle
                                                                                subTitle:annotationSubtitle];
        annotation.pinColor = m_pinColor;
        [m_map addAnnotation:annotation];
        if ([m_locations count] == 1) {
            MKCoordinateRegion mapRegion = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.05f, 0.05f));
            [m_map setRegion:mapRegion animated:YES];
        } else {
            [m_map setCenterCoordinate:location.coordinate];
        }
    }
}

- (NSString*)applicationState {
    return ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) ? @"BG" : @"FG";
}

@end



