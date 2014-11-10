//
//  SideViewController.m
//  RealEstateFinder
//
//  
//  Copyright (c) 2014 MangasaurGames. All rights reserved.
//

#import "SideViewController.h"
#import "AppDelegate.h"
#import "ForSaleViewController.h"
#import "ForRentViewController.h"
#import "FavoriteViewController.h"
#import "FeaturedViewController.h"
#import "AgentViewController.h"
#import "RegisterViewController.h"
#import "MyRealEstateViewController.h"
#import "AgentEditViewController.h"
#import "AboutUsViewController.h"
#import "TCViewController.h"

@interface SideViewController ()

@end

@implementation SideViewController

@synthesize tableViewSide;
@synthesize actionSheet;

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
    self.view.backgroundColor = SIDE_VIEW_BG_COLOR;
    
    tableViewSide.delegate = self;
    tableViewSide.dataSource = self;
    _arrayUserSettings = [NSMutableArray new];
    [_arrayUserSettings addObject:LOCALIZED(@"LOGIN")];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(SIDE_VIEW_FRAME_WIDTH-1, 0, 2, self.view.frame.size.height);
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)THEME_GREEN_TINT_COLOR.CGColor,
                            (id)[UIColor clearColor].CGColor,
                            nil];
    gradientLayer.startPoint = CGPointMake(-2, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    [self.view.layer addSublayer:gradientLayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view.
    [self updateLoginStatus];
}

-(void)updateLoginStatus {
    
    UserSession* user = [UserAccessSession getUserSession];
    AgentSession* agent = [UserAccessSession getAgentSession];
    
    if( user != nil && agent != nil ) {
        _isLoggedIn = YES;
        [_arrayUserSettings removeAllObjects];
        
        NSString* name = [NSString stringWithFormat:@"%@", agent.name];
        [_arrayUserSettings addObject:name];
        [_arrayUserSettings addObject:LOCALIZED(@"VIEW_LISTING")];
        [_arrayUserSettings addObject:LOCALIZED(@"EDIT_PROFILE")];
    }
    else {
        _isLoggedIn = NO;
        [_arrayUserSettings removeAllObjects];
        [_arrayUserSettings addObject:LOCALIZED(@"LOGIN")];
    }
    [tableViewSide reloadData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [_arrayUserSettings count];
    
    if (section == 1)
        return [LIST_TITLE_FIRST_ENTRY count];
    
    if (section == 2)
        return [LIST_TITLE_SECOND_ENTRY count];
    
    return 0;
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MGListCell* cell =  [tableView dequeueReusableCellWithIdentifier:@"EntryCell"];
    cell.selectedImage = [UIImage imageNamed:LIST_SIDE_VIEW_SELECTED_CELL_BG];
    cell.unselectedImage = [UIImage imageNamed:LIST_SIDE_VIEW_NORMAL_CELL_BG];
    cell.selectedColor = WHITE_TEXT_COLOR;
    cell.unSelectedColor = BLACK_TEXT_COLOR;
    
    
    
    NSString* title = @"";
    UIImage* imgSelected = nil;
    UIImage* imgUnselected = nil;
    
    if(indexPath.section == 0) {
        title = [_arrayUserSettings objectAtIndex:indexPath.row];
        imgSelected = [UIImage imageNamed:[LIST_TITLE_USER_ICON_SELECTED objectAtIndex:indexPath.row]];
        imgUnselected = [UIImage imageNamed:[LIST_TITLE_USER_ICON_NORMAL objectAtIndex:indexPath.row]];
    }
    
    if(indexPath.section == 1) {
        title = [LIST_TITLE_FIRST_ENTRY objectAtIndex:indexPath.row];
        imgSelected = [UIImage imageNamed:[LIST_TITLE_SEARCH_ICON_SELECTED objectAtIndex:indexPath.row]];
        imgUnselected = [UIImage imageNamed:[LIST_TITLE_SEARCH_ICON_NORMAL objectAtIndex:indexPath.row]];
    }
    
    
    if(indexPath.section == 2) {
        title = [LIST_TITLE_SECOND_ENTRY objectAtIndex:indexPath.row];
        imgSelected = [UIImage imageNamed:[LIST_TITLE_SECOND_ICON_SELECTED objectAtIndex:indexPath.row]];
        imgUnselected = [UIImage imageNamed:[LIST_TITLE_SECOND_ICON_NORMAL objectAtIndex:indexPath.row]];
    }
    
    cell.unselectedImageIcon = imgUnselected;
    cell.selectedImageIcon = imgSelected;
    [cell.labelTitle setText:title];
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MGListCell* headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    [headerCell.labelTitle setText:[HEADER_TITLE objectAtIndex:section]];
    [headerCell.labelTitle setTextColor:TABLE_HEADER_TEXT_COLOR];
    
    return headerCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    AppDelegate* delegate = [AppDelegate instance];
    UINavigationController* navController = (UINavigationController*)delegate.contentViewController;
    UIViewController* controller = navController.visibleViewController;
    
    // DO NOT PUSH VIEW ANIMATED IN SUCCESSION,
    // THIS WILL RESULT TO CORRUPTED NAVIGATION CONTROLER
    [controller.navigationController popViewControllerAnimated:NO];
    
    NSLog(@"section: %d, row: %d", indexPath.section, indexPath.row);
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        [self actionSheet];
        [actionSheet showInView:[[delegate.window rootViewController] view]];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        [AppDelegate foldLeftView];
        if([[navController topViewController] isKindOfClass:[MyRealEstateViewController class]])
            return;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"storyboardMyRealEstate"];
        [navController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        
        [AppDelegate foldLeftView];
        if([[navController topViewController] isKindOfClass:[AgentEditViewController class]])
            return;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"storyboardAgentEdit"];
        [navController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        [AppDelegate foldLeftView];
        if([[navController topViewController] isKindOfClass:[ForSaleViewController class]])
            return;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"storyboardForSale"];
        [navController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        [AppDelegate foldLeftView];
        if([[navController topViewController] isKindOfClass:[ForRentViewController class]])
            return;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"storyboardForRent"];
        [navController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 1 && indexPath.row == 2) {
        
        [AppDelegate foldLeftView];
        if([[navController topViewController] isKindOfClass:[FeaturedViewController class]])
            return;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"storyboardFavorites"];
        [navController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 1 && indexPath.row == 3) {
        
        [AppDelegate foldLeftView];
        if([[navController topViewController] isKindOfClass:[AgentViewController class]])
            return;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"storyboardAgent"];
        [navController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        [AppDelegate foldLeftView];
        if([[navController topViewController] isKindOfClass:[FeaturedViewController class]])
            return;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"storyboardFeatured"];
        [navController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        
        [AppDelegate foldLeftView];
        if([[navController topViewController] isKindOfClass:[AboutUsViewController class]])
            return;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"storyboardAboutUs"];
        [navController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 2) {
        
        [AppDelegate foldLeftView];
        if([[navController topViewController] isKindOfClass:[TCViewController class]])
            return;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"storyboardTC"];
        [navController pushViewController:vc animated:YES];
    }
}

-(UIActionSheet*)actionSheet {
    
    NSString *cancelButtonTitle = LOCALIZED(@"CANCEL");
    NSString *otherButtonTitle =  LOCALIZED(@"LOGIN");
    
    if(_isLoggedIn)
        otherButtonTitle = LOCALIZED(@"LOGOUT");
    
    actionSheet = [[UIActionSheet alloc]
                   initWithTitle:nil
                   delegate:self
                   cancelButtonTitle:cancelButtonTitle
                   destructiveButtonTitle:nil
                   otherButtonTitles:otherButtonTitle,
                   nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;

    return actionSheet;
}

-(void)willPresentActionSheet:(UIActionSheet *)_actionSheet {
    
    for (int x = 0; x < [[_actionSheet subviews] count]; x++) {
        
        UIView* view = [[_actionSheet subviews] objectAtIndex:x];
        
        if([view isKindOfClass:NSClassFromString(@"UIAlertButton")]) {
            
            UIButton* button = ((UIButton*)view);
            if(x == 1) {
                [button setTitleColor:THEME_GREEN_TINT_COLOR forState:UIControlStateNormal];
            }
            if(x == 2) {
                [button setTitleColor:THEME_BLACK_TINT_COLOR forState:UIControlStateNormal];
            }
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // LOGIN
    if(buttonIndex == 0) {
        
        if(!_isLoggedIn) {
            AppDelegate* delegate = [AppDelegate instance];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"User_iPhone" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"storyboardAuthentication"];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [[delegate.window rootViewController] presentViewController:vc animated:YES completion:nil];
        }
        else {
            _isLoggedIn = NO;
            [UserAccessSession clearAllSession];
            [self updateLoginStatus];
        }
    }
}

-(IBAction)didClickFoldButton:(id)sender {

    [AppDelegate foldLeftView];
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
