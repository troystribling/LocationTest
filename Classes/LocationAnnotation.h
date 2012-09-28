//
//  LocaionAnnotation.h
//  LocationTest
//
//  Created by Troy Stribling on 9/27/12.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationAnnotation : NSObject <MKAnnotation>

@property (nonatomic, unsafe_unretained, readonly) CLLocationCoordinate2D   coordinate;
@property (nonatomic, unsafe_unretained) MKPinAnnotationColor               pinColor;
@property (nonatomic, copy, readonly) NSString                              *title;
@property (nonatomic, copy, readonly) NSString                              *subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString*)paramTitle subTitle:(NSString*)paramSubTitle;
+ (NSString *) reusableIdentifierforPinColor:(MKPinAnnotationColor)paramColor;

@end
