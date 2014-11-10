//
//  SearchViewController.m
//  RealEstateFinder
//
//  Created by Jonnel Ryan on 6/6/14.
//  Copyright (c) 2014 Client. All rights reserved.
//

#import "SearchViewController.h"

#define PRICE_RANGE_CELL @"PriceRangeCell"

#define kTagPriceRange 101


@interface SearchViewController () {
    
    BOOL _isRangeSelected;
}

@property (nonatomic) NSArray *dataSource;
@property (nonatomic) NSIndexPath *expandingIndexPath;
@property (nonatomic) NSIndexPath *expandedIndexPath;


- (NSIndexPath *)actualIndexPathForTappedIndexPath:(NSIndexPath *)indexPath;
- (void)createDataSourceArray;

@end

@implementation SearchViewController

@synthesize nestedTab;
@synthesize textFieldSearch;
@synthesize imgViewSearch;
@synthesize tableViewMain;
@synthesize viewButtons;
@synthesize buttonCancel;
@synthesize buttonSearch;

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
    self.view.backgroundColor = BG_VIEW_COLOR;
    
    [nestedTab baseInit];
    
    nestedTab.titles = [NSArray arrayWithObjects:LOCALIZED(@"FOR_SALE"), LOCALIZED(@"FOR_RENT"), LOCALIZED(@"SOLD"), nil];
    
    nestedTab.arraySelectedImages = [NSArray arrayWithObjects:INNER_TAB_LEFT_SELECTED, INNER_TAB_MIDDLE_SELECTED, INNER_TAB_RIGHT_SELECTED, nil];
    nestedTab.arrayUnselectedImages = [NSArray arrayWithObjects:INNER_TAB_LEFT_NORMAL, INNER_TAB_MIDDLE_NORMAL, INNER_TAB_RIGHT_NORMAL, nil];
    
    nestedTab.selectedTextColor = THEME_GREEN_TINT_COLOR;
    nestedTab.normalTextColor = THEME_BLACK_TINT_COLOR;
    nestedTab.buttonFont = [UIFont fontWithName:@"GillSans" size:15];
    nestedTab.delegate = self;
    
    [nestedTab setNeedsReLayout];
    [nestedTab setSelectedTab:0];
    
    [buttonSearch setTitle:LOCALIZED(@"SEARCH") forState:UIControlStateNormal];
    [buttonSearch setTitle:LOCALIZED(@"SEARCH") forState:UIControlStateSelected];
    
    [buttonCancel setTitle:LOCALIZED(@"CANCEL") forState:UIControlStateNormal];
    [buttonCancel setTitle:LOCALIZED(@"CANCEL") forState:UIControlStateSelected];
    
    viewButtons.backgroundColor = [THEME_GREEN_TINT_COLOR colorWithAlphaComponent:0.7];
    
    tableViewMain.dataSource = self;
    tableViewMain.delegate = self;
    
    [tableViewMain registerNib:[UINib nibWithNibName:@"PriceRangeCell" bundle:nil]
        forCellReuseIdentifier:@"PriceRangeCell"];
    
    _isRangeSelected = NO;
    [self createDataSourceArray];
    
}

-(void) MGNestedTab:(MGNestedTab *)nestedTab didCreateTabButton:(UIButton *)button indexTab:(int)index {
    
}

-(void) MGNestedTab:(MGNestedTab *)_nestedTab didSelectTabButton:(UIButton *)button indexTab:(int)index {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)didClickButtonCancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)didClickButtonSearch:(id)sender {
    
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( (indexPath.row == self.expandedIndexPath.row) && indexPath.row != 0)
       return 162;
    
    else
        return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    // take expanded cell into account when returning number of rows
	if (self.expandedIndexPath) {
		return [self.dataSource count] + 1;
	}
	
    return [self.dataSource count];
}

#pragma mark - UITableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
	static NSString *cellIdentifier = nil;
	
    // init expanded cell
	if ([indexPath isEqual:self.expandedIndexPath]) {
		cellIdentifier = PRICE_RANGE_CELL;
	}
    // init expanding cell
	else {
		cellIdentifier = @"ExpandingCellIdentifier";
	}
	
	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
										   forIndexPath:indexPath];
    
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									  reuseIdentifier:cellIdentifier];
	}
	
    if([cellIdentifier isEqualToString:PRICE_RANGE_CELL])
        [self setupPriceRangeCell:(SearchCell*)cell];
    
    
    
    // set text in expanding cell
	if ([[cell reuseIdentifier] isEqualToString:@"ExpandingCellIdentifier"]) {
		NSIndexPath *theIndexPath = [self actualIndexPathForTappedIndexPath:indexPath];
		[cell.textLabel setText:[self.dataSource objectAtIndex:[theIndexPath row]]];
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // disable touch on expanded cell
	UITableViewCell *cell = [tableViewMain cellForRowAtIndexPath:indexPath];
	if ([[cell reuseIdentifier] isEqualToString:PRICE_RANGE_CELL]) {
		return;
	}
	
    // deselect row
	[tableView deselectRowAtIndexPath:indexPath
							 animated:NO];
	
    // get the actual index path
	indexPath = [self actualIndexPathForTappedIndexPath:indexPath];
	
    // save the expanded cell to delete it later
	NSIndexPath *theExpandedIndexPath = self.expandedIndexPath;
	
    // same row tapped twice - get rid of the expanded cell
	if ([indexPath isEqual:self.expandingIndexPath]) {
		self.expandingIndexPath = nil;
		self.expandedIndexPath = nil;
	}
    // add the expanded cell
	else
    {
		self.expandingIndexPath = indexPath;
		self.expandedIndexPath = [NSIndexPath indexPathForRow:[indexPath row] + 1
													inSection:[indexPath section]];
	}
	
	[tableView beginUpdates];
	
	if (theExpandedIndexPath) {
		[tableViewMain deleteRowsAtIndexPaths:@[theExpandedIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
	}
	if (self.expandedIndexPath) {
		[tableViewMain insertRowsAtIndexPaths:@[self.expandedIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
	}
	
	[tableView endUpdates];
	
    // scroll to the expanded cell
	[tableViewMain scrollToRowAtIndexPath:indexPath
							 atScrollPosition:UITableViewScrollPositionMiddle
									 animated:YES];
    
}

#pragma mark - controller methods

- (void)createDataSourceArray
{
	NSMutableArray *dataSourceMutableArray = [NSMutableArray array];
	
	for (int i = 0; i <= 20; i++) {
		NSString *dataSourceString = [NSString stringWithFormat:@"Row #%u", i];
		[dataSourceMutableArray addObject:dataSourceString];
	}
	
    
	self.dataSource = [NSArray arrayWithArray:dataSourceMutableArray];
}

- (NSIndexPath *)actualIndexPathForTappedIndexPath:(NSIndexPath *)indexPath
{
	if (self.expandedIndexPath && [indexPath row] > [self.expandedIndexPath row])
    {
		return [NSIndexPath indexPathForRow:[indexPath row] - 1
								  inSection:[indexPath section]];
	}
	
	return indexPath;
}



#pragma mark - CELLS

-(void)setupPriceRangeCell:(SearchCell*) cell {
    
    cell.pickerPriceMin.delegate = self;
    cell.pickerPriceMin.dataSource = self;
    
    cell.pickerPriceMax.delegate = self;
    cell.pickerPriceMax.dataSource = self;
    
    cell.pickerPriceMin.tag = kTagPriceRange;
    
    arrayPriceRangeMin = [DataSource getPriceSearchDataSource];
    [arrayPriceRangeMin insertObject:LOCALIZED(@"NO_MIN") atIndex:0];
    
    arrayPriceRangeMax = [DataSource getPriceSearchDataSource];
    [arrayPriceRangeMax insertObject:LOCALIZED(@"NO_MAX") atIndex:0];
    
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    if(thePickerView.tag == kTagPriceRange)
        return 2;
    
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    if(thePickerView.tag == kTagPriceRange) {
        
        if(component == 0)
            return arrayPriceRangeMin.count;
        else
            return arrayPriceRangeMax.count;
            
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if(thePickerView.tag == kTagPriceRange) {
        
        if(component == 0)
            return [arrayPriceRangeMin objectAtIndex:row];
        else
            return [arrayPriceRangeMax objectAtIndex:row];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //Here, like the table view you can get the each section of each row if you've multiple sections
//    NSLog(@"Selected Color: %@. Index of selected color: %i", [arrayColors objectAtIndex:row], row);
    
    
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* result = [super hitTest:point withEvent:event];
    
    if ([result.superview isKindOfClass:[UIPickerView class]])
    {
        self.scrollEnabled = NO;
    }
    else
    {
        self.scrollEnabled = YES;
    }
    return result;
}

@end
