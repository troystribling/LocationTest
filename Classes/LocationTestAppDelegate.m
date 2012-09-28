//
//  LocationTestAppDelegate.m
//  LocationTest
//
//  Created by Tom Horn on 11/08/10.
//  Copyright Cognethos Pty Ltd 2010. All rights reserved.
//

#import "LocationTestAppDelegate.h"
#import "LocationTestViewController.h"

@implementation LocationTestAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize m_logArray;

#pragma mark -
#pragma mark Application lifecycle

- (NSString*)locationPath {
	NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	return [path stringByAppendingPathComponent:@"locationPath.txt"];
}

- (id)init {
	return [super init];
}

- (void) clearLog {
	NSString * content = @"";
	NSString * fileName = [self locationPath];
	[content writeToFile:fileName 
			atomically:NO 
			encoding:NSStringEncodingConversionAllowLossy 
			error:nil];
}

- (NSArray*) getLogArray {
	NSString * fileName = [self locationPath];
	NSString *content = [NSString stringWithContentsOfFile:fileName usedEncoding:nil error:nil];
	NSMutableArray * array = (NSMutableArray *)[content componentsSeparatedByString:@"\n"];
	NSMutableArray * newArray = [[NSMutableArray alloc] init];
	for (int i = 0; i < [array count]; i++) {
		NSString * item = [array objectAtIndex:i];
		if ([item length])
			[newArray addObject:item];
	}
	return (NSArray*)newArray;
}

- (void) log:(NSString*)msg {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeStyle:NSDateFormatterMediumStyle];
	NSString *logMessage = [NSString stringWithFormat:@"(%@) %@", [formatter stringFromDate:[NSDate date]], msg];
    NSLog(@"%@", logMessage);
	NSString *fileName = [self locationPath];
	FILE * f = fopen([fileName UTF8String], "at");
	fprintf(f, "%s\n", [logMessage UTF8String]);
	fclose (f);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    id locationValue = [launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey];
	if (locationValue) {
		[self log:@"didFinishLaunchingWithOptions UIApplicationLaunchOptionsLocationKey"];
        [viewController actionSignificant:nil];
	} else {
        [self log:@"didFinishLaunching"];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[self log:@"applicationWillResignActive"];
	NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:viewController.m_significantSwitch.on forKey:@"significant"];
	[userDefaults synchronize];
}                


- (void)applicationDidEnterBackground:(UIApplication *)application {
	[self log:@"applicationDidEnterBackground"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	[self log:@"applicationWillEnterForeground"];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	[self log:@"applicationDidBecomeActive"];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    viewController.m_significantSwitch.on = [userDefaults boolForKey:@"significant"];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[self log:@"applicationWillTerminate"];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}

@end
