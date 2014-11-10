

#import "RealEstateEditViewController.h"
#import "AppDelegate.h"
#import "AddressSearchMapVC.h"

@interface RealEstateEditViewController ()
{
    NSString *strGeoLatitude;
    NSString *strGeoLongitude;
    CLLocationCoordinate2D realEstateGeocodeCords;
    BOOL isLocationChanged;
}
@property (strong, nonatomic) NSArray   *arrLocationDict;
@property (strong, nonatomic) NSString  *strMatchLat;
@property (strong, nonatomic) NSString  *strMatchLon;
@end

@implementation RealEstateEditViewController

@synthesize scrollViewMain;
@synthesize arrayPhotos;
@synthesize realEstate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
    
    _realEstateView = [[MGRawView alloc] initWithFrame:scrollViewMain.frame nibName:@"RealEstateEditView"];
    
    [scrollViewMain addSubview:_realEstateView];
    scrollViewMain.contentSize = _realEstateView.frame.size;
    
    _realEstateView.textFieldStatus.delegate = self;
    _realEstateView.textFieldPrice.delegate = self;
    _realEstateView.textFieldBeds.delegate = self;
    _realEstateView.textFieldBaths.delegate = self;
    _realEstateView.textFieldSqft.delegate = self;
    _realEstateView.textFieldPriceSqft.delegate = self;
    _realEstateView.textFieldRooms.delegate = self;
    _realEstateView.textFieldLotSize.delegate = self;
    _realEstateView.textFieldBuiltIn.delegate = self;
    _realEstateView.textFieldPropertyType.delegate = self;
    _realEstateView.textFieldAddress.delegate = self;
    
    _realEstateView.textFieldZipCode.delegate = self;
    _realEstateView.textFieldCountry.delegate = self;
    
    _realEstateView.textViewDetails.delegate = self;
    
    [_realEstateView.labelStatus setTextColor:THEME_GREEN_TINT_COLOR];
    [_realEstateView.labelPrice setTextColor:THEME_GREEN_TINT_COLOR];
    [_realEstateView.labelBeds setTextColor:THEME_GREEN_TINT_COLOR];
    [_realEstateView.labelBath setTextColor:THEME_GREEN_TINT_COLOR];
    [_realEstateView.labelSqft setTextColor:THEME_GREEN_TINT_COLOR];
    [_realEstateView.labelPriceSqft setTextColor:THEME_GREEN_TINT_COLOR];
    [_realEstateView.labelRooms setTextColor:THEME_GREEN_TINT_COLOR];
    [_realEstateView.labelLotSize setTextColor:THEME_GREEN_TINT_COLOR];
    [_realEstateView.labelBuiltIn setTextColor:THEME_GREEN_TINT_COLOR];
    [_realEstateView.labelPropertyType setTextColor:THEME_GREEN_TINT_COLOR];
    [_realEstateView.labelAddress setTextColor:THEME_GREEN_TINT_COLOR];
    [_realEstateView.labelPhotos setTextColor:THEME_GREEN_TINT_COLOR];
    
    [_realEstateView.labelCountry setTextColor:THEME_GREEN_TINT_COLOR];
    [_realEstateView.labelZipCode setTextColor:THEME_GREEN_TINT_COLOR];
    
    [self createBorderColor:_realEstateView.textViewDetails];
    
    [_realEstateView.textFieldPrice setText:realEstate.price];
    [_realEstateView.textFieldBeds setText:realEstate.beds];
    [_realEstateView.textFieldBaths setText:realEstate.baths];
    [_realEstateView.textFieldSqft setText:realEstate.sqft];
    [_realEstateView.textFieldPriceSqft setText:realEstate.price_per_sqft];
    [_realEstateView.textFieldRooms setText:realEstate.rooms];
    [_realEstateView.textFieldLotSize setText:realEstate.lot_size];
    [_realEstateView.textFieldBuiltIn setText:realEstate.built_in];
    [_realEstateView.textFieldPropertyType setText:realEstate.property_type];
    [_realEstateView.textFieldAddress setText:realEstate.address];
    
    [_realEstateView.textFieldZipCode setText:realEstate.zipcode];
    [_realEstateView.textFieldCountry setText:realEstate.country];
    
    [_realEstateView.textViewDetails setText:realEstate.desc];
    
    self.strMatchLat = realEstate.lat;
    self.strMatchLon = realEstate.lon;
    
    [_realEstateView.labelStatus setText:LOCALIZED(@"STATUS")];
    [_realEstateView.labelPrice setText:LOCALIZED(@"PRICE")];
    [_realEstateView.labelBeds setText:LOCALIZED(@"BEDS")];
    [_realEstateView.labelBath setText:LOCALIZED(@"BATHS")];
    [_realEstateView.labelSqft setText:LOCALIZED(@"SQFT")];
    [_realEstateView.labelPriceSqft setText:LOCALIZED(@"PRICE_SQFT")];
    [_realEstateView.labelRooms setText:LOCALIZED(@"ROOMS")];
    [_realEstateView.labelLotSize setText:LOCALIZED(@"LOT_SIZE")];
    [_realEstateView.labelBuiltIn setText:LOCALIZED(@"BUILT_IN")];
    [_realEstateView.labelPropertyType setText:LOCALIZED(@"PROPERTY_TYPE")];
    [_realEstateView.labelAddress setText:LOCALIZED(@"ADDRESS")];
    [_realEstateView.labelPhotos setText:LOCALIZED(@"PHOTOS")];
    [_realEstateView.labelCountry setText:LOCALIZED(@"COUNTRY")];
    [_realEstateView.labelZipCode setText:LOCALIZED(@"ZIPCODE")];
    
    [_realEstateView.textFieldPrice setPlaceholder:LOCALIZED(@"PRICE")];
    [_realEstateView.textFieldBeds setPlaceholder:LOCALIZED(@"BEDS")];
    [_realEstateView.textFieldBaths setPlaceholder:LOCALIZED(@"BATHS")];
    [_realEstateView.textFieldSqft setPlaceholder:LOCALIZED(@"SQFT")];
    [_realEstateView.textFieldPriceSqft setPlaceholder:LOCALIZED(@"PRICE_SQFT")];
    [_realEstateView.textFieldRooms setPlaceholder:LOCALIZED(@"ROOMS")];
    [_realEstateView.textFieldLotSize setPlaceholder:LOCALIZED(@"LOT_SIZE")];
    [_realEstateView.textFieldBuiltIn setPlaceholder:LOCALIZED(@"BUILT_IN")];
    [_realEstateView.textFieldPropertyType setPlaceholder:LOCALIZED(@"PROPERTY_TYPE_VAL")];
    [_realEstateView.textFieldAddress setPlaceholder:LOCALIZED(@"ADDRESS")];
    [_realEstateView.textFieldCountry setPlaceholder:LOCALIZED(@"COUNTRY")];
    [_realEstateView.textFieldZipCode setPlaceholder:LOCALIZED(@"ZIPCODE")];
    
    [_realEstateView.segmentStatus setTitle:LOCALIZED(@"FOR_SALE") forSegmentAtIndex:0];
    [_realEstateView.segmentStatus setTitle:LOCALIZED(@"FOR_RENT") forSegmentAtIndex:1];
    [_realEstateView.segmentStatus setTitle:LOCALIZED(@"SOLD") forSegmentAtIndex:2];
    [_realEstateView.segmentStatus setTintColor:THEME_GREEN_TINT_COLOR];
    
    
    _realEstateView.textViewDetails.autocorrectionType = UITextAutocorrectionTypeNo;
    _realEstateView.textFieldPrice.autocorrectionType = UITextAutocorrectionTypeNo;
    _realEstateView.textFieldBeds.autocorrectionType = UITextAutocorrectionTypeNo;
    _realEstateView.textFieldBaths.autocorrectionType = UITextAutocorrectionTypeNo;
    _realEstateView.textFieldSqft.autocorrectionType = UITextAutocorrectionTypeNo;
    _realEstateView.textFieldPriceSqft.autocorrectionType = UITextAutocorrectionTypeNo;
    _realEstateView.textFieldRooms.autocorrectionType = UITextAutocorrectionTypeNo;
    _realEstateView.textFieldLotSize.autocorrectionType = UITextAutocorrectionTypeNo;
    _realEstateView.textFieldBuiltIn.autocorrectionType = UITextAutocorrectionTypeNo;
    _realEstateView.textFieldPropertyType.autocorrectionType = UITextAutocorrectionTypeNo;
    _realEstateView.textFieldAddress.autocorrectionType = UITextAutocorrectionTypeNo;
    _realEstateView.textFieldCountry.autocorrectionType = UITextAutocorrectionTypeNo;
    _realEstateView.textFieldZipCode.autocorrectionType = UITextAutocorrectionTypeNo;
    
    int statusIndex = 0;
    
    if( [LOCALIZED(@"FOR_RENT") isEqualToString:realEstate.status])
        statusIndex = 1;
    else if( [LOCALIZED(@"SOLD") isEqualToString:realEstate.status])
        statusIndex = 2;
    
    [_realEstateView.segmentStatus setSelectedSegmentIndex:statusIndex];
    
    [_realEstateView.buttonPropertyType setTitle:realEstate.property_type
                                        forState:UIControlStateNormal];
    
    [_realEstateView.buttonPropertyType setTitle:realEstate.property_type
                                        forState:UIControlStateSelected];
    
    [_realEstateView.buttonPropertyType addTarget:self
                                           action:@selector(didClickButtonPropertyType:)
                                 forControlEvents:UIControlEventTouchUpInside];

    [_realEstateView.label1 setText:LOCALIZED(@"UPDATE_REALESTATE_HEADER")];
    
    
    [_realEstateView.buttonNext setTitle:LOCALIZED(@"UPDATE_BUTTON_REALESTATE")
                                forState:UIControlStateNormal];
    
    [_realEstateView.buttonNext setTitle:LOCALIZED(@"UPDATE_BUTTON_REALESTATE")
                                forState:UIControlStateSelected];
    
    [_realEstateView.buttonDelete setTitle:LOCALIZED(@"REMOVE_BUTTON_REALESTATE")
                                  forState:UIControlStateNormal];
    
    [_realEstateView.buttonDelete setTitle:LOCALIZED(@"REMOVE_BUTTON_REALESTATE")
                                  forState:UIControlStateSelected];
    
    [_realEstateView.buttonNext addTarget:self
                                  action:@selector(didClickNextButton:)
                        forControlEvents:UIControlEventTouchUpInside];
    
    [_realEstateView.buttonPhotos addTarget:self
                                    action:@selector(didClickButtonPhotos:)
                          forControlEvents:UIControlEventTouchUpInside];
    
    [_realEstateView.buttonDelete addTarget:self
                                     action:@selector(didClickButtonDelete:)
                           forControlEvents:UIControlEventTouchUpInside];
    
    // Automatic scrolling according to the keyboard.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateData:)
                                                 name:@"locationData"
                                               object:nil];
       
    UIEdgeInsets inset = scrollViewMain.contentInset;
    inset.bottom = NAV_BAR_OFFSET_DEFAULT;
    scrollViewMain.contentInset = inset;
    
    inset = scrollViewMain.scrollIndicatorInsets;
    inset.bottom = NAV_BAR_OFFSET_DEFAULT;
    scrollViewMain.scrollIndicatorInsets = inset;
    
    NSArray* array = [CoreDataController getPhotosByRealEstateId:[realEstate.realestate_id intValue] ];
    arrayPhotos = [NSMutableArray arrayWithArray:array];
    _deleted = @"0";
    
    _storedPhotos = [NSMutableArray arrayWithArray:array];
    
    [self updatePhotoCount];
    
    _realEstateView.mapViewDirections.delegate = self;
    [_realEstateView.mapViewDirections baseInit];
    [_realEstateView.mapViewDirections mapView].showsUserLocation = YES;
    
    
    [self setMapAnnotation];
}

- (void)updateData:(NSNotification*)notification
{
    if ([[notification name] isEqualToString:@"locationData"])
    {
    self.arrLocationDict = [[notification userInfo] objectForKey:@"arrLocationDict"];
    
    _realEstateView.textFieldAddress.text = [self.arrLocationDict objectAtIndex:0];
    _realEstateView.textFieldCountry.text = [self.arrLocationDict objectAtIndex:1];
    strGeoLatitude = [self.arrLocationDict objectAtIndex:2];
    strGeoLongitude = [self.arrLocationDict objectAtIndex:3];
    isLocationChanged = YES;
    }
    else
    {
        isLocationChanged = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];po
}

-(void) createBorderColor:(UIView*) view {
    
    [MGUtilities createBordersInView:view
                         borderColor:THEME_GREEN_TINT_COLOR
                         shadowColor:[UIColor clearColor]
                         borderWidth:2.0f
                        borderRadius:0.0];
}

-(void) updatePhotoCount {
    
    NSString* photoCount = [NSString stringWithFormat:@"%d %@", (int)arrayPhotos.count, LOCALIZED(@"PHOTOS_INFO")];
    [_realEstateView.labelInfo setText:photoCount];
}

-(void)keyboardDidShow:(NSNotification *)notification
{
    if ([_realEstateView.textFieldCountry isFirstResponder] || [_realEstateView.textFieldAddress isFirstResponder])
    {
        UIEdgeInsets inset = scrollViewMain.contentInset;
        inset.bottom = 216;
        scrollViewMain.contentInset = inset;
        
        inset = scrollViewMain.scrollIndicatorInsets;
        inset.bottom = 216;
        scrollViewMain.scrollIndicatorInsets = inset;
    }
    else
        if ([_realEstateView.textViewDetails isFirstResponder])
    {
        NSDictionary* info      =  [notification userInfo];
        CGSize keyboardSize     =  [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        // Setting height for textview
        CGRect Rect = self.view.frame;
        
        CGFloat txtViewHeight  =  _realEstateView.textViewDetails.frame.size.height;
        CGPoint txtViewOrigin  =  _realEstateView.textViewDetails.frame.origin;
        Rect.size.height      -=  keyboardSize.height + txtViewHeight +25 ;
        
        if (!CGRectContainsPoint(Rect, txtViewOrigin))
        {
            CGPoint scrollPoint = CGPointMake(0.0, _realEstateView.textViewDetails.frame.origin.y + 130 - keyboardSize.height);
            [self.scrollViewMain setContentOffset:scrollPoint animated:YES];
        }
    }
    else
    {
        UIEdgeInsets inset = scrollViewMain.contentInset;
        inset.bottom = 272;
        scrollViewMain.contentInset = inset;
        
        inset = scrollViewMain.scrollIndicatorInsets;
        inset.bottom = 272;
        scrollViewMain.scrollIndicatorInsets = inset;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [_realEstateView.textViewDetails becomeFirstResponder];
}

-(void)keyboardDidHide:(id)sender
{
    UIEdgeInsets inset = scrollViewMain.contentInset;
    inset.bottom = NAV_BAR_OFFSET;
    scrollViewMain.contentInset = inset;
    
    inset = scrollViewMain.scrollIndicatorInsets;
    inset.bottom = NAV_BAR_OFFSET;
    scrollViewMain.scrollIndicatorInsets = inset;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Selector

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _realEstateView.textFieldCountry) {
        [_realEstateView.textFieldCountry resignFirstResponder];
        [_realEstateView.textViewDetails becomeFirstResponder];
        
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIToolbar *keyboardaAdditionalButtonView = [[UIToolbar alloc] init];
    keyboardaAdditionalButtonView.backgroundColor = [UIColor whiteColor];
    [keyboardaAdditionalButtonView sizeToFit];
    
    if (textField.keyboardType == UIKeyboardTypeNumberPad)
    {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle: @"Done"
                                                                       style: UIBarButtonItemStyleBordered
                                                                      target: self
                                                                      action: @selector(doneClicked:)];
        doneButton.tintColor = THEME_GREEN_TINT_COLOR;
        
        UIBarButtonItem *elementrySpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]initWithTitle: @"Next"
                                                                      style: UIBarButtonItemStyleBordered
                                                                     target: self
                                                                     action: @selector(nextClicked:)];
        nextButton.tintColor = THEME_GREEN_TINT_COLOR;
        
        [keyboardaAdditionalButtonView setItems: [NSArray arrayWithObjects: doneButton, elementrySpace, nextButton, nil]];
        textField.inputAccessoryView = keyboardaAdditionalButtonView;
        
    }
    else
    {
        keyboardaAdditionalButtonView.hidden = YES;
        [keyboardaAdditionalButtonView reloadInputViews];
}}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _realEstateView.textFieldAddress)
    {
        [_realEstateView.textFieldAddress resignFirstResponder];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        AddressSearchMapVC *addressDirectionVC = [AddressSearchMapVC new];
        addressDirectionVC = [storyboard instantiateViewControllerWithIdentifier:@"AddressSearchMapVC"];
        [self.navigationController pushViewController:addressDirectionVC animated:NO];
        return NO;
    }
    return true;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > MAX_CHARS_INPUT) ? NO : YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    
    [textView resignFirstResponder];
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
       
        CGPoint scrollPoint = CGPointMake (0.0,  _realEstateView.textViewDetails.frame.origin.y - 230);
        [self.scrollViewMain setContentOffset:scrollPoint animated:YES];
    
        return NO;
    }
    else
        if (textView == _realEstateView.textViewDetails)
        {
            if (textView.text.length + (text.length - range.length) == 500) {
                UIColor* color = [THEME_GREEN_TINT_COLOR colorWithAlphaComponent:0.70];
                [MGUtilities showStatusNotifier:LOCALIZED(@"TEXTVIEW_CHARACTER_LIMIT_ALERT")
                                      textColor:[UIColor whiteColor]
                                 viewController:self
                                       duration:0.5f
                                        bgColor:color
                                            atY:64];
                
            }
            return textView.text.length + (text.length - range.length) <= 500;
        }
        else
        {
            return YES;
        }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    [scrollViewMain scrollRectToVisible:_realEstateView.textViewDetails.frame animated:YES];
    
    return YES;
}

-(void) textViewDidChangeSelection:(UITextView *)textView {
    
    NSString* notes = [[textView text] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if([notes isEqualToString:TEXT_VIEW_PLACEHOLDER_TEXT])
        notes = [notes stringByReplacingOccurrencesOfString:TEXT_VIEW_PLACEHOLDER_TEXT withString:@""];
    
    [_realEstateView.textViewDetails setText:notes];
}

-(void) returnPhotoArrays:(NSMutableArray *)photos {
    
    arrayPhotos = [NSMutableArray arrayWithArray:photos];
    [self updatePhotoCount];
}

-(void)returnPhotoArrayFromFile:(NSMutableArray *)photos {
    
    for(Photo* photo in photos) {
        [_storedPhotos addObject:photo];
    }
}

#pragma mark - Selector

-(void) didClickNextButton:(id)sender {
    
    //***
    //Getting latitude and longitude from address.
    //**
    //[self geoCodeUsingAddress:_realEstateView.textFieldAddress.text];
    
    /*if (strGeoLatitude != _strMatchLat && strGeoLatitude != nil && strGeoLongitude != _strMatchLon && strGeoLongitude != nil)
    {
        realEstate.lat = strGeoLatitude;
        realEstate.lon = strGeoLongitude;
    }
    else
    {} */
    
    if (isLocationChanged == YES)
    {
        realEstate.lat = strGeoLatitude;
        realEstate.lon = strGeoLongitude;
    }
    else
    {}
    
    if(![MGUtilities hasInternetConnection]) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"NETWORK_ERROR_DETAILS")];
        return;
    }
    
    realEstate.status = LOCALIZED(@"SOLD");
    
    if([_realEstateView.segmentStatus selectedSegmentIndex] == 0) {
        realEstate.status = LOCALIZED(@"FOR_SALE");
    }
    else if([_realEstateView.segmentStatus selectedSegmentIndex] == 1) {
        realEstate.status = LOCALIZED(@"FOR_RENT");
    }
    
    realEstate.price = [_realEstateView.textFieldPrice text];
    realEstate.beds = [_realEstateView.textFieldBeds text];
    realEstate.baths = [_realEstateView.textFieldBaths text];
    realEstate.sqft = [_realEstateView.textFieldSqft text];
    realEstate.price_per_sqft = [_realEstateView.textFieldPriceSqft text];
    realEstate.rooms = [_realEstateView.textFieldRooms text];
    realEstate.lot_size = [_realEstateView.textFieldLotSize text];
    realEstate.built_in = [_realEstateView.textFieldBuiltIn text];
    realEstate.property_type = [[_realEstateView.buttonPropertyType titleLabel] text];
    realEstate.address = [_realEstateView.textFieldAddress text];
    realEstate.desc = [_realEstateView.textViewDetails text];
    realEstate.zipcode = [_realEstateView.textFieldZipCode text];
    realEstate.country = [_realEstateView.textFieldCountry text];
    //realEstate.lat = @"";
    //realEstate.lon = @"";
    
    //if(CLLocationCoordinate2DIsValid(_dropAtCoords)) {
    //    realEstate.lat = [NSString stringWithFormat:@"%f", _dropAtCoords.latitude];
    //    realEstate.lon = [NSString stringWithFormat:@"%f", _dropAtCoords.longitude];
    //}
    
    if([realEstate.price length] == 0 ||
       [realEstate.address length] == 0 ||
       [realEstate.property_type length] == 0 ||
       [realEstate.price_per_sqft length] == 0 ||
       [realEstate.sqft length] == 0) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"FIELD_REQUIRED_ERROR")
                            message:LOCALIZED(@"FIELD_REQUIRED_ERROR_DETAILS_REALESTATE")];
        return;
    }
    
    [self startSync:realEstate];
}


-(void) startSync:(id)sender {
    
    [self.navigationItem setHidesBackButton:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = LOCALIZED(@"UPDATING_REALESTATE");
    
    [self.view addSubview:hud];
    [self.view setUserInteractionEnabled:NO];
    
    NSURL *url = [NSURL URLWithString:REAL_ESTATE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    AgentSession* agentSession = [UserAccessSession getAgentSession];
    UserSession* session = [UserAccessSession getUserSession];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            
                            session.userId, @"user_id",
                            session.loginHash, @"login_hash",
                            realEstate.status, @"status",
                            realEstate.price, @"price",
                            realEstate.beds, @"beds",
                            realEstate.baths, @"baths",
                            realEstate.sqft, @"sqft",
                            realEstate.price_per_sqft, @"price_per_sqft",
                            realEstate.rooms, @"rooms",
                            realEstate.lot_size, @"lot_size",
                            realEstate.built_in, @"built_in",
                            realEstate.property_type, @"property_type",
                            realEstate.address, @"address",
                            
                            realEstate.desc, @"desc1",
                            realEstate.zipcode, @"zipcode",
                            realEstate.country, @"country",
                            [realEstate.realestate_id stringValue],  @"realestate_id",
                            agentSession.agent_id, @"agent_id",
                            _deleted, @"is_deleted",
                            realEstate.lat, @"lat",
                            realEstate.lon, @"lon",
                            nil];
    
    [httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"REAL_ESTATE_SYNC = %@", responseStr);
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        
        NSLog(@"REAL_ESTATE_SYNC_JSON = %@", json);
        
        NSDictionary* dictRealEstate = [json objectForKey:@"realestate_info"];
        NSDictionary* dictStatus = [json objectForKey:@"status"];
        
        if([[dictStatus valueForKey:@"status_code"] isEqualToString:STATUS_SUCCESS]) {
            
            _realestate_id = [dictRealEstate objectForKey:@"realestate_id"];
            NSString* isDeleted = [dictRealEstate valueForKey:@"is_deleted"];
            RealEstate* _realEstate = [CoreDataController getRealEstateByRealEstateId:[_realestate_id intValue]];
            
            if([isDeleted isEqualToString:@"1"]) {
                
                [_realEstate.managedObjectContext deleteObject:_realEstate];
            }
            else {
                
                
                _realEstate.status = [dictRealEstate objectForKey:@"status"];
                _realEstate.price = [dictRealEstate objectForKey:@"price"];
                _realEstate.beds = [dictRealEstate objectForKey:@"beds"];
                _realEstate.baths = [dictRealEstate objectForKey:@"baths"];
                _realEstate.sqft = [dictRealEstate objectForKey:@"sqft"];
                _realEstate.price_per_sqft = [dictRealEstate objectForKey:@"price_per_sqft"];
                _realEstate.rooms = [dictRealEstate objectForKey:@"rooms"];
                _realEstate.lot_size = [dictRealEstate objectForKey:@"lot_size"];
                _realEstate.built_in = [dictRealEstate objectForKey:@"built_in"];
                _realEstate.property_type = [dictRealEstate objectForKey:@"property_type"];
                _realEstate.address = [dictRealEstate objectForKey:@"address"];
                _realEstate.desc = [dictRealEstate objectForKey:@"desc"];
                _realEstate.zipcode = [dictRealEstate objectForKey:@"zipcode"];
                _realEstate.country = [dictRealEstate objectForKey:@"country"];
                _realEstate.desc = [dictRealEstate objectForKey:@"desc1"];
                
                NSError* error;
                if ([_realEstate.managedObjectContext hasChanges] &&
                    ![_realEstate.managedObjectContext save:&error]) {
                    
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }
            
            if(_storedPhotos.count > 0){
                [self syncPhotos];
            }
            else {
                [self.navigationItem setHidesBackButton:NO];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else {
            [MGUtilities showAlertTitle:LOCALIZED(@"UNSYNC_CONNECTION_ERROR")
                                message:[dictStatus valueForKey:@"status_text"]];
            NSLog(@"Error: %@", [dictStatus valueForKey:@"status_text"]);
            
            [self.navigationItem setHidesBackButton:NO];
        }
        
        [hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        
        [hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
        [MGUtilities showAlertTitle:LOCALIZED(@"UNSYNC_CONNECTION_ERROR")
                            message:LOCALIZED(@"UNSYNC_CONNECTION_ERROR_DETAILS")];
        
        [self.navigationItem setHidesBackButton:NO];
        
    }];
}

-(NSData*)CompressImageData:(UIImage*)croppedImage
{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    
    NSData *imageData = UIImageJPEGRepresentation(croppedImage, compression);
    
    NSData *data1 = UIImagePNGRepresentation(croppedImage);
    
    NSLog(@"Real Photo galary image from size in MB :%.2f",(float)data1.length/1024.0f/1024.0f);
    
    NSLog(@"imagedata length : %lu",(unsigned long)imageData.length);
    
    while ([imageData length] > 50000 && compression > maxCompression)
    {
        compression -= 0.10;
        imageData = UIImageJPEGRepresentation(croppedImage, compression);
        NSLog(@"Compress : %lu",(unsigned long)imageData.length);
        NSLog(@"Compress Photo galary image from size in MB :%.2f",(float)imageData.length/1024.0f/1024.0f);
    }
    return imageData;
}

-(void)syncPhotos {
    
    _index = 0;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = LOCALIZED(@"SYNCING_PHOTOS");
    
    [self.view addSubview:hud];
    [self.view setUserInteractionEnabled:NO];
    [self startSyncPhoto:hud index:_index];
}

-(void)startSyncPhoto:(MBProgressHUD*)hud index:(int)index {
    
    hud.labelText = [NSString stringWithFormat:@"%@ (%d/%lu)",
                     LOCALIZED(@"SYNCING_PHOTOS"),
                     index + 1,
                     (unsigned long)_storedPhotos.count];
    
    Photo* photo = [_storedPhotos objectAtIndex:index];
    
    NSURL *url = [NSURL URLWithString:FILE_UPLOADER_REALESTATE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    UserSession* session = [UserAccessSession getUserSession];
    NSDictionary *params = nil;
    
    NSString* is_deleted = @"1";
    
    for(Photo* item in arrayPhotos) {
        
        if([photo.photo_id intValue] == [item.photo_id intValue]) {
            is_deleted = @"0";
            photo.isImagePicked = item.isImagePicked;
            break;
        }
    }
    
    
    if(photo.isImagePicked) {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  session.userId, @"user_id",
                  session.loginHash, @"login_hash",
                  _realestate_id, @"realestate_id",
                  photo.photo_id, @"photo_id",
                  is_deleted, @"is_deleted",
                  nil];
    }
    else {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  session.userId, @"user_id",
                  session.loginHash, @"login_hash",
                  photo.thumb_url, @"thumb_url",
                  _realestate_id, @"realestate_id",
                  photo.photo_id, @"photo_id",
                  is_deleted, @"is_deleted",
                  nil];
    }
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        if(photo.isImagePicked) {
            
            NSData* dataThumb = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:photo.thumb_url]];
            NSData* dataPhoto = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:photo.photo_url]];
            
            UIImage *imgThumb = [UIImage imageWithData:dataThumb];
            UIImage *imgPhoto = [UIImage imageWithData:dataPhoto];
            
            dataThumb = nil;
            dataPhoto = nil;
            
            dataThumb = [self CompressImageData:imgThumb];
            dataPhoto = [self CompressImageData:imgPhoto];

            NSString* fullNameThumb = [photo.thumb_url lastPathComponent];
            //NSString* fullNamePhoto = [photo.photo_url lastPathComponent];
            
            [formData appendPartWithFileData:dataThumb
                                        name:@"thumb_file"
                                    fileName:fullNameThumb
                                    mimeType:@"image/jpeg"];
            
            /*[formData appendPartWithFileData:dataPhoto
                                        name:@"photo_file"
                                    fileName:fullNamePhoto
                                    mimeType:@"image/jpeg"]; */
        }
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"PHOTO_REALESTATE_SYNC = %@", responseStr);
        
        NSDictionary* dictStatus = [json objectForKey:@"status"];
        NSDictionary* dictPhoto = [json objectForKey:@"photo_realestate_info"];
        
        if([[dictStatus valueForKey:@"status_code"] isEqualToString:STATUS_SUCCESS]) {
            
            int photo_id = [[dictPhoto valueForKey:@"photo_id"] intValue];
            int is_deleted = [[dictPhoto valueForKey:@"is_deleted"] intValue];
            Photo* photo = [CoreDataController getPhotoByPhotoId:photo_id];
            
            if(photo != nil) {
                
                if (is_deleted == 1) {
                    [photo.managedObjectContext deleteObject:photo];
                }
                else {
                    NSError* error;
                    photo.thumb_url = [dictPhoto valueForKey:@"thumb_url"];
                    photo.photo_url = [dictPhoto valueForKey:@"photo_url"];
                    
                    if ([photo.managedObjectContext hasChanges] && ![photo.managedObjectContext save:&error]) {
                        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                        abort();
                    }
                }
            }
            else {
                [CoreDataController insertPhotoFromDictionary:dictPhoto];
            }
            
            if(photo.isImagePicked) {
                [MGFileManager deleteImageAtFilePath:photo.thumb_url];
                [MGFileManager deleteImageAtFilePath:photo.photo_url];
            }
            
            if(index < arrayPhotos.count - 1 && arrayPhotos.count > 0) {
                
                ++_index;
                [self startSyncPhoto:hud index:_index];
            }
            else {
                [hud removeFromSuperview];
                 [self.navigationItem setHidesBackButton:NO];
                [self.view setUserInteractionEnabled:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else {
            [MGUtilities showAlertTitle:LOCALIZED(@"UNSYNC_CONNECTION_ERROR")
                                message:[dictStatus valueForKey:@"status_text"]];
            
            [self.navigationItem setHidesBackButton:NO];
            
            [hud removeFromSuperview];
            [self.view setUserInteractionEnabled:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        
        [MGUtilities showAlertTitle:LOCALIZED(@"UNSYNC_CONNECTION_ERROR")
                            message:LOCALIZED(@"UNSYNC_CONNECTION_ERROR_DETAILS")];
        
        [self.navigationItem setHidesBackButton:NO];
        
        [hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
    }];
    [operation start];
}

-(void)didClickButtonPhotos:(id)sender {
    
    AppDelegate* delegate = [AppDelegate instance];
    UINavigationController* navController = (UINavigationController*)delegate.contentViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Extra_iPhone" bundle:nil];
    
    RealEstateImagesViewController* vc;
    vc = [storyboard instantiateViewControllerWithIdentifier:@"storyboardImagesRealEstate"];
    vc.realEstatePhotosDelegate = self;
    vc.arrayPhotos = arrayPhotos;
    vc.realEstate = realEstate;
    [navController pushViewController:vc animated:YES];
}

-(void) MGMapView:(MGMapView*)mapView didSelectMapAnnotation:(MGMapAnnotation*)mapAnnotation { }

-(void) MGMapView:(MGMapView*)mapView didAccessoryTapped:(MGMapAnnotation*)mapAnnotation { }

-(void) MGMapView:(MGMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation { }

-(void) MGMapView:(MGMapView *)mapView
   annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
     fromOldState:(MKAnnotationViewDragState)oldState {
    
    if (newState == MKAnnotationViewDragStateEnding) {
        
        _dropAtCoords = annotationView.annotation.coordinate;
        NSLog(@"Pin dropped at %f, %f", _dropAtCoords.latitude, _dropAtCoords.longitude);
        
        CLLocation* loc = [[CLLocation alloc] initWithLatitude:_dropAtCoords.latitude longitude:_dropAtCoords.longitude];
        [_realEstateView.mapViewDirections getAddressFromLatLon:loc];
    }
}

-(void) MGMapView:(MGMapView*)mapView
didCreateMKPinAnnotationView:(MKPinAnnotationView*)mKPinAnnotationView
viewForAnnotation:(id<MKAnnotation>)annotation {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    UIImage* imageAnnotation = [UIImage imageNamed:MAP_ARROW_RIGHT_HOUSE_IMAGE];
    [imageView setImage:imageAnnotation];
    
    mKPinAnnotationView.pinColor = MKPinAnnotationColorGreen;
    mKPinAnnotationView.draggable = YES;
    
    imageView.frame = CGRectMake (0, 0, imageAnnotation.size.width, imageAnnotation.size.height);
    mKPinAnnotationView.rightCalloutAccessoryView = imageView;
}

-(void) MGMapView:(MGMapView *)mapView geoCodePlaceMark:(CLPlacemark *)placemarks addressDictionary:(NSDictionary *)dic {
    
    NSString* city = @"";
    NSString* country = @"";
    NSString* street = @"";
    NSString* zipCode = @"";
    
    if([dic valueForKey:@"City"] != nil)
        city = [[dic valueForKey:@"City"] stringByAppendingString:@", "];
    
    if([dic valueForKey:@"Country"] != nil)
        country = [dic valueForKey:@"Country"];
    
    if([dic valueForKey:@"Street"] != nil)
        street = [[dic valueForKey:@"Street"] stringByAppendingString:@", "];
    
    if([dic valueForKey:@"Country"] != nil)
        zipCode = [dic valueForKey:@"ZIP"];
    
    NSString* fullAddress = [NSString stringWithFormat:@"%@%@%@", street, city, country];
    [_realEstateView.textFieldAddress setText:fullAddress];
    
    [_realEstateView.textFieldCountry setText:country];
    [_realEstateView.textFieldZipCode setText:zipCode];
}

//***
//Getting latitude and longitude from address.
//**
/*
- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:GOOGLE_MAP_GEOCODE_URL, esc_addr];
    
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    realEstateGeocodeCords.latitude = latitude;
    realEstateGeocodeCords.longitude = longitude;
    
    strGeoLatitude  = [NSString stringWithFormat:@"%.9f", latitude] ;
    strGeoLongitude = [NSString stringWithFormat:@"%.9f", longitude];
    NSLog(@"Latitude: %f", [strGeoLatitude floatValue]);
    NSLog(@"Longitude: %f", [strGeoLongitude floatValue]);
    
    return realEstateGeocodeCords;
}
*/

-(void)findMyCurrentLocation {
    
    if(_myLocationManager == nil) {
        
        _myLocationManager = [[CLLocationManager alloc] init];
        _myLocationManager.delegate = self;
        
        if(IS_OS_8_OR_LATER) {
            [_myLocationManager requestWhenInUseAuthorization];
            [_myLocationManager requestAlwaysAuthorization];
        }
        
        [_realEstateView.mapViewDirections.mapView setShowsUserLocation:YES];
        [_myLocationManager startUpdatingLocation];
        
        if( [CLLocationManager locationServicesEnabled] ) {
            NSLog(@"Location Services Enabled....");
        }
        else {
            [MGUtilities showAlertTitle:LOCALIZED(@"LOCATION_SERVICE_ERROR")
                                message:LOCALIZED(@"LOCATION_SERVICE_NOT_ENABLED")];
        }
    }
    else {
        [_myLocationManager startUpdatingLocation];
    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation: (CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    _myLocation = newLocation;
    
    if(newLocation.coordinate.latitude != oldLocation.coordinate.latitude &&
       newLocation.coordinate.longitude != oldLocation.coordinate.longitude) {
        
        [_realEstateView.mapViewDirections getAddressFromLatLon:_myLocation];
        
    }
    
    _annotation = [[MGMapAnnotation alloc] initWithCoordinate:_myLocation.coordinate
                                                         name:LOCALIZED(@"CURRENT_LOCATION")
                                                  description:LOCALIZED(@"DRAG_ME")];
    
    [_realEstateView.mapViewDirections setMapData:[NSMutableArray arrayWithObjects:_annotation, nil]];
    
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(_myLocation.coordinate,
                                                                       0.5*METES_PER_MILE,
                                                                       0.5*METES_PER_MILE);
    
    MKCoordinateRegion adjustedRegion = [_realEstateView.mapViewDirections regionThatFits:viewRegion];
    [_realEstateView.mapViewDirections setRegion:adjustedRegion animated:YES];
    
    [manager stopUpdatingLocation];
}

- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error {
    
}

-(void)setMapAnnotation
{
    CLLocationCoordinate2D coords;
    coords = CLLocationCoordinate2DMake([realEstate.lat floatValue], [realEstate.lon floatValue]);
    
    if(CLLocationCoordinate2DIsValid(coords))
    {
        _annotation = [[MGMapAnnotation alloc] initWithCoordinate:coords
                                                             name:realEstate.address
                                                      description:[NSString stringWithFormat:@"PRICE: $%@", realEstate.price]];
        
        [_realEstateView.mapViewDirections setMapData:[NSMutableArray arrayWithObjects:_annotation, nil]];
        
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coords,
                                                                           0.5*METES_PER_MILE,
                                                                           0.5*METES_PER_MILE);
        
        MKCoordinateRegion adjustedRegion = [_realEstateView.mapViewDirections regionThatFits:viewRegion];
        [_realEstateView.mapViewDirections setRegion:adjustedRegion animated:YES];
    }
    else {
        [self findMyCurrentLocation];
    }
}

-(void)didClickButtonDelete:(id)sender {
    
    _deleted = @"1";
    [arrayPhotos removeAllObjects];
    [self startSync:realEstate];
}

-(void)didClickButtonPropertyType:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    PTypeViewController* pTypeViewController = [storyboard instantiateViewControllerWithIdentifier:@"storyboardPropertyType"];
    pTypeViewController.propertyTypeDelegate = self;
    
    NSMutableArray* array = [NSMutableArray new];
    [array insertObject:LOCALIZED_NOT_NULL(@"ALL_TYPE") atIndex:0];
    
    NSArray* arrayPropertyType = [CoreDataController getPropertyTypes];
    
    for(PropertyType* type in arrayPropertyType)
        [array addObject:type.property_type];
    
    pTypeViewController.arrayData = array;
    
    [self.navigationController pushViewController:pTypeViewController animated:YES];
    
}

-(void)didSelectPropertyType:(NSString *)propertyType {
    
    [_realEstateView.buttonPropertyType setTitle:propertyType
                                        forState:UIControlStateNormal];
    
    [_realEstateView.buttonPropertyType setTitle:propertyType
                                        forState:UIControlStateSelected];
}

- (IBAction)doneClicked:(id)sender
{
    [_realEstateView.textFieldPrice resignFirstResponder];
    [_realEstateView.textFieldBeds resignFirstResponder];
    [_realEstateView.textFieldBaths resignFirstResponder];
    [_realEstateView.textFieldSqft resignFirstResponder];
    [_realEstateView.textFieldPriceSqft resignFirstResponder];
    [_realEstateView.textFieldRooms resignFirstResponder];
    [_realEstateView.textFieldLotSize resignFirstResponder];
    [_realEstateView.textFieldBuiltIn resignFirstResponder];
    [_realEstateView.textFieldZipCode resignFirstResponder];
}

- (IBAction)nextClicked:(id)sender
{
    if ([_realEstateView.textFieldPrice isFirstResponder])
    {
        [_realEstateView.textFieldBeds becomeFirstResponder];
    }
    else if ([_realEstateView.textFieldBeds isFirstResponder])
    {
        [_realEstateView.textFieldBaths becomeFirstResponder];
    }
    else if ([_realEstateView.textFieldBaths isFirstResponder])
    {
        [_realEstateView.textFieldSqft becomeFirstResponder];
    }
    else if ([_realEstateView.textFieldSqft isFirstResponder])
    {
        [_realEstateView.textFieldPriceSqft becomeFirstResponder];
    }
    else if ([_realEstateView.textFieldPriceSqft isFirstResponder])
    {
        [_realEstateView.textFieldRooms becomeFirstResponder];
    }
    else if ([_realEstateView.textFieldRooms isFirstResponder])
    {
        [_realEstateView.textFieldLotSize becomeFirstResponder];
    }
    else if ([_realEstateView.textFieldLotSize isFirstResponder])
    {
        [_realEstateView.textFieldBuiltIn becomeFirstResponder];
    }
    else if ([_realEstateView.textFieldBuiltIn isFirstResponder])
    {
        [_realEstateView.textFieldZipCode becomeFirstResponder];
    }
    else if ([_realEstateView.textFieldZipCode isFirstResponder])
    {
        [_realEstateView.textFieldCountry becomeFirstResponder];
    }
}

@end
