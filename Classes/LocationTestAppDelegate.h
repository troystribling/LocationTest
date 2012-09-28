//
//  LocationTestAppDelegate.h
//  LocationTest
//
//  Created by Tom Horn on 11/08/10.
//  Copyright Cognethos Pty Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class LocationTestViewController;

@interface LocationTestAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate> {
	CLLocationManager* m_locManager;
}

@property (nonatomic, strong) IBOutlet UIWindow                     *window;
@property (nonatomic, strong) IBOutlet LocationTestViewController   *viewController;

@end

