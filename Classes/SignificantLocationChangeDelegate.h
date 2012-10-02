//
//  SignificantLocationChangeDelegate.h
//  LocationTest
//
//  Created by Troy Stribling on 10/1/12.
//
//

#import "LocationDelegate.h"

@interface SignificantLocationChangeDelegate : LocationDelegate <CLLocationManagerDelegate>

+ (SignificantLocationChangeDelegate*)createWithName:(NSString*)name;

@end
