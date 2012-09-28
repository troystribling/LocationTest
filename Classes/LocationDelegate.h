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

@property (nonatomic, strong) NSString              *m_serviceName;
@property (strong, nonatomic) NSMutableArray        *m_locations;
@property (weak, nonatomic)   MKMapView             *m_map;
@property (nonatomic, strong) UILabel               *m_statusLabel;

- (id)initWithName:(NSString*)serviceName;

@end


