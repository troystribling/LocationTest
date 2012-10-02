//
//  GPSLocationDelegate.h
//  LocationTest
//
//  Created by Troy Stribling on 10/1/12.
//
//

#import "LocationDelegate.h"

@interface GPSLocationDelegate : LocationDelegate <CLLocationManagerDelegate>

+ (GPSLocationDelegate*)create;

@end
