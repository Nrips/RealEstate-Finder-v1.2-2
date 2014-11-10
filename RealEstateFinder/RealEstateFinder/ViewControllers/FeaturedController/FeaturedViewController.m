//
//  FeaturedViewController.m
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "FeaturedViewController.h"
#import "DetailViewController.h"

@interface FeaturedViewController ()

@end

@implementation FeaturedViewController

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
    listView.cellHeight = 267;
    
    [listView registerNibName:@"SaleCell" cellIndentifier:@"SaleCell"];
    [listView baseInit];
    [listView addSubviewRefreshControlWithTintColor:THEME_GREEN_TINT_COLOR];
    
    if(SHOW_ADS_FEATURED_VIEW) {
        
        UIEdgeInsets inset = listView.tableView.contentInset;
        inset.top = ADV_VIEW_OFFSET;
        listView.tableView.contentInset = inset;
        
        inset = listView.tableView.scrollIndicatorInsets;
        inset.top = ADV_VIEW_OFFSET;
        listView.tableView.scrollIndicatorInsets = inset;
        
        [MGUtilities createAdAtY:64
                  viewController:self
                         bgColor:AD_BG_COLOR];
    }
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
    
    NSArray* array = [CoreDataController getFeaturedRealEstates];
    listView.arrayData = [NSMutableArray arrayWithArray:array];
}

-(void)MGListView:(MGListView *)listView didRefreshStarted:(UIRefreshControl *)refreshControl {
    
    [self beginParsing];
}


-(void) MGListView:(MGListView *)_listView didSelectCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    AppDelegate* delegate = [AppDelegate instance];
    UINavigationController* navController = (UINavigationController*)delegate.contentViewController;
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    DetailViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"storyboardDetails"];
    vc.realEstate = [listView.arrayData objectAtIndex:indexPath.row];
    [navController pushViewController:vc animated:YES];
}

-(UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    if(cell != nil) {
        RealEstate* realEstate = [listView.arrayData objectAtIndex:indexPath.row];
        Favorite* fave = [CoreDataController getFavoriteByRealEstateId:[realEstate.realestate_id intValue]];
        Photo* photo = [CoreDataController getPhotoByRealEstateId:[realEstate.realestate_id intValue]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.imgViewFeatured.hidden = YES;
        if([realEstate.featured intValue] == 1) {
            cell.imgViewFeatured.hidden = NO;
        }
        
        cell.imgViewFave.hidden = YES;
        if(fave != nil) {
            cell.imgViewFave.hidden = NO;
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.labelPrice setText:realEstate.price];
        [cell.labelAddress setText:realEstate.address];
        [self setImage:photo.photo_url imageView:cell.imgViewPic];
        cell.labelHeader1.backgroundColor = [BLACK_TEXT_COLOR colorWithAlphaComponent:0.66];
    }
    
    return cell;
}

-(void)MGListView:(MGListView *)_listView scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:LIST_CELL_PLACEHOLDER];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
