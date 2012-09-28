//
//  LocationTestAppDelegate.m
//  LocationTest
//
//  Created by Tom Horn on 11/08/10.
//  Copyright Cognethos Pty Ltd 2010. All rights reserved.
//

#import "LocationTestAppDelegate.h"
#import "LocationTestViewController.h"
#import "LogViewController.h"
#import "LocationDelegate.h"

@implementation LocationTestAppDelegate

@synthesize window, viewController, m_locManager, m_locationDelegate;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    id locationValue = [launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey];
	if (locationValue) {
		[LogViewController log:@"didFinishLaunchingWithOptions UIApplicationLaunchOptionsLocationKey"];
        m_locManager = [[CLLocationManager alloc] init];
        m_locationDelegate = [[LocationDelegate alloc] initWithName:@"SCLS RELAUNCH"];
        m_locManager.delegate = m_locationDelegate;
        [m_locManager startMonitoringSignificantLocationChanges];
	} else {
        [LogViewController log:@"didFinishLaunching"];
        self.window.rootViewController = self.viewController;
        [self.window makeKeyAndVisible];
    }
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[LogViewController log:@"applicationWillResignActive"];
	NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:viewController.m_significantSwitch.on forKey:@"significant"];
	[userDefaults setObject:viewController.m_distanceFilterTextField.text forKey:@"distanceFilter"];
	[userDefaults synchronize];
}                

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[LogViewController log:@"applicationDidEnterBackground"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	[LogViewController log:@"applicationWillEnterForeground"];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[LogViewController log:@"applicationDidBecomeActive"];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    viewController.m_significantSwitch.on = [userDefaults boolForKey:@"significant"];
    NSString* distanceFilter = [userDefaults objectForKey:@"distanceFilter"];
    if (distanceFilter) {
        viewController.m_distanceFilterTextField.text = distanceFilter;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[LogViewController log:@"applicationWillTerminate"];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}

@end
