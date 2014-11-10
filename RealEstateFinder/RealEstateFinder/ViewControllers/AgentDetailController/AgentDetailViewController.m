//
//  AgentDetailViewController.m
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "AgentDetailViewController.h"
#import "AgentListingViewController.h"

@interface AgentDetailViewController ()

@end

@implementation AgentDetailViewController

@synthesize scrollViewMain;
@synthesize agent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationItem.titleView = [MGUIAppearance createLogo:HEADER_LOGO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    self.navigationItem.titleView = [MGUIAppearance createLogo:HEADER_LOGO];
    self.view.backgroundColor = BG_VIEW_COLOR;
    
    [MGUIAppearance enhanceNavBarController:self.navigationController
                               barTintColor:WHITE_TEXT_COLOR
                                  tintColor:WHITE_TEXT_COLOR
                             titleTextColor:WHITE_TEXT_COLOR];
    
    
    _agentDetailView = [[MGRawView alloc] initWithNibName:@"AgentDetailView"];
    
    scrollViewMain.contentSize = _agentDetailView.frame.size;
    [scrollViewMain addSubview:_agentDetailView];
    
    _agentDetailView.labelCompany.text = LOCALIZED(@"COMPANY");
    _agentDetailView.labelContactNo.text = LOCALIZED(@"CONTACT_NO");
    _agentDetailView.labelEmail.text = LOCALIZED(@"EMAIL");
    _agentDetailView.labelSMSNo.text = LOCALIZED(@"SMS_NO");
    _agentDetailView.labelFb.text = LOCALIZED(@"FACEBOOK");
    _agentDetailView.labelTwitter.text = LOCALIZED(@"TWITTER");
    _agentDetailView.labelLinkedIn.text = LOCALIZED(@"LINKEDIN");
    _agentDetailView.labelAddress.text = LOCALIZED(@"AGENT_ADDRESS");
    _agentDetailView.label1.text = LOCALIZED(@"PROFILE_DETAILS");
    _agentDetailView.labelDateAdded.text = LOCALIZED(@"DATE_ADDED");

    
    _agentDetailView.labelCompanyVal.text = agent.company;
    _agentDetailView.labelContactNoVal.text = agent.contact_no;
    _agentDetailView.labelEmailVal.text = agent.email;
    _agentDetailView.labelSMSNoVal.text = agent.sms;
    _agentDetailView.labelFbVal.text = agent.fb;
    _agentDetailView.labelTwitterVal.text = agent.twitter;
    _agentDetailView.labelLinkedInVal.text = agent.linkedin;
    _agentDetailView.topLeftLabelAddress.text = agent.address;
    _agentDetailView.labelName.text = agent.name;
    
    double createdAt = [agent.created_at doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    _agentDetailView.labelDateAddedVal.text = formattedDateString;
    
    [self setImage:agent.photo_url imageView:_agentDetailView.imgViewPhoto showBorder:NO isThumb:NO];
    [self setImage:agent.thumb_url imageView:_agentDetailView.imgViewThumb showBorder:YES isThumb:YES];
    
    
    [_agentDetailView.buttonView setTitle:LOCALIZED(@"VIEW_LISTING")
                                forState:UIControlStateNormal];
    
    [_agentDetailView.buttonView setTitle:LOCALIZED(@"VIEW_LISTING")
                                forState:UIControlStateSelected];
    
    [_agentDetailView.buttonView addTarget:self
                                    action:@selector(didClickButtonView:)
                          forControlEvents:UIControlEventTouchUpInside];
    
    if(SHOW_ADS_AGENT_DETAIL_VIEW) {
        
        UIEdgeInsets inset = scrollViewMain.contentInset;
        inset.top = ADV_VIEW_OFFSET;
        scrollViewMain.contentInset = inset;
        
        inset = scrollViewMain.scrollIndicatorInsets;
        inset.top = ADV_VIEW_OFFSET;
        scrollViewMain.scrollIndicatorInsets = inset;
        
        [MGUtilities createAdAtY:64
                  viewController:self
                         bgColor:AD_BG_COLOR];
    }
}

-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView showBorder:(BOOL)showBorder isThumb:(BOOL)isThumb{
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    
    NSString* placeholder = isThumb ? AGENT_THUMB_PLACEHOLDER_IMAGE : AGENT_DETAIl_COVER_PLACEHOLDER_IMAGE;
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:placeholder];
    
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
                                //weakImgRef.layer.cornerRadius = 50;
                                
                                if(showBorder) {
                                    [MGUtilities createBorders:weakImgRef
                                                   borderColor:THEME_GREEN_TINT_COLOR
                                                   shadowColor:[UIColor clearColor]
                                                   borderWidth:4];
                                }
                                
                            } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                
                                if(isThumb && showBorder) {
                                    [MGUtilities createBorders:weakImgRef
                                                   borderColor:THEME_GREEN_TINT_COLOR
                                                   shadowColor:[UIColor clearColor]
                                                   borderWidth:4];
                                }
                            }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didClickButtonView:(id)sender {
 
    [self performSegueWithIdentifier:@"segueAgentListing" sender:agent];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"segueAgentListing"]) {
        
        AgentListingViewController* vc = [segue destinationViewController];
        vc.agent = sender;
    }
}


@end
