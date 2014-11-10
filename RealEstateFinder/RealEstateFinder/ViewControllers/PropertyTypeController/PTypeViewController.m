//
//  PTypeViewController.m
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "PTypeViewController.h"

@interface PTypeViewController ()

@end

@implementation PTypeViewController

@synthesize listView;
@synthesize arrayData;
@synthesize propertyTypeDelegate = _propertyTypeDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    
    listView.delegate = self;
    listView.cellHeight = 44;
    
    [listView registerNibName:@"PropertyTypeCell" cellIndentifier:@"PropertyTypeCell"];
    [listView baseInit];
    
    listView.arrayData = arrayData;
    [listView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)MGListView:(MGListView *)_listView scrollViewDidScroll:(UIScrollView *)scrollView { }

- (void)MGListView:(MGListView *)listView didRefreshStarted:(UIRefreshControl *)refreshControl { }


- (void)MGListView:(MGListView *)_listView didSelectCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {

    [self.propertyTypeDelegate didSelectPropertyType:[arrayData objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    if(cell != nil) {
     
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.labelTitle setText:[arrayData objectAtIndex:indexPath.row]];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}



@end
