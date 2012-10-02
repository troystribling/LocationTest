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
    [self.m_viewController restartService];
    [self handleLocationManager:manager didUpdateToLocation:location fromLocation:oldLocation];
}

@end
