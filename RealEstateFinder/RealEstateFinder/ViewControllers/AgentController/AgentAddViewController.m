//
//  AgentAddViewController.m
//  RealEstateFinder
//
//  
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "AgentAddViewController.h"
#import "AppDelegate.h"

@interface AgentAddViewController ()

@end

@implementation AgentAddViewController

@synthesize scrollViewMain;
@synthesize arrayPhotos;

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
    //self.navigationItem.hidesBackButton = YES;
    
    //*>    Getting user_email from session.
    NSLog(@"Email Address: %@", _usersession.email);
    NSLog(@"Username: %@", _usersession.userName);
    NSLog(@"Name: %@", _usersession.fullName);
    
    [MGUIAppearance enhanceNavBarController:self.navigationController
                               barTintColor:WHITE_TEXT_COLOR
                                  tintColor:WHITE_TEXT_COLOR
                             titleTextColor:WHITE_TEXT_COLOR];
    
    _agentView = [[MGRawView alloc] initWithFrame:scrollViewMain.frame nibName:@"AgentAddView"];
    
    [scrollViewMain addSubview:_agentView];
    scrollViewMain.contentSize = _agentView.frame.size;
    
    
    [_agentView.buttonNext addTarget:self
                                  action:@selector(didClickNextButton:)
                        forControlEvents:UIControlEventTouchUpInside];
    
    [_agentView.buttonPhotos addTarget:self
                                    action:@selector(didClickButtonPhotos:)
                          forControlEvents:UIControlEventTouchUpInside];
    
    _agentView.textFieldName.delegate = self;
    _agentView.textFieldCompany.delegate = self;
    _agentView.textFieldAddress.delegate = self;
    _agentView.textFieldContactNo.delegate = self;
    _agentView.textFieldZipCode.delegate = self;
    _agentView.textFieldCountry.delegate = self;
    _agentView.textFieldEmail.delegate = self;
    _agentView.textFieldSMSNo.delegate = self;
    _agentView.textFieldTwitter.delegate = self;
    _agentView.textFieldFb.delegate = self;
    _agentView.textFieldLinkedIn.delegate = self;
    
    [_agentView.labelName setTextColor:THEME_GREEN_TINT_COLOR];
    [_agentView.labelCompany setTextColor:THEME_GREEN_TINT_COLOR];
    [_agentView.labelAddress setTextColor:THEME_GREEN_TINT_COLOR];
    [_agentView.labelContactNo setTextColor:THEME_GREEN_TINT_COLOR];
    [_agentView.labelZipCode setTextColor:THEME_GREEN_TINT_COLOR];
    [_agentView.labelCountry setTextColor:THEME_GREEN_TINT_COLOR];
    [_agentView.labelEmail setTextColor:THEME_GREEN_TINT_COLOR];
    [_agentView.labelSMSNo setTextColor:THEME_GREEN_TINT_COLOR];
    [_agentView.labelTwitter setTextColor:THEME_GREEN_TINT_COLOR];
    [_agentView.labelFb setTextColor:THEME_GREEN_TINT_COLOR];
    [_agentView.labelLinkedIn setTextColor:THEME_GREEN_TINT_COLOR];
    [_agentView.labelPhotos setTextColor:THEME_GREEN_TINT_COLOR];
    
    
    [_agentView.textFieldName setPlaceholder:LOCALIZED(@"NAME")];
    [_agentView.textFieldCompany setPlaceholder:LOCALIZED(@"COMPANY")];
    [_agentView.textFieldAddress setPlaceholder:LOCALIZED(@"ADDRESS")];
    [_agentView.textFieldContactNo setPlaceholder:LOCALIZED(@"CONTACT_NO")];
    [_agentView.textFieldZipCode setPlaceholder:LOCALIZED(@"ZIPCODE")];
    [_agentView.textFieldCountry setPlaceholder:LOCALIZED(@"COUNTRY")];
    [_agentView.textFieldEmail setPlaceholder:LOCALIZED(@"EMAIL")];
    [_agentView.textFieldSMSNo setPlaceholder:LOCALIZED(@"SMS_NO")];
    [_agentView.textFieldTwitter setPlaceholder:LOCALIZED(@"TWITTER")];
    [_agentView.textFieldFb setPlaceholder:LOCALIZED(@"FACEBOOK")];
    [_agentView.textFieldLinkedIn setPlaceholder:LOCALIZED(@"LINKEDIN")];
    
    _agentView.textFieldName.autocorrectionType = UITextAutocorrectionTypeNo;
    _agentView.textFieldCompany.autocorrectionType = UITextAutocorrectionTypeNo;
    _agentView.textFieldAddress.autocorrectionType = UITextAutocorrectionTypeNo;
    _agentView.textFieldContactNo.autocorrectionType = UITextAutocorrectionTypeNo;
    _agentView.textFieldZipCode.autocorrectionType = UITextAutocorrectionTypeNo;
    _agentView.textFieldCountry.autocorrectionType = UITextAutocorrectionTypeNo;
    _agentView.textFieldEmail.autocorrectionType = UITextAutocorrectionTypeNo;
    _agentView.textFieldSMSNo.autocorrectionType = UITextAutocorrectionTypeNo;
    _agentView.textFieldTwitter.autocorrectionType = UITextAutocorrectionTypeNo;
    _agentView.textFieldFb.autocorrectionType = UITextAutocorrectionTypeNo;
    _agentView.textFieldLinkedIn.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [_agentView.labelName setText:LOCALIZED(@"NAME")];
    [_agentView.labelCompany setText:LOCALIZED(@"COMPANY")];
    [_agentView.labelAddress setText:LOCALIZED(@"ADDRESS")];
    [_agentView.labelContactNo setText:LOCALIZED(@"CONTACT_NO")];
    [_agentView.labelZipCode setText:LOCALIZED(@"ZIPCODE")];
    [_agentView.labelCountry setText:LOCALIZED(@"COUNTRY")];
    [_agentView.labelEmail setText:LOCALIZED(@"EMAIL")];
    [_agentView.labelSMSNo setText:LOCALIZED(@"SMS_NO")];
    [_agentView.labelTwitter setText:LOCALIZED(@"TWITTER")];
    [_agentView.labelFb setText:LOCALIZED(@"FACEBOOK")];
    [_agentView.labelLinkedIn setText:LOCALIZED(@"LINKEDIN")];
    [_agentView.labelPhotos setText:LOCALIZED(@"PHOTOS")];
    
    [_agentView.label1 setText:LOCALIZED(@"CREATE_AGENT_HEADER_1")];
    
    
    [_agentView.buttonNext setTitle:LOCALIZED(@"CREATE_BUTTON_AGENT")
                                forState:UIControlStateNormal];
    
    [_agentView.buttonNext setTitle:LOCALIZED(@"CREATE_BUTTON_AGENT")
                                forState:UIControlStateSelected];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    
    UIEdgeInsets inset = scrollViewMain.contentInset;
    inset.bottom = NAV_BAR_OFFSET_DEFAULT;
    scrollViewMain.contentInset = inset;
}

- (void)viewWillAppear:(BOOL)animated
{
    _agentView.textFieldEmail.text = _usersession.email;
    _agentView.textFieldName.text = _usersession.fullName;
}

-(void)keyboardDidShow:(id)sender
{
    if ([_agentView.textFieldContactNo isFirstResponder])
    {
        UIEdgeInsets inset = scrollViewMain.contentInset;
        inset.bottom = 272;
        scrollViewMain.contentInset = inset;
        
        inset = scrollViewMain.scrollIndicatorInsets;
        inset.bottom = 272;
        scrollViewMain.scrollIndicatorInsets = inset;
    }
    else if ([_agentView.textFieldSMSNo isFirstResponder])
    {
        UIEdgeInsets inset = scrollViewMain.contentInset;
        inset.bottom = 272;
        scrollViewMain.contentInset = inset;
        
        inset = scrollViewMain.scrollIndicatorInsets;
        inset.bottom = 272;
        scrollViewMain.scrollIndicatorInsets = inset;
    }
    else
    {
        UIEdgeInsets inset = scrollViewMain.contentInset;
        inset.bottom = 216;
        scrollViewMain.contentInset = inset;
        
        inset = scrollViewMain.scrollIndicatorInsets;
        inset.bottom = 216;
        scrollViewMain.scrollIndicatorInsets = inset;
    }
}

-(void)keyboardDidHide:(id)sender {
    
    UIEdgeInsets inset = scrollViewMain.contentInset;
    inset.bottom = NAV_BAR_OFFSET;
    scrollViewMain.contentInset = inset;
    
    inset = scrollViewMain.scrollIndicatorInsets;
    inset.bottom = NAV_BAR_OFFSET;
    scrollViewMain.scrollIndicatorInsets = inset;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIToolbar *keyboardaAdditionalButtonView = [[UIToolbar alloc] init];
    keyboardaAdditionalButtonView.translucent = YES;
    [keyboardaAdditionalButtonView sizeToFit];
    [self.view addSubview:keyboardaAdditionalButtonView];
    
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

- (IBAction)doneClicked:(id)sender
{
    [_agentView.textFieldName resignFirstResponder];
    [_agentView.textFieldCompany resignFirstResponder];
    [_agentView.textFieldAddress resignFirstResponder];
    [_agentView.textFieldContactNo resignFirstResponder];
    [_agentView.textFieldZipCode resignFirstResponder];
    [_agentView.textFieldCountry resignFirstResponder];
    [_agentView.textFieldEmail resignFirstResponder];
    [_agentView.textFieldSMSNo resignFirstResponder];
    [_agentView.textFieldTwitter resignFirstResponder];
    [_agentView.textFieldFb resignFirstResponder];
    [_agentView.textFieldLinkedIn resignFirstResponder];
}

- (IBAction)nextClicked:(id)sender
{
    if ([_agentView.textFieldContactNo isFirstResponder])
    {
        [_agentView.textFieldZipCode becomeFirstResponder];
    }
    else if ([_agentView.textFieldSMSNo isFirstResponder])
    {
        [_agentView.textFieldTwitter becomeFirstResponder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _agentView.textFieldName) {
		[_agentView.textFieldName resignFirstResponder];
		[_agentView.textFieldCompany becomeFirstResponder];
	}
	else if (textField == _agentView.textFieldCompany) {
		[_agentView.textFieldCompany resignFirstResponder];
		[_agentView.textFieldAddress becomeFirstResponder];
	}
	else if (textField == _agentView.textFieldAddress) {
		[_agentView.textFieldAddress resignFirstResponder];
        [_agentView.textFieldContactNo becomeFirstResponder];
	}
    else if (textField == _agentView.textFieldZipCode) {
		[_agentView.textFieldZipCode resignFirstResponder];
        [_agentView.textFieldCountry becomeFirstResponder];
	}
    else if (textField == _agentView.textFieldCountry) {
		[_agentView.textFieldCountry resignFirstResponder];
        [_agentView.textFieldEmail becomeFirstResponder];
	}
    else if (textField == _agentView.textFieldEmail) {
		[_agentView.textFieldEmail resignFirstResponder];
        [_agentView.textFieldSMSNo becomeFirstResponder];
	}
    else if (textField == _agentView.textFieldTwitter) {
		[_agentView.textFieldTwitter resignFirstResponder];
        [_agentView.textFieldFb becomeFirstResponder];
	}
    else if (textField == _agentView.textFieldFb) {
		[_agentView.textFieldFb resignFirstResponder];
        [_agentView.textFieldLinkedIn becomeFirstResponder];
	}
    else if (textField == _agentView.textFieldLinkedIn) {
		[_agentView.textFieldLinkedIn resignFirstResponder];
     
	}
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > MAX_CHARS_INPUT) ? NO : YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didClickButtonPhotos:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Extra_iPhone" bundle:nil];
    AgentImagesViewController* vc;
    vc = [storyboard instantiateViewControllerWithIdentifier:@"storyboardImages"];
    vc.agentPhotosDelegate = self;
    vc.arrayPhotos = arrayPhotos;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) returnPhotoArrays:(NSMutableArray *)photos {
    
    arrayPhotos = [NSMutableArray arrayWithArray:photos];
    NSString* photoCount = [NSString stringWithFormat:@"%d %@", (int)arrayPhotos.count, LOCALIZED(@"PHOTOS_INFO")];
    [_agentView.labelInfo setText:photoCount];
}

-(void)returnPhotoArrayFromFile:(NSMutableArray *)photos {
    
}

#pragma mark - Selector

-(void) didClickNextButton:(id)sender {
    
    if(![MGUtilities hasInternetConnection]) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"NETWORK_ERROR_DETAILS")];
        
        return;
    }
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSString* className = NSStringFromClass([Agent class]);
    NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
    Agent* agent = (Agent*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    
    agent.name = [_agentView.textFieldName text];
    agent.company = [_agentView.textFieldCompany text];
    agent.address = [_agentView.textFieldAddress text];
    agent.contact_no = [_agentView.textFieldContactNo text];
    agent.zipcode = [_agentView.textFieldZipCode text];
    agent.country = [_agentView.textFieldCountry text];
    agent.email = [_agentView.textFieldEmail text];
    agent.sms = [_agentView.textFieldSMSNo text];
    agent.twitter = [_agentView.textFieldTwitter text];
    agent.fb = [_agentView.textFieldFb text];
    agent.linkedin = [_agentView.textFieldLinkedIn text];
    
    if([agent.name length] == 0 ||
       [agent.email length] == 0 ||
       [agent.address length] == 0 ||
       [agent.contact_no length] == 0 ||
       [agent.sms length] == 0) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"FIELD_REQUIRED_ERROR")
                            message:LOCALIZED(@"FIELD_REQUIRED_ERROR_DETAILS_AGENT")];
        return;
    }
    
    [self startSync:agent];
}


-(void) startSync:(id)sender {
    
    [self.navigationItem setHidesBackButton:YES];
    
    Agent* agent = (Agent*)sender;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = LOCALIZED(@"CREATING_AGENT");
    
    [self.view addSubview:hud];
    [self.view setUserInteractionEnabled:NO];
    
    NSURL *url = [NSURL URLWithString:AGENT_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    agent.name = [_agentView.textFieldName text];
    agent.company = [_agentView.textFieldCompany text];
    agent.address = [_agentView.textFieldAddress text];
    agent.contact_no = [_agentView.textFieldContactNo text];
    agent.zipcode = [_agentView.textFieldZipCode text];
    agent.country = [_agentView.textFieldCountry text];
    agent.email = [_agentView.textFieldEmail text];
    agent.sms = [_agentView.textFieldSMSNo text];
    agent.twitter = [_agentView.textFieldTwitter text];
    agent.fb = [_agentView.textFieldFb text];
    agent.linkedin = [_agentView.textFieldLinkedIn text];
    
    UserSession* session = [UserAccessSession getUserSession];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            
                            session.userId, @"user_id",
                            session.loginHash, @"login_hash",
                            agent.name, @"name",
                            agent.company, @"company",
                            agent.address, @"address",
                            agent.contact_no, @"contact_no",
                            agent.zipcode, @"zipcode",
                            agent.country, @"country",
                            agent.email, @"email",
                            agent.sms, @"sms",
                            agent.twitter, @"twitter",
                            agent.fb, @"fb",
                            agent.linkedin, @"linkedin",
                            nil];
    
    [httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"AGENT_SYNC = %@", responseStr);
        
        NSDictionary* dictAgent = [json objectForKey:@"agent_info"];
        NSDictionary* dictStatus = [json objectForKey:@"status"];
        
        if([[dictStatus valueForKey:@"status_code"] isEqualToString:STATUS_SUCCESS]) {
            
            if(![dictAgent isEqual:[NSNull null]]) {
                
                AgentSession* session = [AgentSession new];
                session.address = [dictAgent valueForKey:@"address"];
                session.agent_id = [dictAgent valueForKey:@"agent_id"];
                session.contact_no = [dictAgent valueForKey:@"contact_no"];
                session.country = [dictAgent valueForKey:@"country"];
                session.created_at = [dictAgent valueForKey:@"created_at"];
                session.email = [dictAgent valueForKey:@"email"];
                session.name = [dictAgent valueForKey:@"name"];
                session.sms = [dictAgent valueForKey:@"sms"];
                session.updated_at = [dictAgent valueForKey:@"updated_at"];
                session.zipcode = [dictAgent valueForKey:@"zipcode"];
                session.photo_url = [dictAgent valueForKey:@"photo_url"];
                session.thumb_url = [dictAgent valueForKey:@"thumb_url"];
                session.twitter = [dictAgent valueForKey:@"twitter"];
                session.fb = [dictAgent valueForKey:@"fb"];
                session.linkedin = [dictAgent valueForKey:@"linkedin"];
                session.company = [dictAgent valueForKey:@"company"];
                session.user_id = [dictAgent valueForKey:@"user_id"];
                
                [UserAccessSession storeAgentSession:session];
                [CoreDataController insertAgentFromDictionary:dictAgent];
            }
            
            if(arrayPhotos.count > 0)
                [self syncPhotos];
            else
                [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [MGUtilities showAlertTitle:LOCALIZED(@"UNSYNC_CONNECTION_ERROR")
                                message:[dictStatus valueForKey:@"status_text"]];
            
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

-(void)syncPhotos {
    
    _index = 0;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = LOCALIZED(@"SYNCING_PHOTOS");
    
    [self.view addSubview:hud];
    [self.view setUserInteractionEnabled:NO];
    [self startSyncPhoto:hud index:_index];
}

-(NSData*)CompressImageData:(UIImage*)croppedImage
{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    
    NSData *imageData = UIImageJPEGRepresentation(croppedImage, compression);
    
    NSData *data1 = UIImagePNGRepresentation(croppedImage);
    
    NSLog(@"Real Photo galary image from size in MB :%.2f",(float)data1.length/1024.0f/1024.0f);
    
    NSLog(@"imagedata length : %lu",(unsigned long)imageData.length);
    
    while ([imageData length] > 100000 && compression > maxCompression)
    {
        compression -= 0.10;
        imageData = UIImageJPEGRepresentation(croppedImage, compression);
        NSLog(@"Compress : %lu",(unsigned long)imageData.length);
        NSLog(@"Compress Photo galary image from size in MB :%.2f",(float)imageData.length/1024.0f/1024.0f);
    }
    return imageData;
}

-(void) startSyncPhoto:(MBProgressHUD*)hud index:(int)index {
    
    hud.labelText = [NSString stringWithFormat:@"%@ (%d/%lu)",
                     LOCALIZED(@"SYNCING_PHOTOS"),
                     index + 1,
                     (unsigned long)arrayPhotos.count];
    
    Photo* photo = [arrayPhotos objectAtIndex:index];
    
    AgentSession* agentSession = [UserAccessSession getAgentSession];
    
    NSURL *url = [NSURL URLWithString:FILE_UPLOADER_AGENT_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    UserSession* session = [UserAccessSession getUserSession];
    NSDictionary *params = nil;
    
    
    if(photo.isImagePicked) {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  session.userId, @"user_id",
                  session.loginHash, @"login_hash",
                  agentSession.agent_id, @"agent_id",
                  nil];
    }
    else {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  session.userId, @"user_id",
                  session.loginHash, @"login_hash",
                  photo.thumb_url, @"thumb_url",
                  photo.photo_url, @"photo_url",
                  agentSession.agent_id, @"agent_id",
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
            NSString* fullNamePhoto = [photo.photo_url lastPathComponent];
            
            [formData appendPartWithFileData:dataThumb
                                        name:@"thumb_file"
                                    fileName:fullNameThumb
                                    mimeType:@"image/jpeg"];
            
            [formData appendPartWithFileData:dataPhoto
                                        name:@"photo_file"
                                    fileName:fullNamePhoto
                                    mimeType:@"image/jpeg"];
        }
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"PHOTO_AGENT_SYNC = %@", responseStr);
        
        NSDictionary* dictStatus = [json objectForKey:@"status"];
        NSDictionary* dictPhoto = [json objectForKey:@"photo_agent_info"];
        
        if([[dictStatus valueForKey:@"status_code"] isEqualToString:STATUS_SUCCESS]) {
            
            if(photo.isImagePicked) {
                [MGFileManager deleteImageAtFilePath:photo.thumb_url];
                [MGFileManager deleteImageAtFilePath:photo.photo_url];
            }
            
            [CoreDataController updatePhotoAgentFromDictionary:dictPhoto];
            
            if(index < arrayPhotos.count - 1) {
                
                ++_index;
                [self startSyncPhoto:hud index:_index];
            }
            else {
                [hud removeFromSuperview];
                [self.view setUserInteractionEnabled:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
        else {
            [MGUtilities showAlertTitle:LOCALIZED(@"UNSYNC_CONNECTION_ERROR")
                                message:[dictStatus valueForKey:@"status_text"]];
            
            [self.navigationItem setHidesBackButton:NO];
            
            [hud removeFromSuperview];
            [self.view setUserInteractionEnabled:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
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

@end
