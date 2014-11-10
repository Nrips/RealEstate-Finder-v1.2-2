//
//  AgentViewController.m
//  RealEstateFinder
//
//  
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "RealEstateViewController.h"
#import "DetailViewController.h"
#import "RealEstateEditViewController.h"
#import "RealEstateAddViewController.h"

@interface RealEstateViewController ()

@end

@implementation RealEstateViewController

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
    
    RealEstate* realEstate = [listView.arrayData objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Extra_iPhone" bundle:nil];
    RealEstateEditViewController* vc;
    vc = [storyboard instantiateViewControllerWithIdentifier:@"storyboardRealEstateEdit"];
    vc.realEstate = realEstate;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    if(cell != nil) {
        Agent* agent = [listView.arrayData objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
        
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
                                
                                [MGUtilities createBorders:weakImgRef
                                               borderColor:THEME_GREEN_TINT_COLOR
                                               shadowColor:[UIColor clearColor]
                                               borderWidth:4];
                                
                            } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                
                            }];
}

-(void)addRealEstate {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Extra_iPhone" bundle:nil];
    RealEstateAddViewController* vc;
    vc = [storyboard instantiateViewControllerWithIdentifier:@"storyboardRealEstateAdd"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
