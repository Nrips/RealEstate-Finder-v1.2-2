//
//  AddressSearchMapVC.m
//  RealEstateFinder
//
//  Created by utk@rsh on 04/11/14.
//  Copyright (c) 2014 Client. All rights reserved.
//

#import "AddressSearchMapVC.h"
#import "NameSearch.h"

@interface AddressSearchMapVC () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,NSURLConnectionDataDelegate>
{
    __weak IBOutlet UITableView *tblAddressSearchResults;
    
    NSMutableData *responseData;
    NSString *compareTextString;
}

@property (nonatomic, strong) NSMutableDictionary *dictLocationInfo;
@property (nonatomic, strong) NSMutableArray      *arrLocationDict;
@property (nonatomic, strong) NSDictionary        *dictUserInfo;

@end

@implementation AddressSearchMapVC
@synthesize searchDisplayController;


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //*>    setting Navigation Bar appearance.
    self.navigationItem.titleView = [MGUIAppearance createLogo:HEADER_LOGO];
    self.view.backgroundColor = BG_VIEW_COLOR;
    
    [MGUIAppearance enhanceNavBarController:self.navigationController
                               barTintColor:WHITE_TEXT_COLOR
                                  tintColor:WHITE_TEXT_COLOR
                             titleTextColor:WHITE_TEXT_COLOR];
    
    self.filteredListContent = [[NSMutableArray alloc] init];
    
    
    UISearchBar *mySearchBar = [[UISearchBar alloc] init];
    [mySearchBar setScopeButtonTitles:[NSArray arrayWithObjects:@"name",nil]];
     mySearchBar.delegate = self;
    [mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [mySearchBar sizeToFit];
    mySearchBar.placeholder = LOCALIZED(@"SEARCH_KEYWORDS");
    mySearchBar.backgroundColor = THEME_GREEN_TINT_COLOR;
    mySearchBar.tintColor = THEME_GREEN_TINT_COLOR;
    tblAddressSearchResults.tableHeaderView = mySearchBar;
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
    [self setSearchDisplayController:searchDisplayController];
    [searchDisplayController setDelegate:self];
    [searchDisplayController setSearchResultsDataSource:self];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [tblAddressSearchResults reloadData];
    tblAddressSearchResults.scrollEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    /*
     Hide the search bar
     */
    
    NSIndexPath *tableSelection = [tblAddressSearchResults indexPathForSelectedRow];
    [tblAddressSearchResults deselectRowAtIndexPath:tableSelection animated:NO];
    
    [self.view sendSubviewToBack:tblAddressSearchResults];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        // Return the number of rows in the section.
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            return [self.filteredListContent count];
        }
        else
        {
            return [self.listContent count];
        }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
        static NSString *kCellID = @"cellID";
        
        cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
        }
    
        NameSearch *nSearch = nil;
    
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            NSLog(@"Filtered list : %@",self.filteredListContent);
            nSearch  = [self.filteredListContent objectAtIndex:indexPath.row];
        }
        else
        {
            nSearch = [self.listContent objectAtIndex:indexPath.row];
        }
        
        cell.textLabel.text = nSearch.name;
    
    return cell;
}


#pragma mark - Table View Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    selectedCell.tintColor = THEME_GREEN_TINT_COLOR;
    
        NameSearch *nSearch = nil;
    
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            nSearch = [self.filteredListContent objectAtIndex:indexPath.row];
        }
        else
        {
            nSearch = [self.listContent objectAtIndex:indexPath.row];
        }
        
        NSMutableDictionary *dictionary = [NSMutableDictionary new];
        
        sharedAppDelegate.destinationString = nSearch.name;
        [dictionary setValue:nSearch.name forKey:@"name"];
        
        CLGeocoder *geocoder = [CLGeocoder new];
        [geocoder geocodeAddressString:nSearch.name
         
                     completionHandler:^(NSArray* placemarks, NSError* error){

                         for (CLPlacemark* aPlacemark in placemarks)
                         {
                             NSLog(@"%s Place : %@ \n Latitude : %f \n Longitude : %f",__FUNCTION__,nSearch.name,aPlacemark.location.coordinate.latitude,aPlacemark.location.coordinate.longitude);
                             
                             self.arrLocationDict = [NSMutableArray arrayWithObjects:nSearch.name,
                                                                                  aPlacemark.country,
                                                     [NSString stringWithFormat:@"%f", aPlacemark.location.coordinate.latitude],
                                                     [NSString stringWithFormat:@"%f", aPlacemark.location.coordinate.longitude],
                                                                                                        aPlacemark.locality, nil];
                             //*>   check postalCode is available or not.
                             NSString *postalCode = aPlacemark.postalCode;
                             
                             if (postalCode != nil)
                             {
                                 [self.arrLocationDict addObject:postalCode];
                             }
                             
                             self.dictUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.arrLocationDict, @"arrLocationDict", nil];
                             
                             
                             [[NSNotificationCenter defaultCenter] postNotificationName :@"locationData"
                                                                                 object :self
                                                                               userInfo :self.dictUserInfo];
                             
            
                             CLLocation *location = [[CLLocation alloc] initWithLatitude:sharedAppDelegate.recentSearchedDestinationCoordinate.latitude  longitude:sharedAppDelegate.recentSearchedDestinationCoordinate.longitude];
                             
                             [dictionary setValue:location forKey:@"coordinate"];
                             
                         }
                         [[app_Delegate recentPlacesArray] addObject:dictionary];
                         
                         [self.navigationController popViewControllerAnimated:YES];
            }];
}

#pragma mark Custom Methods

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    /*
     Update the filtered array based on the search text and scope.
     */
    responseData = [NSMutableData new];
    compareTextString = [NSString new];
    compareTextString = searchText;
    
    NSString *urlString = [NSString stringWithFormat:GOOGLE_AUTOCOMPLETE_URL,searchText,GOOGLE_AUTOCOMPLETE_KEY];
    
    NSString *properlyEscapedURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:properlyEscapedURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [NSURLConnection connectionWithRequest:request delegate:self];

    [self.filteredListContent removeAllObjects];// First clear the filtered array.
    
    for (NameSearch *nSearch in _listContent)
    {
        NSComparisonResult result = [nSearch.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
        {
            [self.filteredListContent addObject:nSearch];
        }
    }
}

-(void)searchBar:(id)sender
{
    [searchDisplayController setActive:YES animated:YES];
}


#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
    /*
     Bob: Because the searchResultsTableView will be released and allocated automatically, so each time we start to begin search, we set its delegate here.
     */
    [self.searchDisplayController.searchResultsTableView setDelegate:self];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    /*
     Hide the search bar
     */
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    responseData = [NSMutableData new];
    compareTextString = [NSString new];
    compareTextString = searchBar.text;
    
    NSString *urlString = [NSString stringWithFormat:GOOGLE_AUTOCOMPLETE_URL,searchBar.text,GOOGLE_AUTOCOMPLETE_KEY];
    
    NSString *properlyEscapedURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:properlyEscapedURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    
    [self.filteredListContent removeAllObjects];// First clear the filtered array.
    
    for (NameSearch *nSearch in _listContent)
    {
        
        NSComparisonResult result = [nSearch.name compare:searchBar.text options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchBar.text length])];
        if (result == NSOrderedSame)
        {
            [self.filteredListContent addObject:nSearch];
        }
    }
}


#pragma NSURL data delegates

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *err;
    _listContent = [NSMutableArray new];
    NSMutableDictionary *jsonDict;
    
    jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
    if (!err)
    {
        NSMutableArray *predictionsArray = [NSMutableArray new];
        predictionsArray = [jsonDict objectForKey:@"predictions"];
        [_listContent removeAllObjects];
        
        for (int i = 0; i<[predictionsArray count]; i++)
        {
            NSString *str = [NSString stringWithFormat:@"%@",[[predictionsArray valueForKey:@"description"]objectAtIndex:i]];
            NameSearch *nS = [[NameSearch alloc] init];
            nS.name = str;
            [_listContent addObject:nS];
            NSLog(@"string %@",str);
        }
    }
    else
    {
        NSLog(@"err %@",err);
    }
    
    NSLog(@"string %@",compareTextString);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);
}

@end
