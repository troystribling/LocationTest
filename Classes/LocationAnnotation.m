//
//  LocaionAnnotation.m
//  LocationTest
//
//  Created by Troy Stribling on 9/27/12.
//
//

#import "LocationAnnotation.h"

#define REUSABLE_PIN_RED        @" Red"
#define REUSABLE_PIN_GREEN      @" Green"
#define REUSABLE_PIN_PURPLE     @" Purple"


@implementation LocationAnnotation

@synthesize coordinate, title, subtitle, pinColor;

- (id) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle subTitle:(NSString *)paramSubTitle {
    self = [super init];
    if (self) {
        coordinate = paramCoordinates;
        title = paramTitle;
        subtitle = paramSubTitle;
        pinColor = MKPinAnnotationColorGreen;
    }
    return self;
}

+ (NSString *)reusableIdentifierforPinColor:(MKPinAnnotationColor)paramColor {
    NSString *result = nil;
    switch (paramColor) {
        case MKPinAnnotationColorRed: {
            result = REUSABLE_PIN_RED;
            break;
        }
        case MKPinAnnotationColorGreen: {
            result = REUSABLE_PIN_GREEN;
            break;
        } case MKPinAnnotationColorPurple: {
            result = REUSABLE_PIN_PURPLE;
            break;
        }
    }
    return result;
}

@end
