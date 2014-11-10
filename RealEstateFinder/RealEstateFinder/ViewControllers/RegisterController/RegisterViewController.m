

#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "AgentAddViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
{
    NSString *_strEmail;
}

@synthesize scrollViewRegister;

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
    
//    self.navigationItem.titleView = [MGUIAppearance createLogo:HEADER_LOGO];

    self.title = LOCALIZED(@"REGISTER");
    self.view.backgroundColor = BG_VIEW_COLOR;
    
    [MGUIAppearance enhanceNavBarController:self.navigationController
                               barTintColor:WHITE_TEXT_COLOR
                                  tintColor:WHITE_TEXT_COLOR
                             titleTextColor:WHITE_TEXT_COLOR];
    
    _registerView = [[MGRawView alloc] initWithNibName:@"RegisterView"];
    scrollViewRegister.frame = self.view.frame;
    
    _registerView.textFieldUsername.delegate = self;
    _registerView.textFieldPassword.delegate = self;
    _registerView.textFieldFullName.delegate = self;
    _registerView.textFieldEmail.delegate = self;
    
    _registerView.textFieldUsername.autocorrectionType = UITextAutocorrectionTypeNo;
    _registerView.textFieldPassword.autocorrectionType = UITextAutocorrectionTypeNo;
    _registerView.textFieldFullName.autocorrectionType = UITextAutocorrectionTypeNo;
    _registerView.textFieldEmail.autocorrectionType = UITextAutocorrectionTypeNo;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, _registerView.textFieldUsername.frame.size.height)];
    leftView.backgroundColor = _registerView.textFieldUsername.backgroundColor;
    _registerView.textFieldUsername.leftView = leftView;
    _registerView.textFieldUsername.leftViewMode = UITextFieldViewModeAlways;
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, _registerView.textFieldPassword.frame.size.height)];
    leftView.backgroundColor = _registerView.textFieldPassword.backgroundColor;
    _registerView.textFieldPassword.leftView = leftView;
    _registerView.textFieldPassword.leftViewMode = UITextFieldViewModeAlways;
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, _registerView.textFieldFullName.frame.size.height)];
    leftView.backgroundColor = _registerView.textFieldFullName.backgroundColor;
    _registerView.textFieldFullName.leftView = leftView;
    _registerView.textFieldFullName.leftViewMode = UITextFieldViewModeAlways;
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, _registerView.textFieldEmail.frame.size.height)];
    leftView.backgroundColor = _registerView.textFieldEmail.backgroundColor;
    _registerView.textFieldEmail.leftView = leftView;
    _registerView.textFieldEmail.leftViewMode = UITextFieldViewModeAlways;
    
    
    [scrollViewRegister addSubview:_registerView];
    scrollViewRegister.contentSize = _registerView.frame.size;
    
    [_registerView.buttonLogin addTarget:self
                                  action:@selector(didClickLoginButton:)
                        forControlEvents:UIControlEventTouchUpInside];
    
    [_registerView.buttonTwitter addTarget:self
                                    action:@selector(didClickLoginToTwitter:)
                          forControlEvents:UIControlEventTouchUpInside];
    
    [_registerView.buttonFb addTarget:self
                               action:@selector(didClickLoginToFacebook:)
                     forControlEvents:UIControlEventTouchUpInside];
    
    [_registerView.buttonRegister addTarget:self
                                     action:@selector(didClickRegister:)
                           forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    UIEdgeInsets inset = scrollViewRegister.contentInset;
    inset.bottom = NAV_BAR_OFFSET;
    scrollViewRegister.contentInset = inset;
}

-(void)keyboardDidShow:(id)sender {
    
    UIEdgeInsets inset = scrollViewRegister.contentInset;
    inset.bottom = 216;
    scrollViewRegister.contentInset = inset;
    
    inset = scrollViewRegister.scrollIndicatorInsets;
    inset.bottom = 216;
    scrollViewRegister.scrollIndicatorInsets = inset;
}

-(void)keyboardDidHide:(id)sender {
    
    UIEdgeInsets inset = scrollViewRegister.contentInset;
    inset.bottom = NAV_BAR_OFFSET;
    scrollViewRegister.contentInset = inset;
    
    inset = scrollViewRegister.scrollIndicatorInsets;
    inset.bottom = NAV_BAR_OFFSET;
    scrollViewRegister.scrollIndicatorInsets = inset;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _registerView.textFieldUsername) {
		[_registerView.textFieldUsername resignFirstResponder];
		[_registerView.textFieldPassword becomeFirstResponder];
	}
	else if (textField == _registerView.textFieldPassword) {
		[_registerView.textFieldPassword resignFirstResponder];
		[_registerView.textFieldFullName becomeFirstResponder];
	}
	else if (textField == _registerView.textFieldFullName) {
		[_registerView.textFieldFullName resignFirstResponder];
        [_registerView.textFieldEmail becomeFirstResponder];
	}
    else if (textField == _registerView.textFieldEmail) {
		[_registerView.textFieldEmail resignFirstResponder];
	}
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    BOOL isFound = YES;
    
    
    if(textField == _registerView.textFieldPassword) {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_"];

        for (int i = 0; i < [string length]; i++) {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c]) {
                isFound = NO;
            }
        }
        
    }
    
    if(textField == _registerView.textFieldUsername) {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefghijklmnopqrstuvwxyz_"];
        
        for (int i = 0; i < [string length]; i++) {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c]) {
                isFound = NO;
            }
        }
    }
    
    return ((newLength < MAX_CHARS_INPUT) && isFound) ? YES : NO;
}

-(void)didClickLoginButton:(id)sender {
    [self performSegueWithIdentifier:@"segueLogin" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didClickLoginToTwitter:(id)sender {
    
    if(![MGUtilities hasInternetConnection]) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"NETWORK_ERROR_DETAILS")];
        return;
    }
    
    UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
        
        NSString* twitterId = [[FHSTwitterEngine sharedEngine] authenticatedID];
        NSDictionary *data = [[FHSTwitterEngine sharedEngine] getUserSettings];
        NSString* name = [data valueForKey:@"screen_name"];
        NSString* full_name = [NSString stringWithFormat:@"@%@", name];
        [self registerViaSocial:twitterId isFacebook:NO name:full_name email:@""];
    }];
    
    [self presentViewController:loginController animated:YES completion:nil];
}

-(IBAction)didClickCancelLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didClickLoginToFacebook:(id)sender {
    
    if(![MGUtilities hasInternetConnection]) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"NETWORK_ERROR_DETAILS")];
        return;
    }
    
    AppDelegate* appDelegate = [AppDelegate instance];
    
    //TODO: Ambiguos fuctionality (clearing the previously stored session.).
    [appDelegate.session closeAndClearTokenInformation];
    
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        NSArray *permissions = [NSArray arrayWithObjects:@"email", nil];
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session,
           FBSessionState state, NSError *error) {
             
             [self sessionStateChanged:session state:state error:error];
         }];
    }
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error {
    
    switch (state) {
        case FBSessionStateOpen: {
            
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                 
                 if (!error) {
                     //error
                     NSString* facebookId = [user valueForKey:@"id"];
                     NSString* name = [user valueForKey:@"name"];
                     NSString* email = [user valueForKey:@"email"];
                     [self registerViaSocial:facebookId isFacebook:YES name:name email:email];
                 }
                 
             }];
        }
            
        case FBSessionStateClosed: { }
            
        case FBSessionStateClosedLoginFailed: { }
        
        case FBSessionStateCreatedOpening: { }
            
        case FBSessionStateCreatedTokenLoaded: { }
        
        case FBSessionStateOpenTokenExtended: { }
            
        case FBSessionStateCreated: { }
    }
}





-(void)didClickRegister:(id)sender {
    
    if(![MGUtilities hasInternetConnection]) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"NETWORK_ERROR_DETAILS")];
        return;
    }
    
    NSString* username = [_registerView.textFieldUsername text];
    NSString* password = [_registerView.textFieldPassword text];
    NSString* fullname = [_registerView.textFieldFullName text];
    NSString* email = [_registerView.textFieldEmail text];
    
    if(username.length == 0 || password.length == 0 || fullname.length == 0 || email.length == 0) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"REGISTER_ERROR")
                            message:LOCALIZED(@"ALL_FIELDS_REQUIRED_ERROR_DETAILS")];
        return;
    }
    
    if(password.length < 7) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"REGISTER_ERROR")
                            message:LOCALIZED(@"PASSWORD_LENGTH_ERROR_DETAILS")];
        return;
    }
    
    if(![MGUtilities validateEmail:email]) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"REGISTER_ERROR")
                            message:LOCALIZED(@"EMAIL_ADDRESS_ERROR_DETAILS")];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = LOCALIZED(@"REGISTERING_USER");
    
    [self.view addSubview:hud];
    [self.view setUserInteractionEnabled:NO];
    
    NSURL *url = [NSURL URLWithString:REGISTER_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            username, @"username",
                            password, @"password",
                            fullname, @"full_name",
                            email, @"email",
                            nil];
    
    [httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        [hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"REGISTER_SYNC = %@", responseStr);
        
        NSDictionary* dictUser = [json objectForKey:@"user_info"];
        NSDictionary* dictStatus = [json objectForKey:@"status"];
        
        if([[dictStatus valueForKey:@"status_code"] isEqualToString:STATUS_SUCCESS]) {
            
            if(dictUser != nil) {
                
                UserSession* session = [UserSession new];
                session.facebookId = [dictUser valueForKey:@"facebook_id"];
                session.fullName = [dictUser valueForKey:@"full_name"];
                session.loginHash = [dictUser valueForKey:@"login_hash"];
                session.twitterId = [dictUser valueForKey:@"twitter_id"];
                session.userId = [dictUser valueForKey:@"user_id"];
                session.userName = [dictUser valueForKey:@"username"];
                session.email = [dictUser valueForKey:@"email"];
                
                [UserAccessSession storeUserSession:session];
                
                [self performSegueWithIdentifier:@"segueAgentCreationFromRegister" sender:session];
            }
            else {
                [MGUtilities showAlertTitle:LOCALIZED(@"REGISTER_ERROR")
                                    message:LOCALIZED(@"SIGNUP_ERROR_DETAILS")];
            }
            
        }
        else {
            [MGUtilities showAlertTitle:LOCALIZED(@"REGISTER_ERROR") message:[dictStatus valueForKey:@"status_text"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        
        [hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"SIGNUP_CONNECTING_ERROR")];
    }];
}


-(void)registerViaSocial:(NSString*)anyId isFacebook:(BOOL)isFacebook name:(NSString*)name email:(NSString*)email{
    
    if(![MGUtilities hasInternetConnection]) {
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"NETWORK_ERROR_DETAILS")];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = LOCALIZED(@"REGISTERING_USER");
    
    [self.view addSubview:hud];
    [self.view setUserInteractionEnabled:NO];
    
    NSURL *url = [NSURL URLWithString:REGISTER_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = nil;
    
    if(isFacebook) {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  anyId, @"facebook_id",
                  name, @"full_name",
                  email, @"email",
                  nil];
    }
    else {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  anyId, @"twitter_id",
                  name, @"full_name",
                  email, @"email",
                  nil];
    }
    
    [httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        [hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"responseStr = %@", responseStr);
        
        NSDictionary* dictUser = [json objectForKey:@"user_info"];
        NSDictionary* dictStatus = [json objectForKey:@"status"];
        NSDictionary* dictAgent = [json objectForKey:@"agent_info"];
        
        if([[dictStatus valueForKey:@"status_code"] isEqualToString:STATUS_SUCCESS]) {
            
            if(dictUser != nil) {
                
                UserSession* session = [UserSession new];
                session.facebookId = [dictUser valueForKey:@"facebook_id"];
                session.fullName = [dictUser valueForKey:@"full_name"];
                session.loginHash = [dictUser valueForKey:@"login_hash"];
                session.twitterId = [dictUser valueForKey:@"twitter_id"];
                session.userId = [dictUser valueForKey:@"user_id"];
                session.userName = [dictUser valueForKey:@"username"];
                session.email = [dictUser valueForKey:@"email"];
                
                [UserAccessSession storeUserSession:session];
                
            }
            if(![dictAgent isEqual:[NSNull null]]) {
                
                AgentSession* session = [AgentSession new];
                session.address = [dictAgent valueForKey:@"dealer_id"];
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
                session.user_id = [dictUser valueForKey:@"user_id"];
                
                [UserAccessSession storeAgentSession:session];
            }
            
            
            
            if( ![dictUser isEqual:[NSNull null]] && ![dictAgent isEqual:[NSNull null]] ) {
                
                [self performSelector:@selector(delaySocial:)
                           withObject:nil
                           afterDelay:0.5];
            }
            else {
                
                UserSession* session = [UserAccessSession getUserSession];
                
                [self performSegueWithIdentifier:@"segueAgentCreationFromRegister"
                                          sender:session];
            }
            
        }
        else {
            
            [MGUtilities showAlertTitle:LOCALIZED(@"LOGIN_ERROR")
                                message:[dictStatus valueForKey:@"status_text"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        
        [hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"SIGNUP_CONNECTING_ERROR")];
    }];
}

-(void)delaySocial:(id)sender	 {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"segueAgentCreation"]) {
        
    }
    if([[segue identifier] isEqualToString:@"segueAgentCreationFromRegister"]) {
        AgentAddViewController*agent=segue.destinationViewController;
        agent.usersession= [UserAccessSession getUserSession];
    }
    
}
 

@end
