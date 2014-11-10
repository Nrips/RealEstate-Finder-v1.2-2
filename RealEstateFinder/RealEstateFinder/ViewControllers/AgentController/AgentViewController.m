//
//  AgentViewController.m
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "AgentViewController.h"
#import "AgentDetailViewController.h"

@interface AgentViewController ()

@end

@implementation AgentViewController

@synthesize listView;

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

-(void)viewWillAppear:(BOOL)animated
{
    [self beginParsing];
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
    
    listView.delegate = self;
    listView.cellHeight = 101;
    
    [listView registerNibName:@"AgentCell" cellIndentifier:@"AgentCell"];
    [listView baseInit];
    [listView addSubviewRefreshControlWithTintColor:THEME_GREEN_TINT_COLOR];

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
        [listView reloadData];
        
        [listView.refreshControl endRefreshing];
        
        if(listView.arrayData == nil || listView.arrayData.count == 0) {
            
            UIColor* color = [THEME_GREEN_TINT_COLOR colorWithAlphaComponent:0.70];
            [MGUtilities showStatusNotifier:LOCALIZED(@"NO_RESULTS")
                                  textColor:[UIColor whiteColor]
                             viewController:self
                                   duration:0.5f
                                    bgColor:color
                                        atY:64];
        }
    }];
}

-(void) performParsing {
    
    NSArray* array = [CoreDataController getAgents];
    listView.arrayData = [NSMutableArray arrayWithArray:array];
}

-(void)MGListView:(MGListView *)listView didRefreshStarted:(UIRefreshControl *)refreshControl {
    
    [self beginParsing];
}


-(void) MGListView:(MGListView *)_listView didSelectCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    Agent* agent = [listView.arrayData objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"segueAgentDetail" sender:agent];
}

-(UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    if(cell != nil) {
        Agent* agent = [listView.arrayData objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        [cell.labelTitle setText:agent.name];
        [cell.topLeftLabelSubtitle setText:agent.address];
        [cell.labelDesc setText:agent.contact_no];
        
        [self setImage:agent.thumb_url imageView:cell.imgViewThumb];
    }
    
    return cell;
}

-(void)MGListView:(MGListView *)_listView scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:AGENT_THUMB_PLACEHOLDER_IMAGE];
    
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
                                //weakImgRef.layer.cornerRadius = 45;
                                
                                [MGUtilities createBorders:weakImgRef
                                               borderColor:THEME_GREEN_TINT_COLOR
                                               shadowColor:[UIColor clearColor]
                                               borderWidth:4];
                                
                            } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                
                                [MGUtilities createBorders:weakImgRef
                                               borderColor:THEME_GREEN_TINT_COLOR
                                               shadowColor:[UIColor clearColor]
                                               borderWidth:4];
                            }];
}


#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"segueAgentDetail"]) {
        
        AgentDetailViewController* agentDetail = [segue destinationViewController];
        agentDetail.agent = sender;
    }
}

@end
