//
//  SignificantLocationChangeDelegate.m
//  LocationTest
//
//  Created by Troy Stribling on 10/1/12.
//
//

#import "SignificantLocationChangeDelegate.h"
#import "LogViewController.h"
#import "LocationAnnotation.h"
#import "LocationTestViewController.h"

@implementation SignificantLocationChangeDelegate

+ (SignificantLocationChangeDelegate*)createWithName:(NSString*)name {
    return [[self alloc] initWithName:name];
}

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error {
    [self handleLocationManager:manager didFailWithError:error];
}

- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation *)location fromLocation:(CLLocation *)oldLocation {
    if (self.m_viewController.m_gpsSwitch.on) {
        [self.m_viewController restartGPSSManager];
    }
    [self handleLocationManager:manager didUpdateToLocation:location fromLocation:oldLocation];
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager*)manager {
	[LogViewController log:@"SCLS PAUSED: locationManagerDidPauseLocationUpdates"];
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager*)manager {
	[LogViewController log:@"SCLS RESUMED: locationManagerDidResumeLocationUpdates"];
}

@end
