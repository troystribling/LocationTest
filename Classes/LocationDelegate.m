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

- (NSDate*)lastUpdate {
    NSDate* lastUpdate = [NSDate date];
    if ([m_locations count] > 0) {
        CLLocation* lastLocation = [m_locations lastObject];
        lastUpdate = lastLocation.timestamp;
    }
    return lastUpdate;
}

+ (NSString*)applicationState {
    return ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) ? @"BG" : @"FG";
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    m_statusLabel.textColor = [UIColor redColor];
	NSString* logMessage = [NSString stringWithFormat:@"(%@) %@ ERROR: %@", [self.class applicationState], m_serviceName, [error localizedDescription]];
	[LogViewController log:logMessage];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)location fromLocation:(CLLocation *)oldLocation {
    m_statusLabel.textColor = [UIColor whiteColor];
    
    NSNumber *distance = [NSNumber numberWithInt:0];
    if ([m_locations count] > 0) {
        distance = [NSNumber numberWithDouble:[location getDistanceFrom:[m_locations lastObject]]];
    }
    [m_locations addObject:location];
    
    NSString* logMessage = [NSString stringWithFormat:@"(%@) %@ Location: %.6f %.6f",  [self.class applicationState], m_serviceName,
                            location.coordinate.latitude, location.coordinate.longitude];
    [LogViewController log:logMessage];
    logMessage = [NSString stringWithFormat:@"%@ Distance: %d m, Speed: %.1f m/s, Alt: %.0f m", m_serviceName, [distance integerValue], location.speed, location.altitude];
    [LogViewController log:logMessage];
    if (m_map) {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        NSString *annotationTitle = [NSString stringWithFormat:@"(%d:%@:%@) %@", [m_locations count], [self.class applicationState], m_serviceName, [dateFormatter stringFromDate:[NSDate date]]];
        NSString *annotationSubtitle = [NSString stringWithFormat:@"Distance: %d m, Speed: %.1f m/s\n Alt: %.0f m", [distance integerValue], location.speed, location.altitude];
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

@end



