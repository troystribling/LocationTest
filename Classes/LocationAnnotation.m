//
//  LocaionAnnotation.m
//  LocationTest
//
//  Created by Troy Stribling on 9/27/12.
//
//

#import "LocationAnnotation.h"

@implementation LocationAnnotation

@synthesize coordinate, title, subtitle;

- (id) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates subTitle:(NSString*)paramSubTitle {
    self = [super init];
    if (self) {
        coordinate = paramCoordinates;
        title = [NSString stringWithFormat:@"%f, %f", paramCoordinates.latitude, paramCoordinates.longitude];
        subtitle = paramSubTitle;
    }
    return self;
}

@end
