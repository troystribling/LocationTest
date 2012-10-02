//
//  LocationDelegate.h
//  LocationTest
//
//  Created by Troy Stribling on 9/28/12.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface  LocationDelegate : NSObject <CLLocationManagerDelegate>  

@property (nonatomic, strong) NSString                          *m_serviceName;
@property (strong, nonatomic) NSMutableArray                    *m_locations;
@property (weak, nonatomic)   MKMapView                         *m_map;
@property (nonatomic, strong) UILabel                           *m_statusLabel;
@property (nonatomic, unsafe_unretained) MKPinAnnotationColor   m_pinColor;

- (id)initWithName:(NSString*)serviceName;
+ (NSString*)applicationState;
- (NSDate*)lastUpdate;
- (void)handleLocationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
- (void)handleLocationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)location fromLocation:(CLLocation *)oldLocation;

@end


