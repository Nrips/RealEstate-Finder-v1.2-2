

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize scrollViewLogin;

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
    
    self.title = LOCALIZED(@"LOGIN");
    self.view.backgroundColor = BG_VIEW_COLOR;
    
    [MGUIAppearance enhanceNavBarController:self.navigationController
                               barTintColor:WHITE_TEXT_COLOR
                                  tintColor:WHITE_TEXT_COLOR
                             titleTextColor:WHITE_TEXT_COLOR];
    
    _loginView = [[MGRawView alloc] initWithFrame:scrollViewLogin.frame nibName:@"LoginView"];
    
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, _loginView.textFieldUsername.frame.size.height)];
    leftView.backgroundColor = _loginView.textFieldUsername.backgroundColor;
    _loginView.textFieldUsername.leftView = leftView;
    _loginView.textFieldUsername.leftViewMode = UITextFieldViewModeAlways;
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, _loginView.textFieldPassword.frame.size.height)];
    leftView.backgroundColor = _loginView.textFieldPassword.backgroundColor;
    _loginView.textFieldPassword.leftView = leftView;
    _loginView.textFieldPassword.leftViewMode = UITextFieldViewModeAlways;
    
    [scrollViewLogin addSubview:_loginView];
    scrollViewLogin.contentSize = _loginView.frame.size;
    
    [_loginView.buttonLogin addTarget:self
                               action:@selector(didClickLoginButton:)
                     forControlEvents:UIControlEventTouchUpInside];
    
    
    _loginView.textFieldPassword.delegate = self;
    _loginView.textFieldUsername.delegate = self;
    
    _loginView.textFieldUsername.autocorrectionType = UITextAutocorrectionTypeNo;
    _loginView.textFieldPassword.autocorrectionType = UITextAutocorrectionTypeNo;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    UIEdgeInsets inset = scrollViewLogin.contentInset;
    inset.bottom = NAV_BAR_OFFSET;
    scrollViewLogin.contentInset = inset;
}

-(void)keyboardDidShow:(id)sender {
    
    UIEdgeInsets inset = scrollViewLogin.contentInset;
    inset.bottom = 216;
    scrollViewLogin.contentInset = inset;
    
    inset = scrollViewLogin.scrollIndicatorInsets;
    inset.bottom = 216;
    scrollViewLogin.scrollIndicatorInsets = inset;
}

-(void)keyboardDidHide:(id)sender {
    
    UIEdgeInsets inset = scrollViewLogin.contentInset;
    inset.bottom = NAV_BAR_OFFSET;
    scrollViewLogin.contentInset = inset;
    
    inset = scrollViewLogin.scrollIndicatorInsets;
    inset.bottom = NAV_BAR_OFFSET;
    scrollViewLogin.scrollIndicatorInsets = inset;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _loginView.textFieldUsername) {
		[_loginView.textFieldUsername resignFirstResponder];
		[_loginView.textFieldPassword becomeFirstResponder];
	}
	else if (textField == _loginView.textFieldPassword) {
		[_loginView.textFieldPassword resignFirstResponder];
        [self didClickLoginButton:textField];
	}
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    BOOL isFound = YES;
    
    if(textField == _loginView.textFieldPassword) {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_"];
        
        for (int i = 0; i < [string length]; i++) {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c]) {
                isFound = NO;
            }
        }
        
    }
    
    if(textField == _loginView.textFieldUsername) {
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)didClickLoginButton:(id)sender {
    
    if(![MGUtilities hasInternetConnection]) {
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"NETWORK_ERROR_DETAILS")];
        return;
    }
    
    NSString* username = [_loginView.textFieldUsername text];
    NSString* password = [_loginView.textFieldPassword text];
    
    if(username.length == 0 || password.length == 0) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"REGISTER_ERROR")
                            message:LOCALIZED(@"REGISTER_ERROR_DETAILS")];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = LOCALIZED(@"LOGGING_IN");
    
    [self.view addSubview:hud];
    [self.view setUserInteractionEnabled:NO];
    
    NSURL *url = [NSURL URLWithString:LOGIN_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            username, @"username",
                            password, @"password",
                            nil];
    
    [httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"LOGIN_SYNC = %@", responseStr);
        
        NSDictionary* dictAgent = [json objectForKey:@"agent_info"];
        NSDictionary* dictUser = [json objectForKey:@"user_info"];
        NSDictionary* dictStatus = [json objectForKey:@"status"];
        
        NSLog(@"dictAgent:%@ dictUser:%@ dictStatus:%@", dictAgent, dictUser, dictStatus);
        
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
            }
            
            
            if( ![dictUser isEqual:[NSNull null]] && ![dictAgent isEqual:[NSNull null]] ) {
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                
                UserSession* session = [UserAccessSession getUserSession];
                
                [self performSegueWithIdentifier:@"segueAgentCreationFromLogin"
                                          sender:session];
            }
            
        }
        else {
            
            [MGUtilities showAlertTitle:LOCALIZED(@"LOGIN_ERROR")
                                message:[dictStatus valueForKey:@"status_text"]];
        }
        
        [hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        
        [hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"LOGIN_CONNECTING_ERROR")];
        
    }];
}


@end
