//
//  ViewController.m
//  MapsTest
//
//  Created by Stepan Paholyk on 12/30/16.
//  Copyright © 2016 Stepan Paholyk. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UIView+MKAnnotationView.h"

@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];

    _mapView.showsUserLocation = YES;
    
    SEL add = @selector(addAction:);
    SEL search = @selector(searchAction:);
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:add];
    /*
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                target:nil
                                                                                action:nil];
    */
    
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                target:self
                                                                                action:search];

    self.navigationItem.rightBarButtonItems = @[addButton, searchButton];
}

#pragma mark - CLLocationManagerDelegate

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.location = locations.lastObject;
}

#pragma mark - Actions

- (void) addAction:(UIBarButtonItem *)sender {
    
    MapAnnotation *annotation = [[MapAnnotation alloc] init];
    
    annotation.title = @"Some title";
    annotation.subtitle = @"Bugaga!";
    
    annotation.coordinate = _mapView.region.center;
    
    [self.mapView addAnnotation:annotation];
    
}

- (void) searchAction:(UIBarButtonItem*)sender {
    
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        
        CLLocationCoordinate2D location = annotation.coordinate;
        MKMapPoint center = MKMapPointForCoordinate(location);
        static double delta = 200;
        
        MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, delta*2, delta*2);
        zoomRect = MKMapRectUnion(zoomRect, rect);
    }
    
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    [_mapView setVisibleMapRect:zoomRect
                    edgePadding:UIEdgeInsetsMake(100, 100, 100, 100)
                       animated:YES];
}

#pragma mark - MKMapViewDelegate

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *idf = @"Annotation";
    
    MKPinAnnotationView *pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:idf];
    
    if (!pin) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:idf];
        pin.pinTintColor = [UIColor purpleColor];
        pin.animatesDrop = YES;
        
        pin.canShowCallout = YES;
        pin.draggable = YES;
        
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [infoButton addTarget:self action:@selector(infoAction:) forControlEvents:UIControlEventTouchUpInside];
        pin.rightCalloutAccessoryView = infoButton;
        
    } else {
        pin.annotation = annotation;
    }
    
    return pin;
}

#pragma mark - MKMapView

- (void)mapView:(MKMapView*)mapView annotationView:(nonnull MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    if (newState == MKAnnotationViewDragStateEnding) {
        CLLocationCoordinate2D location = view.annotation.coordinate;
        MKMapPoint point = MKMapPointForCoordinate(location);
        NSLog(@"Location: (%f. %f)\nPoint: (%@)", location.latitude, location.longitude, MKStringFromMapPoint(point));
    }
}

/*
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    NSLog(@"regionWillChangeAnimated");
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"regionDidChangeAnimated");
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
    NSLog(@"mapViewWillStartLoadingMap");
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    NSLog(@"mapViewDidFinishLoadingMap");
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    NSLog(@"mapViewDidFailLoadingMap");
}

- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView {
    NSLog(@"mapViewWillStartRenderingMap");
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    NSLog(@"mapViewDidFinishRenderingMap");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/

@end
