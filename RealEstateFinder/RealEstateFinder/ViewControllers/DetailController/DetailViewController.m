//
//  DetailViewController.m
//  RealEstateFinder
//
//  
//  Copyright (c) 2014 MangasaurGames. All rights reserved.
//

#import "DetailViewController.h"
#import "ImageViewerController.h"
#import "ViewDirectionMap.h"

#define MAX_HEIGHT 300

@interface DetailViewController ()
{
    UIWebView *mCallWebview;
}

@end

@implementation DetailViewController

@synthesize tableViewMain;
@synthesize realEstate;

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
    
    _commandView = [[MGRawView alloc] initWithNibName:@"CommandView"];
    
    CGRect rectView = _commandView.frame;
    rectView.origin.y = self.view.frame.size.height;
    _commandView.frame = rectView;
    [self.view addSubview:_commandView];
    _commandView.layer.zPosition = 999;
    
    [_commandView.buttonCall addTarget:self
                               action:@selector(didClickButtonCall:)
                     forControlEvents:UIControlEventTouchUpInside];
    
    [_commandView.buttonEmail addTarget:self
                                 action:@selector(didClickButtonEmail:)
                       forControlEvents:UIControlEventTouchUpInside];
    
    [_commandView.buttonSMS addTarget:self
                               action:@selector(didClickButtonSMS:)
                     forControlEvents:UIControlEventTouchUpInside];
    
    [_commandView.buttonFb addTarget:self
                               action:@selector(didClickButtonFacebook:)
                     forControlEvents:UIControlEventTouchUpInside];
    
    [_commandView.buttonTwitter addTarget:self
                                   action:@selector(didClickButtonTwitter:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    [_commandView.buttonFave addTarget:self
                                action:@selector(didClickButtonFave:)
                      forControlEvents:UIControlEventTouchUpInside];
    
    
    [self checkFave];
    
    
    _headerView = [[MGRawView alloc] initWithNibName:@"HeaderView"];
    _headerView.imgViewPhoto.contentMode = UIViewContentModeScaleAspectFill;
    _headerView.imgViewPhoto.clipsToBounds = YES;
    _headerView.label1.backgroundColor = [BLACK_TEXT_COLOR colorWithAlphaComponent:0.66];

    _headerView.labelTitle.textColor = WHITE_TEXT_COLOR;
    _headerView.labelSubtitle.textColor = WHITE_TEXT_COLOR;
    
    _headerView.labelTitle.text = realEstate.price;
    _headerView.labelSubtitle.text = realEstate.address;
    
    _arrayPhotos = [CoreDataController getPhotosByRealEstateId:[realEstate.realestate_id intValue]];
    
    [_headerView.buttonPhotos addTarget:self
                                 action:@selector(didCLickButtonPhotos:)
                       forControlEvents:UIControlEventTouchUpInside];
    
    [_headerView.labelPhotos setText:[NSString stringWithFormat:@"%d", (int)_arrayPhotos.count]];
    
    _imageHeight = _headerView.frame.size.height;
    
    Photo* p = [CoreDataController getPhotoByRealEstateId:[realEstate.realestate_id intValue]];
    
    if(p != nil)
        [self setImage:p.thumb_url imageView:_headerView.imgViewPhoto];
    
    
    tableViewMain.delegate = self;
    tableViewMain.cellHeight = 1000;
    [tableViewMain registerNibName:@"DetailCell" cellIndentifier:@"DetailCell"];
    [tableViewMain baseInit];
    
    tableViewMain.tableView.tableHeaderView = _headerView;
    tableViewMain.arrayData = [NSMutableArray arrayWithObject: p == nil ? [CoreDataController getDummyPhoto] : p];
    [tableViewMain reloadData];
    [tableViewMain tableView].delaysContentTouches = NO;
    

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    singleTap.delegate = self;
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [[tableViewMain tableView] addGestureRecognizer:singleTap];
    
    _lastY = 0;
    
    
    if(SHOW_ADS_REAL_ESTATE_DETAIL_VIEW) {
        
        UIEdgeInsets inset = tableViewMain.tableView.contentInset;
        inset.top = ADV_VIEW_OFFSET;
        tableViewMain.tableView.contentInset = inset;
        
        inset = tableViewMain.tableView.scrollIndicatorInsets;
        inset.top = ADV_VIEW_OFFSET;
        tableViewMain.tableView.scrollIndicatorInsets = inset;
        
        [MGUtilities createAdAtY:64
                  viewController:self
                         bgColor:AD_BG_COLOR];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:DETAIL_PLACEHOLDER];
    
    [imgView setImageWithURLRequest:urlRequest
                   placeholderImage:imgPlaceholder
                            success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
                                
                                CGSize size = weakImgRef.frame.size;
                                
                                if([MGUtilities isRetinaDisplay]) {
                                    size.height *= 2;
                                    size.width *= 2;
                                }
                                
                                UIImage* croppedImage = [image imageByScalingAndCroppingForSize:size];
                                weakImgRef.image = croppedImage;
                                
                            } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                
                            }];
}

-(void) MGListView:(MGListView *)_listView didSelectCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
}

-(UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    if(cell != nil) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = DETAIL_BG_COLOR;
        
        cell.labelStatus.text = LOCALIZED(@"STATUS");
        cell.labelPrice.text = LOCALIZED(@"PRICE");
        cell.labelBeds.text = LOCALIZED(@"BEDS");
        cell.labelBath.text = LOCALIZED(@"BATHS");
        cell.labelSqft.text = LOCALIZED(@"SQFT");
        cell.labelPriceSqft.text = LOCALIZED(@"PRICE_SQFT");
        cell.labelRooms.text = LOCALIZED(@"ROOMS");
        cell.labelLotSize.text = LOCALIZED(@"LOT_SIZE");
        cell.labelBuiltIn.text = LOCALIZED(@"BUILT_IN");
        cell.labelPropertyType.text = LOCALIZED(@"PROPERTY_TYPE");
        cell.labelDateAdded.text = LOCALIZED(@"DATE_ADDED");
        cell.labelAddress.text = LOCALIZED(@"ADDRESS");
        cell.labelHeader1.text = LOCALIZED(@"FEATURES");
        cell.labelHeader2.text = LOCALIZED(@"SITE_LOCATION");
        
        cell.labelStatusVal.text = realEstate.status;
        cell.labelPriceVal.text = realEstate.price;
        cell.labelBedsVal.text = realEstate.beds;
        cell.labelBathVal.text = realEstate.baths;
        cell.labelSqftVal.text = realEstate.sqft;
        cell.labelPriceSqftVal.text = realEstate.price_per_sqft;
        cell.labelRoomsVal.text = realEstate.rooms;
        cell.labelLotSizeVal.text = realEstate.lot_size;
        cell.labelBuiltInVal.text = realEstate.built_in;
        cell.labelPropertyTypeVal.text = realEstate.property_type;
        
        cell.topLeftLabelAddressVal.text = realEstate.address;
        
        cell.topLeftLabelDescVal.text = realEstate.desc;
        
        double createdAt = [realEstate.created_at doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
        
        NSString *formattedDateString = [dateFormatter stringFromDate:date];
        cell.labelDateAddedVal.text = formattedDateString;
        
        
        cell.mapViewCell.delegate = self;
        [cell.mapViewCell baseInit];
        cell.mapViewCell.mapView.zoomEnabled = NO;
        cell.mapViewCell.mapView.scrollEnabled = NO;
        
        
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([realEstate.lat doubleValue], [realEstate.lon doubleValue]);
        
        MGMapAnnotation* ann = [[MGMapAnnotation alloc] initWithCoordinate:coords
                                                                      name:realEstate.address
                                                               description:[NSString stringWithFormat:@"PRICE: $%@", realEstate.price]];
        ann.object = realEstate;
        
        
        [cell.mapViewCell setMapData:[NSMutableArray arrayWithObjects:ann, nil] ];
        [cell.mapViewCell setSelectedAnnotation:coords];
        [cell.mapViewCell moveCenterByOffset:CGPointMake(0, -40) from:coords];
        
        
    }
    
    return cell;
}

-(void)MGListView:(MGListView *)_listView scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat yPos = -scrollView.contentOffset.y;
    
    if (yPos > 0) {
        CGRect imgRect = _headerView.imgViewPhoto.frame;
        imgRect.origin.y = scrollView.contentOffset.y;
        imgRect.size.height = _imageHeight + yPos;
        _headerView.imgViewPhoto.frame = imgRect;
    }
    
    
    
    float currentY = scrollView.contentOffset.y;
    float diff = currentY - _lastY;
    _lastY = currentY;
    
    CGRect frame = _commandView.frame;
    
    float viewHeight = self.view.frame.size.height;
    float showY = viewHeight - frame.size.height;
    float limitHeight = [tableViewMain cellHeight] - _headerView.frame.size.height;
    
    if(diff > 5 && frame.origin.y != showY && currentY >= 0 && !_isAnimatingCommandView) {

        // will show
        _isAnimatingCommandView = YES;
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             CGRect frame = _commandView.frame;
                             frame.origin.y = showY;
                             _commandView.frame = frame;
                         }
                         completion:^(BOOL finished){
                             _isAnimatingCommandView = NO;
                         }];
    }
    else if(diff < -5 && frame.origin.y != viewHeight && currentY <= limitHeight && !_isAnimatingCommandView) {
        
        // will hide
        _isAnimatingCommandView = YES;
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             CGRect frame = _commandView.frame;
                             frame.origin.y = self.view.frame.size.height;
                             _commandView.frame = frame;
                         }
                         completion:^(BOOL finished){
                             _isAnimatingCommandView = NO;
                         }];
    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UITableView *tableView = (UITableView *)gestureRecognizer.view;
    CGPoint p = [gestureRecognizer locationInView:gestureRecognizer.view];
    if ([tableView indexPathForRowAtPoint:p]) {
        return YES;
    }
    return NO;
}

-(void)handleTap:(UITapGestureRecognizer *)tap
{
    if (UIGestureRecognizerStateEnded == tap.state) {
        
        UITableView *tableView = (UITableView *)tap.view;
        CGPoint p = [tap locationInView:tap.view];
        NSIndexPath* indexPath = [tableView indexPathForRowAtPoint:p];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        MGListCell *cell = (MGListCell*)[tableView cellForRowAtIndexPath:indexPath];
        CGPoint pointInCell = [tap locationInView:cell];
        
        if(CGRectContainsPoint(cell.buttonDirections.frame, pointInCell))
        {
            [self showDirections];
        }
    }
}

-(void)showDirections
{
    NSLog(@"Button Tapped");
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([realEstate.lat doubleValue], [realEstate.lon doubleValue]);
    NSString *pinTitle = realEstate.price;
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coord addressDictionary:@{(id)kABPersonAddressStreetKey: pinTitle}];
    
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    appDelegate.strTitle = pinTitle;
    appDelegate.placemark = placemark;
    appDelegate.coordinate = coord;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    ViewDirectionMap *viewDirectionVC = [[ViewDirectionMap alloc]init];
    
    viewDirectionVC.placemark = placemark;
    //viewDirectionVC.pinTitle = pinTitle;
    viewDirectionVC.coordinate = coord;
    
    viewDirectionVC = [storyboard instantiateViewControllerWithIdentifier:@"ViewDirectionMap"];
    [self.navigationController pushViewController:viewDirectionVC animated:YES];

}

#pragma mark - MAP Delegate

-(void) MGMapView:(MGMapView*)mapView didSelectMapAnnotation:(MGMapAnnotation*)mapAnnotation {
    
}

-(void) MGMapView:(MGMapView*)mapView didAccessoryTapped:(MGMapAnnotation*)mapAnnotation {
    
}

-(void) MGMapView:(MGMapView*)mapView didCreateMKPinAnnotationView:(MKPinAnnotationView*)mKPinAnnotationView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    UIImage* imageAnnotation = [UIImage imageNamed:MAP_ARROW_RIGHT_HOUSE_IMAGE];
    [imageView setImage:imageAnnotation];
    
    mKPinAnnotationView.pinColor = MKPinAnnotationColorGreen;
    
    imageView.frame = CGRectMake (0, 0, imageAnnotation.size.width, imageAnnotation.size.height);
    mKPinAnnotationView.rightCalloutAccessoryView = imageView;
    
    
}

-(void)didCLickButtonPhotos:(id)sender {
    
    NSArray* array = [CoreDataController getPhotosByRealEstateId:[realEstate.realestate_id intValue]];
    if(array == nil || array.count == 0)
        return;
    
    [self performSegueWithIdentifier:@"segueImageViewer"
                              sender:sender];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"segueImageViewer"]) {
        
        UIButton* button = (UIButton*)sender;
        ImageViewerController* imageViewer = (ImageViewerController*)[segue destinationViewController];
        imageViewer.imageArray = [CoreDataController getPhotosByRealEstateId:[realEstate.realestate_id intValue]];
        imageViewer.selectedIndex = (int)button.tag;
    }
}

-(void)didClickButtonFacebook:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *shareSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [shareSheet setInitialText:LOCALIZED(@"FACEBOOK_STATUS_SHARE")];
        [shareSheet addImage:_headerView.imgViewPhoto.image];
        
//        [shareSheet addURL:[NSURL URLWithString:_website]];
        
        [shareSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        if(!(shareSheet == nil))
            [self.view.window.rootViewController presentViewController:shareSheet animated:YES completion:nil];
    }
    else {
        [MGUtilities showAlertTitle:LOCALIZED(@"FACEBOOK_AUTHENTICATION_FAILED")
                            message:LOCALIZED(@"FACEBOOK_AUTHENTICATION_FAILED_MSG")];
    }
}

-(void)didClickButtonTwitter:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [tweetSheet setInitialText:LOCALIZED(@"TWITTER_STATUS_SHARE")];
        [tweetSheet addImage:_headerView.imgViewPhoto.image];
        
//        [shareSheet addURL:[NSURL URLWithString:_website]];
        
        [self.view.window.rootViewController presentViewController:tweetSheet animated:YES completion:nil];
    }
    else {
        [MGUtilities showAlertTitle:LOCALIZED(@"TWITTER_AUTHENTICATION_FAILED")
                            message:LOCALIZED(@"TWITTER_AUTHENTICATION_FAILED_MSG")];
    }
    
}

-(void)didClickButtonEmail:(id)sender {
    
    Agent* agent = [CoreDataController getAgentByAgentId:[realEstate.agent_id intValue]];
    
    if(agent.email == nil || [agent.email length] == 0 ) {
        [MGUtilities showAlertTitle:LOCALIZED(@"EMAIL_ERROR")
                            message:LOCALIZED(@"EMAIL_ERROR_MSG")];
        return;
    }
    
    if ([MFMailComposeViewController canSendMail]) {
        
        // set the sendTo address
        NSMutableArray *recipients = [[NSMutableArray alloc] initWithCapacity:1];
        [recipients addObject:agent.email];
        
        MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        
        [mailController setSubject:LOCALIZED(@"EMAIL_SUBJECT")];
        
        NSString* formattedBody = [NSString stringWithFormat:@"%@<br/>%@%d<br/>%@%@",
                                   LOCALIZED(@"EMAIL_BODY"),
                                   LOCALIZED(@"ID"),
                                   [realEstate.realestate_id intValue],
                                   LOCALIZED(@"ADDRESS"),
                                   realEstate.address];
        
        [mailController setMessageBody:formattedBody isHTML:YES];
        [mailController setToRecipients:recipients];
        
        if(DOES_SUPPORT_IOS7) {
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        WHITE_TEXT_COLOR, NSForegroundColorAttributeName, nil];
            
            [[mailController navigationBar] setTitleTextAttributes:attributes];
            [[mailController navigationBar ] setTintColor:[UIColor whiteColor]];
            
        }
        
        [self.view.window.rootViewController presentViewController:mailController animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
    else {
        [MGUtilities showAlertTitle:LOCALIZED(@"EMAIL_SERVICE_ERROR")
                            message:LOCALIZED(@"EMAIL_SERVICE_ERROR_MSG")];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    
	[self becomeFirstResponder];
    
	[controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)didClickButtonSMS:(id)sender {
    
    Agent *agent = [CoreDataController getAgentByAgentId:[realEstate.agent_id intValue]];
    
    if(agent == nil || agent.sms == nil || [agent.sms length] == 0 ) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"SMS_NO_ERROR")
                            message:LOCALIZED(@"SMS_NO_ERROR_DETAILS")];
        return;
    }
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText]) {
        
        NSString* formattedBody = [NSString stringWithFormat:@"%@ %@%d %@",
                                   LOCALIZED(@"REAL_ESTATE_INQUIRY"),
                                   LOCALIZED(@"ID"),
                                   [realEstate.realestate_id intValue],
                                   realEstate.address];
        
        controller.body = formattedBody;
        
        NSString* trim = [MGUtilities removeDelimetersInPhoneNo:agent.sms];
        
        if(agent.sms != nil || [agent.sms length] == 0)
            trim = [MGUtilities removeDelimetersInPhoneNo:agent.sms];
        
        controller.recipients = @[ trim, ];
        controller.messageComposeDelegate = self;
        controller.view.backgroundColor = BG_VIEW_COLOR;
        
        if(DOES_SUPPORT_IOS7) {
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        WHITE_TEXT_COLOR, NSForegroundColorAttributeName, nil];
            
            [[controller navigationBar] setTitleTextAttributes:attributes];
            [[controller navigationBar ] setTintColor:[UIColor whiteColor]];
            
        }
        
        
        [self.view.window.rootViewController presentViewController:controller animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
        
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller
                didFinishWithResult:(MessageComposeResult)result
{
    
    [self becomeFirstResponder];
	[controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)didClickButtonCall:(id)sender
{
    Agent* agent = [CoreDataController getAgentByAgentId:[realEstate.agent_id intValue]];

    if(agent.contact_no == nil || [agent.contact_no length] == 0 ) {
     
        [MGUtilities showAlertTitle:LOCALIZED(@"CONTACT_NO_SERVICE_ERROR")
                            message:LOCALIZED(@"CONTACT_NO_SERVICE_ERROR_MSG")];
        return;
    }
    
    NSString *phoneStr = [NSString stringWithFormat:@"tel:%@", agent.contact_no];
    NSURL *phoneURL = [[NSURL alloc] initWithString:phoneStr];
    
    if (!mCallWebview)
        
    mCallWebview = [[UIWebView alloc] init];
    [mCallWebview loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}


-(void)didClickButtonFave:(id)sender
{
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    Favorite* fave = [CoreDataController getFavoriteByRealEstateId:[realEstate.realestate_id intValue]];
    
    if(fave == nil) {
        [CoreDataController insertFavorite:[realEstate.realestate_id intValue]];
    }
    else {
        
        [context deleteObject:fave];
        
        NSError *error;
        if ([context hasChanges] && ![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    [self checkFave];
}

-(void)checkFave {
    
    Favorite* fave = [CoreDataController getFavoriteByRealEstateId:[realEstate.realestate_id intValue]];
    if(fave != nil)
        [_commandView.buttonFave setBackgroundImage:[UIImage imageNamed:STARRED_IMG] forState:UIControlStateNormal];
    else
        [_commandView.buttonFave setBackgroundImage:[UIImage imageNamed:UNSTAR_IMG] forState:UIControlStateNormal];
}

@end
