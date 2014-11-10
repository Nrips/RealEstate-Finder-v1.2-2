//
//  ContentViewController.m
//  RealEstateFinder
//
//  
//  Copyright (c) 2014 MangasaurGames. All rights reserved.
//

#import "ContentViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "Detail2ViewController.h"
#import "SearchViewController.h"

@interface ContentViewController () <SearchResultDelegate>
{
    BOOL isUserLoggedIn;
}

@end

@implementation ContentViewController

@synthesize mapViewMain;
@synthesize buttonDraw;
@synthesize labelDistance;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [MGUIAppearance createLogo:HEADER_LOGO];
    self.view.backgroundColor = BG_VIEW_COLOR;
    
    [MGUIAppearance enhanceNavBarController:self.navigationController
                               barTintColor:WHITE_TEXT_COLOR
                                  tintColor:WHITE_TEXT_COLOR
                             titleTextColor:WHITE_TEXT_COLOR];
    
    mapViewMain.delegate = self;
    [mapViewMain baseInit];
    
    _realEstateInsideBoundsArray = [[NSMutableArray alloc] init];
    
    labelDistance.textColor = THEME_GREEN_TINT_COLOR;
    labelDistance.text = @"";
    
    if(SHOW_ADS_MAIN_VIEW) {
        [MGUtilities createAdAtY:64
                  viewController:self
                         bgColor:AD_BG_COLOR];
    }
    [self beginParsing];
}

-(void)viewWillAppear:(BOOL)animated
{
    labelDistance.text = @"";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIBarButtonItem* barButtonLeft;
    barButtonLeft = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:SIDE_VIEW_BAR_BUTTON]
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(didClickBarButtonnLeft:)];
    
    self.navigationItem.leftBarButtonItem = barButtonLeft;
    
    [self.view setUserInteractionEnabled:YES];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.navigationItem.leftBarButtonItem = nil;
}

-(void)didClickBarButtonnLeft:(id)sender {
    
    [AppDelegate unfoldLeftView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginParsing {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = LOCALIZED(@"LOADING");
    
    [self.view addSubview:hud];
    [self.view setUserInteractionEnabled:NO];
	[hud showAnimated:YES whileExecutingBlock:^{
        
		[self performParsing];
        
	} completionBlock:^{
        
		[hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        [self findMyCurrentLocation];
        [mapViewMain zoomAndFitAnnotations];
	}];
    
}

-(void) performParsing
{
    [DataParser fetchServerData];
    
    if(_realEstateArray == nil)
        _realEstateArray = [NSMutableArray new];
    
    [_realEstateArray removeAllObjects];
    
    _realEstateArray = [NSMutableArray arrayWithArray:[CoreDataController getRealEstates]];
    
    [self addMapAnnotations];
}

-(void)addMapAnnotations
{
    NSMutableArray* annotations = [NSMutableArray new];
    for(RealEstate* estate in _realEstateArray) {
        
        CLLocationCoordinate2D coords;
        coords = CLLocationCoordinate2DMake([estate.lat doubleValue], [estate.lon doubleValue]);
        MGMapAnnotation* ann = [[MGMapAnnotation alloc] initWithCoordinate:coords name:estate.price description:estate.property_type];
        ann.object = estate;
        [annotations addObject:ann];
    }
    [mapViewMain setMapData:annotations];
    
    if(annotations == nil || annotations.count == 0) {
        
        UIColor* color = [THEME_GREEN_TINT_COLOR colorWithAlphaComponent:0.70];
        [MGUtilities showStatusNotifier:LOCALIZED(@"NO_RESULTS")
                              textColor:[UIColor whiteColor]
                         viewController:self
                               duration:0.5f
                                bgColor:color
                                    atY:self.view.frame.size.height - 40];
        
        [self findMyCurrentLocation];
    }
}


-(void) MGMapView:(MGMapView*)mapView didSelectMapAnnotation:(MGMapAnnotation*)mapAnnotation {
    
    if([mapAnnotation isKindOfClass:[MGMapAnnotation class]])
    {
        [self showInfoView:mapAnnotation.object];
    }
    _selectedAnnotation = mapAnnotation;
    
    if(_myLocation != nil)
        [self getDistance];
}

-(void) MGMapView:(MGMapView*)mapView didAccessoryTapped:(MGMapAnnotation*)mapAnnotation {
    
}

-(void) MGMapView:(MGMapView*)mapView didCreateMKPinAnnotationView:(MKPinAnnotationView*)mKPinAnnotationView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    mKPinAnnotationView.canShowCallout = NO;
    mKPinAnnotationView.animatesDrop = NO;
    
    mKPinAnnotationView.pinColor = MKPinAnnotationColorGreen;
    
    MGMapAnnotation* ann = (MGMapAnnotation*)annotation;
    RealEstate* estate = ann.object;
    
    MGRawView* mapPinView = [[MGRawView alloc] initWithNibName:@"MapPinView"];
    NSString *strPropertyPrice = [NSString stringWithFormat:@"$%@",estate.price];
    [mapPinView.labelTitle setText:strPropertyPrice];
    
    UIGraphicsBeginImageContextWithOptions(mapPinView.bounds.size, NO, 0.0);
    [mapPinView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *bmImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    mKPinAnnotationView.image = bmImage;
}

-(MKOverlayView*)MGMapView:(MGMapView *)mapView viewForOverlay:(id)overlay {
    
    if ([overlay isKindOfClass:MKPolyline.class]) {
        
        MKPolylineRenderer * lineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        lineView.lineWidth = 3.5f;
        lineView.strokeColor = THEME_GREEN_TINT_COLOR;
        
        return (MKOverlayView*)lineView;
    }
    
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        
        MKPolygonRenderer * aView = [[MKPolygonRenderer alloc] initWithPolygon:(MKPolygon*)overlay];
        aView.strokeColor = [THEME_GREEN_TINT_COLOR colorWithAlphaComponent:0.7];
        aView.lineWidth = 8;
        
        return (MKOverlayView*)aView;
    }
    
    return nil;
}

-(MKOverlayRenderer*)MGMapView:(MGMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:MKPolyline.class]) {
        
        MKPolylineRenderer* polylineRender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        polylineRender.lineWidth = 3.0f;
        polylineRender.strokeColor = THEME_GREEN_TINT_COLOR;
        
        return polylineRender;
    }
    
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        
        MKPolygonRenderer * polygonRender = [[MKPolygonRenderer alloc] initWithPolygon:(MKPolygon*)overlay];
        polygonRender.fillColor   = [THEME_GREEN_TINT_COLOR colorWithAlphaComponent:0.3];
        polygonRender.strokeColor = [THEME_GREEN_TINT_COLOR colorWithAlphaComponent:01.0];
        polygonRender.lineWidth = 3;
        
        return polygonRender;
    }

    return nil;
}

-(void) MGMapView:(MGMapView*)mapView geoCodePlaceMark:(CLPlacemark *)placemarks addressDictionary:(NSDictionary*)dic {
    
}

-(void)MGMapView:(MGMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
}

- (void)handleGesture:(UIPanGestureRecognizer*)gesture
{
    CGPoint location = [gesture locationInView:_drawView];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        if (_shapeLayer == nil) {
            _shapeLayer = [[CAShapeLayer alloc] init];
            _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
            _shapeLayer.strokeColor = [THEME_GREEN_TINT_COLOR CGColor];
            _shapeLayer.lineWidth = 5.0;
            [_drawView.layer addSublayer:_shapeLayer];
        }
        else {
            _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
            _shapeLayer.strokeColor = [THEME_GREEN_TINT_COLOR CGColor];
            _shapeLayer.lineWidth = 5.0;
            [_drawView.layer addSublayer:_shapeLayer];
        }
        
        _path = [[UIBezierPath alloc] init];
        [_path moveToPoint:location];
        
        CLLocationCoordinate2D coords;
        coords = [[self.mapViewMain mapView] convertPoint:location toCoordinateFromView:_drawView];
        NSString * LatLong = [NSString stringWithFormat:@"{%f,%f}", coords.latitude, coords.longitude];
        [_points addObject:LatLong];
        
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        [_path addLineToPoint:location];
        _shapeLayer.path = [_path CGPath];
        
        CLLocationCoordinate2D coords;
        coords = [[self.mapViewMain mapView] convertPoint:location toCoordinateFromView:_drawView];
        NSString * LatLong = [NSString stringWithFormat:@"{%f,%f}", coords.latitude, coords.longitude];
        [_points addObject:LatLong];
        
    }
    else if(gesture.state == UIGestureRecognizerStateEnded) {
        
        [_path addLineToPoint:location];
        [_path closePath];
        
        
        [_realEstateInsideBoundsArray removeAllObjects];
        for(int i = 0; i < [_realEstateArray count]; i++) {
            
            RealEstate* realEstate = [_realEstateArray objectAtIndex:i];
            _coordinateRegion.center.latitude  = [realEstate.lat floatValue];
            _coordinateRegion.center.longitude = [realEstate.lon floatValue];
            
            CGPoint loc = [[self.mapViewMain mapView] convertCoordinate:_coordinateRegion.center toPointToView:_drawView];
            
            if ([_path containsPoint:loc])
                [_realEstateInsideBoundsArray addObject:realEstate];
        }
        

        CLLocationCoordinate2D pointsToUse[_points.count];
        
        for(int i = 0; i < _points.count; i++) {
            CGPoint p = CGPointFromString(_points[i]);
            pointsToUse[i] = CLLocationCoordinate2DMake(p.x,p.y);
        }
        
        _shapeLayer.path = nil;
        [_drawView removeFromSuperview];
        
        MKPolygon * poly = [MKPolygon polygonWithCoordinates:pointsToUse count:_points.count];
        [[mapViewMain mapView] addOverlay:poly];

        
        [self removeMapAnnotations];
        [self removeMapPolylines];
        
        if(_realEstateInsideBoundsArray.count == 0) {
            
//            [self removeMapPolygons];
            [_drawView removeFromSuperview];
        }
        else {
            for(int i = 0; i <[_realEstateInsideBoundsArray count]; i++) {
                
                RealEstate* realEstate = [_realEstateInsideBoundsArray objectAtIndex:i];
                CLLocationCoordinate2D coord;
                coord = CLLocationCoordinate2DMake([realEstate.lat floatValue], [realEstate.lon floatValue]);
                
                MGMapAnnotation* ann = [[MGMapAnnotation alloc] initWithCoordinate:coord
                                                                              name:realEstate.price
                                                                       description:realEstate.address];
                
                ann.object = realEstate;
                [[mapViewMain mapView] addAnnotation:ann];
            }
            
            [_drawView removeFromSuperview];
        }
        
    }
}

-(void) removeMapPolygons {
    
    for (id<MKOverlay> overlayToRemove in [mapViewMain mapView].overlays) {
        
        if ([overlayToRemove isKindOfClass:[MKPolygon class]])
            [[mapViewMain mapView] removeOverlay:overlayToRemove];
    }
}

-(void) removeMapPolylines {
    
    for (id<MKOverlay> overlayToRemove in [mapViewMain mapView].overlays) {
        
        if ([overlayToRemove isKindOfClass:[MKPolyline class]])
            [[mapViewMain mapView] removeOverlay:overlayToRemove];
        
    }
}

-(void)removeMapAnnotations {
    
    for (id<MKAnnotation> ann in [mapViewMain mapView].annotations) {
        
        if (![ann isKindOfClass:[MKUserLocation class]])
            [[mapViewMain mapView] removeAnnotation:ann];
    }
}

- (IBAction)didClickButtonDraw:(id)sender {
    
    
    [self removeMapPolygons];
    [self removeMapPolylines];
    _realEstateArray = [NSMutableArray arrayWithArray:[CoreDataController getRealEstates]];
    [self addMapAnnotations];
    
    if(_points == nil)
        _points = [[NSMutableArray alloc] init];
    
    [_points removeAllObjects];
    
    if(_panRecognizer == nil) {
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [_panRecognizer setMinimumNumberOfTouches:1];
        [_panRecognizer setMaximumNumberOfTouches:1];
    }
    
    if(_drawView == nil) {
        CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
        _drawView = [[UIView alloc] initWithFrame:applicationFrame];
        _drawView.backgroundColor = [UIColor clearColor];
        [_drawView addGestureRecognizer:_panRecognizer];
        _drawView.hidden = NO;
    }
    
    [self.view addSubview:_drawView];

}

-(IBAction)didClickButtonRefresh:(id)sender {
    
    [self removeMapPolygons];
    [self removeMapPolylines];
    [self removeMapAnnotations];
    
    _realEstateArray = [NSMutableArray arrayWithArray:[CoreDataController getRealEstates]];
    
    [self addMapAnnotations];
    [mapViewMain zoomAndFitAnnotations];
}


#pragma mark - FIND USER LOCATION

-(void)findMyCurrentLocation {
    
    _myLocationManager = [[CLLocationManager alloc] init];
    _myLocationManager.delegate = self;
    
    
    if(IS_OS_8_OR_LATER) {
        [_myLocationManager requestWhenInUseAuthorization];
        [_myLocationManager requestAlwaysAuthorization];
    }
    
    [_myLocationManager startUpdatingLocation];
    [[mapViewMain mapView] setShowsUserLocation:YES];
    _isAllowDetectLocation = YES;
    
    if([CLLocationManager locationServicesEnabled] ) {
        NSLog(@"Location Services Enabled....");
    }
    else {
        [MGUtilities showAlertTitle:LOCALIZED(@"LOCATION_SERVICE_ERROR")
                            message:LOCALIZED(@"LOCATION_SERVICE_NOT_ENABLED")];
    }

}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    _myLocation = newLocation;
    
    if(_isAllowDetectLocation) {
        
        _isAllowDetectLocation = NO;
        [[mapViewMain mapView] setCenterCoordinate:newLocation.coordinate animated:YES];
        
        MKCoordinateRegion viewRegion =
        MKCoordinateRegionMakeWithDistance(newLocation.coordinate,
                                           0.3 * METES_PER_MILE,
                                           0.3 * METES_PER_MILE);
        
        MKCoordinateRegion adjustedRegion = [[mapViewMain mapView] regionThatFits:viewRegion];
        
        [[mapViewMain mapView] setRegion:adjustedRegion animated:YES];
    }
    
}


- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error {
    
}

-(void) showInfoView:(RealEstate*)realEstate {
    
    if(_infoSlidingView == nil) {
        
        _infoSlidingView = [[MGRawView alloc] initWithNibName:@"MapPopupView"];
        CGRect frame = _infoSlidingView.frame;
        frame.origin.y = [MGUtilities getViewHeight];
        _infoSlidingView.frame = frame;
        
        [self.view addSubview:_infoSlidingView];
        
        [_infoSlidingView.buttonNext addTarget:self
                                        action:@selector(didClickButtonNext:)
                              forControlEvents:UIControlEventTouchUpInside];
        
        [_infoSlidingView.buttonStarred addTarget:self
                                        action:@selector(didClickButtonStarred:)
                              forControlEvents:UIControlEventTouchUpInside];
    }
    UserSession* user = [UserAccessSession getUserSession];
    AgentSession* agent = [UserAccessSession getAgentSession];
    
    if (user != nil && agent != nil) {
        
        isUserLoggedIn = YES;
        _infoSlidingView.buttonStarred.hidden = false;
    }
    else
    {
        isUserLoggedIn = NO;
        _infoSlidingView.buttonStarred.hidden = true;
    }
    
    Photo* p = [CoreDataController getPhotoByRealEstateId:[realEstate.realestate_id intValue]];
    
    [_infoSlidingView.buttonStarred setTag:[realEstate.realestate_id intValue]];
    
    [self updateStarred:[realEstate.realestate_id intValue]];
    
        
    if(p != nil)
        [self setImage:p.photo_url imageView:_infoSlidingView.imgViewPhoto];
    else
        [self setImage:nil imageView:_infoSlidingView.imgViewPhoto];
    
    [_infoSlidingView.labelTitle setText:realEstate.price];
    [_infoSlidingView.labelSubtitle setText:realEstate.address];
    
    
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         CGRect frameUp = _infoSlidingView.frame;
                         frameUp.origin.y = [MGUtilities getViewHeight] - frameUp.size.height;
                         _infoSlidingView.frame = frameUp;
                     }
                     completion:^(BOOL finished){
                         [mapViewMain.mapView deselectAnnotation:_selectedAnnotation animated:YES];
                     }];
    
}

-(void)didClickButtonStarred:(id)sender {
    
    int realEstateId = (int)((UIButton*)sender).tag;
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    Favorite* fave = [CoreDataController getFavoriteByRealEstateId:realEstateId];
    
    if(fave == nil) {
        [CoreDataController insertFavorite:realEstateId];
    }
    else {
        
        [context deleteObject:fave];
        
        NSError *error;
        if ([context hasChanges] && ![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }

    
    [self updateStarred:realEstateId];
}

-(void)didClickButtonNext:(id)sender {
    
    [self performSegueWithIdentifier:@"segueDetails" sender:_selectedAnnotation];
}

-(void)updateStarred:(int)realEstateId {
    
    Favorite* fave = [CoreDataController getFavoriteByRealEstateId:realEstateId];
    
    
    [_infoSlidingView.buttonStarred setBackgroundImage:[UIImage imageNamed:MAP_STARRED_NORMAL]
                                              forState:UIControlStateNormal];
    
    [_infoSlidingView.buttonStarred setBackgroundImage:[UIImage imageNamed:MAP_STARRED_NORMAL]
                                              forState:UIControlStateNormal];
    
    if(fave != nil) {
        [_infoSlidingView.buttonStarred setBackgroundImage:[UIImage imageNamed:MAP_STARRED_SELECTED]
                                                  forState:UIControlStateNormal];
        
        [_infoSlidingView.buttonStarred setBackgroundImage:[UIImage imageNamed:MAP_STARRED_SELECTED]
                                                  forState:UIControlStateNormal];
    }
}

-(void) hideInfoView {
    
    CGRect frameUp = _infoSlidingView.frame;
    if(frameUp.origin.y == [MGUtilities getViewHeight])
        return;
    
    [UIView animateWithDuration:0.2
                          delay:0.7
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGRect frameUp = _infoSlidingView.frame;
                         frameUp.origin.y = [MGUtilities getViewHeight];
                         _infoSlidingView.frame = frameUp;
                     }
                     completion:^(BOOL finished){

                     }];
}

-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:MAP_INFO_PLACEHOLDER_IMAGE];
    
    
    [imgView setImageWithURLRequest:urlRequest
                   placeholderImage:imgPlaceholder
                            success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
                                
                                CGSize size = weakImgRef.frame.size;
                                
                                if([MGUtilities isRetinaDisplay]) {
                                    size.height *= 2;
                                    size.width *= 2;
                                }
                                
                                if(IS_OS_8_OR_LATER) {
                                    size.height *= 3;
                                    size.width *= 3;
                                }
                                
                                UIImage* croppedImage = [image imageByScalingAndCroppingForSize:size];
                                weakImgRef.image = croppedImage;
                                
                            } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                            
                            }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    [self hideInfoView];
    
//    UITouch *touch = [touches anyObject];
//    NSLog(@"%@",[[touch view]description]);
}

-(IBAction)didClickButtonRoute:(id)sender {
    
    if(![MGUtilities hasInternetConnection]) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"NETWORK_ERROR_DETAILS")];
        
        return;
    }
    
    if(_myLocation == nil) {
        [MGUtilities showAlertTitle:LOCALIZED(@"USER_LOCATION_ERROR")
                            message:LOCALIZED(@"USER_LOCATION_ERROR_DETAILS")];
        
        return;
    }
    
    if(_selectedAnnotation == nil) {
        [MGUtilities showAlertTitle:LOCALIZED(@"MAP_PIN_ERROR")
                            message:LOCALIZED(@"MAP_PIN_ERROR_DETAILS")];
        
        return;
    }
    
    for (id<MKOverlay> overlay in [mapViewMain.mapView overlays]) {
        if ([overlay isKindOfClass:[MKPolyline class]]) {
            [mapViewMain.mapView removeOverlay:overlay];
        }
    }
    
    [self beginParsingRoute];
}

-(IBAction)didClickButtonFindLocation:(id)sender {
    
    _isAllowDetectLocation = YES;
    [self findMyCurrentLocation];
}

-(void)beginParsingRoute {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = LOCALIZED(@"CREATING_ROUTES");
    
    [self.view addSubview:hud];
	
    NSMutableArray* routeArray = [NSMutableArray new];
    __strong typeof(NSMutableArray*) strongRouteArray = routeArray;
    
    [self.view setUserInteractionEnabled:NO];
	[hud showAnimated:YES whileExecutingBlock:^{
        
		[self performParseRoute:strongRouteArray];
        
	} completionBlock:^{
        
		[hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        [self displayOverlay:strongRouteArray];
        
	}];
    
}

-(void)performParseRoute:(NSMutableArray*)routeArray {
    
    NSArray* array = [MGMapRoute getRouteFrom:_myLocation.coordinate to:_selectedAnnotation.coordinate];
    
    for(id entry in array) {
        [routeArray addObject:entry];
    }
}

-(void)displayOverlay:(NSMutableArray*)routeArray {
    
    NSInteger routeCount = routeArray.count;
    CLLocationCoordinate2D coordsArray[routeCount];
    
    if(routeCount > 0) {
        for(int i = 0; i < routeCount; i++) {
            
            CLLocation* location = [routeArray objectAtIndex:i];
            coordsArray[i] = location.coordinate;
        }
        
        MKPolyline* routePolyLine = [MKPolyline polylineWithCoordinates:coordsArray count:routeCount];
        [mapViewMain.mapView addOverlay:routePolyLine];
    }
}

-(void)getDistance {
    
    CLLocationCoordinate2D coord = _selectedAnnotation.coordinate;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude
                                                      longitude:coord.longitude];
    
    double distance = [_myLocation distanceFromLocation:location] / 1000;
    labelDistance.text = [NSString stringWithFormat:@"%.02f %@", distance, LOCALIZED(@"MAP_DISTANCE_UNIT")];
}


#pragma mark ########################################################################
#pragma mark - Navigation Segue
#pragma mark ########################################################################

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"segueDetails"]) {
        
        DetailViewController* viewController = [segue destinationViewController];
        viewController.realEstate = ((MGMapAnnotation*)sender).object;
    }
    
    if([[segue identifier] isEqualToString:@"segueDetails2"]) {
        
        Detail2ViewController* viewController = [segue destinationViewController];
        viewController.realEstate = ((MGMapAnnotation*)sender).object;
    }
}


-(IBAction)didClickButtonSearch:(id)sender {
    
    [self hideInfoView];
    
    AppDelegate* delegate = [AppDelegate instance];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UINavigationController *vc = [storyboard instantiateViewControllerWithIdentifier:@"storyboardSearch"];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [vc setNavigationBarHidden:YES];
    
    SearchViewController* searchViewController = (SearchViewController*)vc.topViewController;
    searchViewController.searchResultDelegate = self;
    
    [[delegate.window rootViewController] presentViewController:vc animated:YES completion:nil];
}

-(void)searchResults:(NSMutableArray *)array {
    
    [self removeMapPolygons];
    [self removeMapPolylines];
    [self removeMapAnnotations];
    
    [_realEstateArray removeAllObjects];
    
    _realEstateArray = array;
    [self addMapAnnotations];
    [mapViewMain zoomAndFitAnnotations];
}

-(IBAction)didClickButtonNearby:(id)sender {
    
    if(_myLocation != nil) {
        
        [self removeMapPolygons];
        [self removeMapPolylines];
        [self removeMapAnnotations];
        
        NSMutableArray* array = [NSMutableArray arrayWithArray:[CoreDataController getRealEstates]];
        [_realEstateArray removeAllObjects];
        
        for(RealEstate* realEsate in array) {
            
            CLLocation *location;
            location = [[CLLocation alloc] initWithLatitude:[realEsate.lat floatValue]
                                                  longitude:[realEsate.lon floatValue]];
            
            double distance = [location distanceFromLocation:_myLocation];
            
            if(distance <= MAX_RADIUS_NEARBY_IN_METERS) {
                [_realEstateArray addObject:realEsate];
            }
        }
        
        [self addMapAnnotations];
        [mapViewMain zoomAndFitAnnotations];
    }
    else {
        [MGUtilities showAlertTitle:LOCALIZED(@"LOCATION_SERVICE_ERROR")
                            message:LOCALIZED(@"LOCATION_SERVICE_NOT_ENABLED")];
    }
}

@end
