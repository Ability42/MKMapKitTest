//
//  MapAnnotation.h
//  MapsTest
//
//  Created by Stepan Paholyk on 12/31/16.
//  Copyright © 2016 Stepan Paholyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

@end
