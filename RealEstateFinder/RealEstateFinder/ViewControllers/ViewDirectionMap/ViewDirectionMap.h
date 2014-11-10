//
//  ViewDirectionMap.h
//  RealEstateFinder
//
//  Created by utk@rsh on 24/10/14.
//  Copyright (c) 2014 Client. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewDirectionMap : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *pinTitle;
@property (nonatomic, strong) MKPlacemark *placemark;
@property (nonatomic, strong) MKMapItem *mapItem;

@end
