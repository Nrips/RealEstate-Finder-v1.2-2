//
//  ViewDirectionMap.m
//  RealEstateFinder
//
//  Created by utk@rsh on 24/10/14.
//  Copyright (c) 2014 Client. All rights reserved.
//

#import "ViewDirectionMap.h"

@interface ViewDirectionMap ()
{
    __weak IBOutlet UILabel *lblDistance;
    __weak IBOutlet MKMapView *MKDirectionMapView;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    MKAnnotationView *_selectedAnnotation;
    
    CLLocationCoordinate2D cords;
    CLLocationCoordinate2D CLSourceLocationCoordinates;
    CLLocationCoordinate2D CLDestinationLocationCoordinates;
    MKRoute *routeDetails;
}

@property (strong, nonatomic) NSString *allSteps;

@end

@implementation ViewDirectionMap

@synthesize placemark = _placemark;


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    locationManager = [[CLLocationManager alloc]init];
    geocoder = [[CLGeocoder alloc] init];
    
    //*>    getting map annotation details through App Delegate.
    AppDelegate *appDelegate = app_Delegate;
    //(AppDelegate *) [UIApplication sharedApplication].delegate;
    
    self.pinTitle = appDelegate.strTitle;
    self.coordinate = appDelegate.coordinate;
    self.placemark = appDelegate.placemark;
    self.mapItem = appDelegate.mapItem;

    //*>    setting navigation bar appearance.
    self.navigationItem.titleView = [MGUIAppearance createLogo:HEADER_LOGO];
    self.view.backgroundColor = BG_VIEW_COLOR;
    
    [MGUIAppearance enhanceNavBarController:self.navigationController
                               barTintColor:WHITE_TEXT_COLOR
                                  tintColor:WHITE_TEXT_COLOR
                             titleTextColor:WHITE_TEXT_COLOR];
    
    
    MKDirectionMapView.delegate = self;
    
    [self findMyLocation];
    [self getCurrentLocation];
    [self addMapAnnotation];
}

- (void)viewWillAppear:(BOOL)animated
{
    lblDistance.textColor = THEME_GREEN_TINT_COLOR;
    lblDistance.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //*>    Dispose of any resources that can be recreated.
}


#pragma mark - Custom Methods

- (void)findMyLocation
{
    MKDirectionMapView.delegate = self;
    MKDirectionMapView.showsUserLocation = YES;
    [MKDirectionMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (void)getCurrentLocation
{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}


- (void)addMapAnnotation
{
    MGMapAnnotation *annotation = [[MGMapAnnotation alloc]initWithCoordinate:self.coordinate name:self.pinTitle description:nil];
    [MKDirectionMapView addAnnotation:annotation];
    
    if(annotation == nil)
    {
        UIColor* color = [THEME_GREEN_TINT_COLOR colorWithAlphaComponent:0.70];
        [MGUtilities showStatusNotifier:LOCALIZED(@"NO_RESULTS")
                              textColor:[UIColor whiteColor]
                         viewController:self
                               duration:0.5f
                                bgColor:color
                                    atY:self.view.frame.size.height - 40];
    }
    
    [self parseRoute];
}


- (void)parseRoute
{
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    
    CLSourceLocationCoordinates = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:CLSourceLocationCoordinates addressDictionary:nil];
    
    CLDestinationLocationCoordinates = self.coordinate;
    MKPlacemark *destPlacemark = [[MKPlacemark alloc] initWithCoordinate:CLDestinationLocationCoordinates addressDictionary:nil];
    
    [directionsRequest setSource:[[MKMapItem alloc] initWithPlacemark:sourcePlacemark]];
    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:destPlacemark]];
    directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
    directionsRequest.requestsAlternateRoutes = YES;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
    {
        if (error)
        {
            NSLog(@"Error %@", error.description);
        }
        else
        {
            routeDetails = response.routes.lastObject;
            [MKDirectionMapView addOverlay:routeDetails.polyline];
            for (int i = 0; i < routeDetails.steps.count; i++)
            {
                MKRouteStep *step = [routeDetails.steps objectAtIndex:i];
                NSString *newStep = step.instructions;
                self.allSteps = [self.allSteps stringByAppendingString:newStep];
                self.allSteps = [self.allSteps stringByAppendingString:@"\n\n"];
                
                NSLog(@"Steps:%@", self.allSteps);
            }}
    }];
}

#pragma mark - MKMapView Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentLocation = newLocation;
    
    if (currentLocation != nil)
    {
        
    }
    //*>    Stop Location Manager
    [locationManager stopUpdatingLocation];
    
    //*>    Reverse Geocoding
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if (error == nil && [placemarks count] > 0)
        {
            placemark = [placemarks lastObject];
            
            NSLog(@"Address:%@ %@\n%@ %@\n%@\n%@",placemark.subThoroughfare, placemark.thoroughfare,
                  placemark.postalCode, placemark.locality,
                  placemark.administrativeArea,
                  placemark.country);
        }
        else
        {
            NSLog(@"%@", error.debugDescription);
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if([CLLocationManager locationServicesEnabled])
    {
        NSLog(@"Location Services Enabled....");
    }
    else
    {
        [MGUtilities showAlertTitle:LOCALIZED(@"LOCATION_SERVICE_ERROR")
                            message:LOCALIZED(@"LOCATION_SERVICE_NOT_ENABLED")];
}}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    _selectedAnnotation = view;
    
    if(currentLocation != nil)
        
    [self updateDistanceToAnnotation:_selectedAnnotation];
}

-(void)updateDistanceToAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == nil)
    {
        lblDistance.text = @"No annotation selected";
        return;
    }
    
    if (MKDirectionMapView.userLocation.location == nil)
    {
        lblDistance.text = @"User location is unknown";
        return;
    }
    
    CLLocation *pinLocation = [[CLLocation alloc]
                               initWithLatitude:annotation.coordinate.latitude
                               longitude:annotation.coordinate.longitude];
    
    CLLocation *userLocation = [[CLLocation alloc]
                                initWithLatitude:MKDirectionMapView.userLocation.coordinate.latitude
                                longitude:MKDirectionMapView.userLocation.coordinate.longitude];
    
    CLLocationDistance distance = [pinLocation distanceFromLocation:userLocation]/1000;
    
    [lblDistance setText: [NSString stringWithFormat:@"%.02f KM.", distance]];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if([annotation isKindOfClass:[MGMapAnnotation class]])
    {
        static NSString *identifier = @"MapAnnotation";
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView*) [MKDirectionMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if(annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        else
        {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = NO;
        annotationView.pinColor = MKPinAnnotationColorGreen;
        annotationView.animatesDrop = YES;

        MGRawView *mapPinView = [[MGRawView alloc] initWithNibName:@"MapPinView"];
        NSString *strPropertyPrice = [NSString stringWithFormat:@"$%@",self.pinTitle];
        [mapPinView.labelTitle setText:strPropertyPrice];
        
        UIGraphicsBeginImageContextWithOptions(mapPinView.bounds.size, NO, 0.0);
        [mapPinView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *bmImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        annotationView.image = bmImage;
        
        return annotationView;
    }
    return nil;
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:routeDetails.polyline];
    routeLineRenderer.strokeColor = THEME_GREEN_TINT_COLOR;
    routeLineRenderer.lineWidth = 3.0f;
    return routeLineRenderer;
}

@end
