//
//  UIView+MKAnnotationView.m
//  MapsTest
//
//  Created by Stepan Paholyk on 1/2/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import "UIView+MKAnnotationView.h"

@implementation UIView (MKAnnotationView)

- (MKAnnotationView *) superAnnotationView {
    
    if ([self isKindOfClass:[MKAnnotationView class]]) {
        return (MKAnnotationView*)self;
    }
    if (!self.superview) {
        return nil;
    }
    
    return [self.superview superAnnotationView];
}

@end
