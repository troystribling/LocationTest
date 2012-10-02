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
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class GPSLocationDelegate;
@class SignificantLocationChangeDelegate;

@interface LocationTestViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, MFMessageComposeViewControllerDelegate> {
	GPSLocationDelegate                     *m_gpsDelegate;
	SignificantLocationChangeDelegate       *m_significantDelegate;
	CLLocationManager                       *m_gpsManager;
	CLLocationManager                       *m_significantManager;
}

-(IBAction)actionGps:(id)sender;
-(IBAction)actionSignificant:(id)sender;
-(IBAction)actionLog:(id)sender;
-(IBAction)setDistanceFilter:(id)sender;
-(IBAction)sendLocation:(id)sender;
-(CLLocationDistance)getEnteredDistanceFilter;

@property (strong, nonatomic) IBOutlet UILabel      *m_gpsLabel;
@property (strong, nonatomic) IBOutlet UILabel      *m_significantLabel;
@property (strong, nonatomic) IBOutlet UISwitch     *m_gpsSwitch;
@property (strong, nonatomic) IBOutlet UISwitch     *m_significantSwitch;
@property (strong, nonatomic) IBOutlet MKMapView    *m_map;
@property (strong, nonatomic) IBOutlet UIButton     *m_distanceFilterButton;
@property (strong, nonatomic) IBOutlet UIButton     *m_logButton;
@property (strong, nonatomic) IBOutlet UITextField  *m_distanceFilterTextField;
@property (strong, nonatomic) IBOutlet UIButton     *m_sendLocationButton;

@end

