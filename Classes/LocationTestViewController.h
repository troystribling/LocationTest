//
//  LocationTestViewController.h
//  LocationTest
//
//  Created by Tom Horn on 11/08/10.
//  Copyright Cognethos Pty Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface  LocationDelegate : NSObject <CLLocationManagerDelegate> 
{
	UILabel * resultsLabel;
}

- (id) initWithLabel:(UILabel*)label;

@end


@interface LocationTestViewController : UIViewController <CLLocationManagerDelegate> {
	LocationDelegate    *m_gpsDelegate;
	LocationDelegate    *m_significantDelegate;
	CLLocationManager   *m_gpsManager;
	CLLocationManager   *m_significantManager;
}

-(IBAction) actionGps:(id)sender;
-(IBAction) actionSignificant:(id)sender;
-(IBAction) actionLog:(id)sender;
-(IBAction) setDistanceFilter:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel      *m_gpsResultsLabel;
@property (strong, nonatomic) IBOutlet UILabel      *m_significantResultsLabel;
@property (strong, nonatomic) IBOutlet UISwitch     *m_gpsSwitch;
@property (strong, nonatomic) IBOutlet UISwitch     *m_significantSwitch;
@property (strong, nonatomic) IBOutlet UISwitch     *m_mapSwitch;
@property (strong, nonatomic) IBOutlet MKMapView    *m_map;
@property (strong, nonatomic) IBOutlet UIButton     *m_distanceFilterButton;
@property (strong, nonatomic) IBOutlet UITextField  *m_distanceFilterTextField;
@property (strong, nonatomic) NSMutableArray        *m_gpsLocations;
@property (strong, nonatomic) NSMutableArray        *m_sclsLocations;

@end

