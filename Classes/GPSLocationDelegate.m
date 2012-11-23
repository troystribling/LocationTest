//
//  GPSLocationDelegate.m
//  LocationTest
//
//  Created by Troy Stribling on 10/1/12.
//
//

#import "GPSLocationDelegate.h"
#import "LogViewController.h"

@implementation GPSLocationDelegate

+ (GPSLocationDelegate*)create {
    return [[self alloc] initWithName:@"GPS"];
}

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error {
    [self handleLocationManager:manager didFailWithError:error];
}

- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation *)location fromLocation:(CLLocation *)oldLocation {
    [self handleLocationManager:manager didUpdateToLocation:location fromLocation:oldLocation];
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager*)manager {
	[LogViewController log:@"GPS PAUSED: locationManagerDidPauseLocationUpdates"];
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager*)manager {
	[LogViewController log:@"GPS RESUMED: locationManagerDidResumeLocationUpdates"];
}

@end
