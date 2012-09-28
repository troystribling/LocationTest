//
//  LocationDelegate.m
//  LocationTest
//
//  Created by Troy Stribling on 9/28/12.
//
//

#import "LocationDelegate.h"
#import "LogViewController.h"

@implementation LocationDelegate

@synthesize m_locations, m_map, m_serviceName, m_statusLabel;

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
    [m_locations addObject:location];
    NSString* logMessage = [NSString stringWithFormat:@"(%@) %@ Location: %.06f %.06f %@",  [self applicationState], m_serviceName,
                            location.coordinate.latitude, location.coordinate.longitude, [formatter stringFromDate:location.timestamp]];
    [LogViewController log:logMessage];
}

- (NSString*)applicationState {
    return ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) ? @"BG" : @"FG";
}

@end



