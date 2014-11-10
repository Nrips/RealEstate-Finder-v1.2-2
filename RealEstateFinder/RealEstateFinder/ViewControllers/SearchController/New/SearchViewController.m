//
//  SearchViewController.m
//  RealEstateFinder
//
//  Created by Jonnel Ryan on 6/6/14.
//  Copyright (c) 2014 Client. All rights reserved.
//

#import "SearchViewController.h"

#define kTagPriceRange 101
#define kTagSquareFootage 102
#define kTagBuiltIn 103
#define kTagLotSize 104

#define ADJUST_WIDTH 80

@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize scrollViewMain;

@synthesize nestedTab;
@synthesize textFieldSearch;
@synthesize imgViewSearch;
@synthesize viewButtons;
@synthesize buttonCancel;
@synthesize buttonSearch;
@synthesize searchResultDelegate = _searchResultDelegate;
@synthesize buttonCancelSearch;

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
    
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 40, 10, 10);
    
    _imgSearchBarDefault = [[UIImage imageNamed:SEARCH_BAR_DEFAULT_BG]
                                    resizableImageWithCapInsets:insets];
    
    _imgSearchBarSelected = [[UIImage imageNamed:SEARCH_BAR_SELECTED_BG]
                             resizableImageWithCapInsets:insets];
    
    imgViewSearch.image = _imgSearchBarDefault;
    textFieldSearch.delegate = self;
    
    [nestedTab baseInit];
    
    nestedTab.titles = [NSArray arrayWithObjects:
                        LOCALIZED(@"FOR_SALE"),
                        LOCALIZED(@"FOR_RENT"),
                        LOCALIZED(@"SOLD"), nil];
    
    nestedTab.arraySelectedImages = [NSArray arrayWithObjects:
                                     INNER_TAB_LEFT_SELECTED,
                                     INNER_TAB_MIDDLE_SELECTED,
                                     INNER_TAB_RIGHT_SELECTED, nil];
    
    nestedTab.arrayUnselectedImages = [NSArray arrayWithObjects:
                                       INNER_TAB_LEFT_NORMAL,
                                       INNER_TAB_MIDDLE_NORMAL,
                                       INNER_TAB_RIGHT_NORMAL, nil];
    
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
    viewButtons.layer.zPosition = 999;
    
    _searchView = [[SearchRawView alloc] initWithNibName:@"SearchView"];
    scrollViewMain.contentSize = _searchView.frame.size;
    [scrollViewMain addSubview:_searchView];
    
    [_searchView.segmentBaths setTintColor:THEME_GREEN_TINT_COLOR];
    [_searchView.segmentBeds setTintColor:THEME_GREEN_TINT_COLOR];
    
    
    _searchView.pickerPrice.delegate = self;
    _searchView.pickerPrice.dataSource = self;
    _searchView.pickerPrice.tag = kTagPriceRange;
    [_searchView.pickerPrice setTintColor:THEME_BLACK_TINT_COLOR];
    
    [MGUtilities createBordersInView:_searchView.pickerPrice
                         borderColor:THEME_GREEN_TINT_COLOR
                         shadowColor:[UIColor clearColor]
                         borderWidth:2
                        borderRadius:8];
    
    _searchView.pickerSquareFootage.delegate = self;
    _searchView.pickerSquareFootage.dataSource = self;
    _searchView.pickerSquareFootage.tag = kTagSquareFootage;
    [_searchView.pickerSquareFootage setTintColor:THEME_BLACK_TINT_COLOR];
    
    [MGUtilities createBordersInView:_searchView.pickerSquareFootage
                         borderColor:THEME_GREEN_TINT_COLOR
                         shadowColor:[UIColor clearColor]
                         borderWidth:2
                        borderRadius:8];
    
    _searchView.pickerYearsBuilt.delegate = self;
    _searchView.pickerYearsBuilt.dataSource = self;
    _searchView.pickerYearsBuilt.tag = kTagBuiltIn;
    [_searchView.pickerYearsBuilt setTintColor:THEME_BLACK_TINT_COLOR];
    
    [MGUtilities createBordersInView:_searchView.pickerYearsBuilt
                         borderColor:THEME_GREEN_TINT_COLOR
                         shadowColor:[UIColor clearColor]
                         borderWidth:2
                        borderRadius:8];
    
    _searchView.pickerLotSize.delegate = self;
    _searchView.pickerLotSize.dataSource = self;
    _searchView.pickerLotSize.tag = kTagLotSize;
    [_searchView.pickerLotSize setTintColor:THEME_BLACK_TINT_COLOR];
    
    [MGUtilities createBordersInView:_searchView.pickerLotSize
                         borderColor:THEME_GREEN_TINT_COLOR
                         shadowColor:[UIColor clearColor]
                         borderWidth:2
                        borderRadius:8];
    
    _arrayPriceRangeMin = [DataSource getPriceSearchDataSource];
    [_arrayPriceRangeMin insertObject:LOCALIZED(@"NO_MIN") atIndex:0];
    
    _arrayPriceRangeMax = [DataSource getPriceSearchDataSource];
    [_arrayPriceRangeMax insertObject:LOCALIZED(@"NO_MAX") atIndex:0];
    
    _arraySquareFootage = [DataSource getSquareFootageDataSource];
    [_arraySquareFootage insertObject:LOCALIZED(@"ANY") atIndex:0];
    
    _arrayBuiltInMin = [DataSource getYearBuiltDataSource];
    [_arrayBuiltInMin insertObject:LOCALIZED(@"NO_MIN") atIndex:0];
    
    _arrayBuiltInMax = [DataSource getYearBuiltDataSource];
    [_arrayBuiltInMax insertObject:LOCALIZED(@"NO_MAX") atIndex:0];
    
    _arrayLotSize = [DataSource getLotSizeDataSource];
    [_arrayLotSize insertObject:LOCALIZED(@"ANY") atIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    
    UIEdgeInsets inset = scrollViewMain.contentInset;
    inset.bottom = NAV_BAR_OFFSET_DEFAULT;
    scrollViewMain.contentInset = inset;
}

-(void)keyboardDidShow:(id)sender {
    CGRect frame = scrollViewMain.frame;
    frame.size.height -= 216;
    scrollViewMain.frame = frame;
    
}

-(void)keyboardDidHide:(id)sender {
    CGRect frame = scrollViewMain.frame;
    frame.size.height += 216;
    scrollViewMain.frame = frame;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    _isShowingCancelButton = NO;
    imgViewSearch.image = _imgSearchBarSelected;
    [self showCancelButtonSearch:-ADJUST_WIDTH];
    
    int newY = self.view.frame.size.height - 216 - viewButtons.frame.size.height;
    [self moveViewButtonsAtY:newY];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == textFieldSearch) {
		[textFieldSearch resignFirstResponder];
	}
    
    [self cancelSearch];
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > MAX_CHARS_INPUT) ? NO : YES;
}

-(void)moveViewButtonsAtY:(int)y {
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: UIViewAnimationOptionTransitionNone
                     animations:^ {
                         
                         CGRect frame = viewButtons.frame;
                         frame.origin.y = y;
                         viewButtons.frame = frame;
                     }
     
                     completion:^(BOOL finished) {
                         
                     }
     ];
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







- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    if(thePickerView.tag == kTagPriceRange)
        return 2;
    
    if(thePickerView.tag == kTagSquareFootage)
        return 1;
    
    if(thePickerView.tag == kTagBuiltIn)
        return 2;
    
    if(thePickerView.tag == kTagLotSize)
        return 1;
    
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    if(thePickerView.tag == kTagPriceRange) {
        
        if(component == 0)
            return _arrayPriceRangeMin.count;
        else
            return _arrayPriceRangeMax.count;
        
    }
    
    if(thePickerView.tag == kTagSquareFootage)
        return _arraySquareFootage.count;
    
    if(thePickerView.tag == kTagBuiltIn) {
        
        if(component == 0)
            return _arrayBuiltInMin.count;
        else
            return _arrayBuiltInMax.count;
        
    }
    
    if(thePickerView.tag == kTagLotSize)
        return _arrayLotSize.count;
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if(thePickerView.tag == kTagPriceRange) {
        
        if(component == 0)
            return [_arrayPriceRangeMin objectAtIndex:row];
        else
            return [_arrayPriceRangeMax objectAtIndex:row];
    }
    
    if(thePickerView.tag == kTagSquareFootage)
        return [_arraySquareFootage objectAtIndex:row];
    
    if(thePickerView.tag == kTagBuiltIn) {
        
        if(component == 0)
            return [_arrayBuiltInMin objectAtIndex:row];
        else
            return [_arrayBuiltInMax objectAtIndex:row];
    }
    
    if(thePickerView.tag == kTagLotSize)
        return [_arrayLotSize objectAtIndex:row];
    
    return nil;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //Here, like the table view you can get the each section of each row if you've multiple sections
    //    NSLog(@"Selected Color: %@. Index of selected color: %i", [arrayColors objectAtIndex:row], row);
    
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        [tView setTextColor:THEME_GREEN_TINT_COLOR];
        [tView setFont:[UIFont fontWithName:@"GillSans" size:17]];
        [tView setTextAlignment:NSTextAlignmentCenter];
    }
    // Fill the label text here

    if(pickerView.tag == kTagPriceRange) {
        
        if(component == 0)
            tView.text = [_arrayPriceRangeMin objectAtIndex:row];
        else
            tView.text = [_arrayPriceRangeMax objectAtIndex:row];
    }
    
    if(pickerView.tag == kTagSquareFootage)
        tView.text = [_arraySquareFootage objectAtIndex:row];
    
    if(pickerView.tag == kTagBuiltIn) {
        
        if(component == 0)
            tView.text = [_arrayBuiltInMin objectAtIndex:row];
        else
            tView.text = [_arrayBuiltInMax objectAtIndex:row];
    }
    
    if(pickerView.tag == kTagLotSize)
        tView.text = [_arrayLotSize objectAtIndex:row];
    
    return tView;
}


-(IBAction)didClickButtonSearch:(id)sender {
    
    [self beginParsing];
}

-(float)cleanStringToFloat:(NSString*)str {
    
    NSString* newStr = @"";
    for(int j = 0; j < [str length]; j++) {
        
        unichar ch = [str characterAtIndex:j];
        
        if(isnumber(ch)) {
            
            NSString* newChStr = [NSString stringWithFormat:@"%c", ch];
            newStr = [newStr stringByAppendingString:newChStr];
        }
    }
    
    return [newStr length] > 0 ? [newStr floatValue] : 0;
}


-(void)beginParsing {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = LOCALIZED(@"SEARCHING");
    
    [self.view addSubview:hud];
    [self.view setUserInteractionEnabled:NO];
	[hud showAnimated:YES whileExecutingBlock:^{
        
		[self doSearching];
        
	} completionBlock:^{
        
		[hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
        [self.searchResultDelegate searchResults:_arrayFilter];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
}

-(void) doSearching {
    
    NSString* keywords = [textFieldSearch text];
    
    NSString* status = [nestedTab.titles objectAtIndex:nestedTab.selectedTabIndex];
    
    int indexPriceMin = (int)[_searchView.pickerPrice selectedRowInComponent:0];
    int indexPriceMax = (int)[_searchView.pickerPrice selectedRowInComponent:1];
    
    NSString* strPriceMin = [_arrayPriceRangeMin objectAtIndex:indexPriceMin];
    NSString* strPriceMax = [_arrayPriceRangeMax objectAtIndex:indexPriceMax];
    
    NSString* propertyType = [[_searchView.buttonPropertyType titleLabel] text];
    
    NSString* strBeds = [_searchView.segmentBeds titleForSegmentAtIndex:_searchView.segmentBeds.selectedSegmentIndex];
    NSString* strBaths = [_searchView.segmentBaths titleForSegmentAtIndex:_searchView.segmentBaths.selectedSegmentIndex];
    
    int indexSquareFootage = (int)[_searchView.pickerSquareFootage selectedRowInComponent:0];
    NSString* strSquareFootage = [_arraySquareFootage objectAtIndex:indexSquareFootage];
    
    int indexYearsBuiltMin = (int)[_searchView.pickerYearsBuilt selectedRowInComponent:0];
    int indexYearsBuiltMax = (int)[_searchView.pickerYearsBuilt selectedRowInComponent:1];
    
    NSString* strYearsBuiltMin = [_arrayBuiltInMin objectAtIndex:indexYearsBuiltMin];
    NSString* strYearsBuiltMax = [_arrayBuiltInMax objectAtIndex:indexYearsBuiltMax];
    
    int indexLotSize = (int)[_searchView.pickerLotSize selectedRowInComponent:0];
    NSString* strLotSize = [_arrayLotSize objectAtIndex:indexLotSize];
    
    int countParams = 0;
    
    if(keywords.length > 0)
        countParams += 1;
    
    if(status.length > 0)
        countParams += 1;
    
    if(indexPriceMin != 0 || indexPriceMax != 0)
        countParams += 1;
    
    if(propertyType.length > 0)
        countParams += 1;
    
    if(_searchView.segmentBeds.selectedSegmentIndex != 0)
        countParams += 1;
    
    if(_searchView.segmentBaths.selectedSegmentIndex != 0)
        countParams += 1;
    
    if(indexSquareFootage != 0)
        countParams += 1;
    
    if(indexYearsBuiltMin != 0 || indexYearsBuiltMax != 0)
        countParams += 1;
    
    if(indexLotSize != 0)
        countParams += 1;
    
    _arrayFilter = [NSMutableArray new];
    NSArray* arrayRealEstates = [CoreDataController getRealEstates];
    
    for(RealEstate* realEstate in arrayRealEstates) {
        
        int qualifyCount = 0;
        
        if(keywords.length > 0) {
            
            if([realEstate.address containsString:keywords] ||
               [realEstate.zipcode containsString:keywords] ||
               [realEstate.country containsString:keywords]) {
                qualifyCount += 1;
            }
        }
        
        if(status.length > 0) {
            
            if([realEstate.status containsString:status]) {
                qualifyCount += 1;
            }
        }
        
        if(indexPriceMin != 0 || indexPriceMax != 0) {
            
            float priceMin = [self cleanStringToFloat:strPriceMin];
            float priceMax = [self cleanStringToFloat:strPriceMax];
            float realEstatePrice = [self cleanStringToFloat:realEstate.price];
            
            if(priceMin >= realEstatePrice && realEstatePrice <= priceMax) {
                qualifyCount += 1;
            }
        }
        
        if(propertyType.length > 0) {
            
            if([realEstate.property_type containsString:propertyType]) {
                qualifyCount += 1;
            }
        }
        
        if(_searchView.segmentBeds.selectedSegmentIndex != 0) {
            
            int noOfBeds = [self cleanStringToFloat:strBeds];
            int realEstateBeds = [self cleanStringToFloat:realEstate.beds];
            
            if(realEstateBeds >= noOfBeds) {
                qualifyCount += 1;
            }
        }
        
        if(_searchView.segmentBaths.selectedSegmentIndex != 0) {
            
            int noOfBaths = [self cleanStringToFloat:strBaths];
            int realEstateBaths = [self cleanStringToFloat:realEstate.baths];
            
            if(realEstateBaths >= noOfBaths) {
                qualifyCount += 1;
            }
        }
        
        if(indexSquareFootage != 0) {
            
            int sqFt = [self cleanStringToFloat:strSquareFootage];
            int realEstateSqFt = [self cleanStringToFloat:realEstate.sqft];
            
            if(realEstateSqFt >= sqFt) {
                qualifyCount += 1;
            }
        }
        
        if(indexYearsBuiltMin != 0 || indexYearsBuiltMax != 0) {
            
            float yearsBuiltMin = [self cleanStringToFloat:strYearsBuiltMin];
            float yearsBuiltMax = [self cleanStringToFloat:strYearsBuiltMax];
            float realEstateBuitIn = [self cleanStringToFloat:realEstate.built_in];
            
            if(yearsBuiltMin >= realEstateBuitIn && realEstateBuitIn <= yearsBuiltMax) {
                qualifyCount += 1;
            }
        }
        
        if(indexLotSize != 0) {
            
            int lotSize = [self cleanStringToFloat:strLotSize];
            int realEstateLotSize = [self cleanStringToFloat:realEstate.lot_size];
            
            if(realEstateLotSize >= lotSize) {
                qualifyCount += 1;
            }
        }
        
        if(countParams == qualifyCount)
            [_arrayFilter addObject:realEstate];
    }
    
}

-(void)showCancelButtonSearch:(float)toX {
    
    if(_isShowingCancelButton) {
        
        return;
    }

    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         
                         CGRect frameTextFieldSearch = textFieldSearch.frame;
                         CGRect frameImageViewSearch = imgViewSearch.frame;
                         CGRect frameButtonCancelSearch = buttonCancelSearch.frame;
                         
                         frameTextFieldSearch.size.width += toX;
                         frameImageViewSearch.size.width += toX;
                         frameButtonCancelSearch.origin.x += toX;
                         
                         textFieldSearch.frame = frameTextFieldSearch;
                         imgViewSearch.frame = frameImageViewSearch;
                         buttonCancelSearch.frame = frameButtonCancelSearch;
                     }
     
                     completion:^(BOOL finished) {
                         
                         _isShowingCancelButton = YES;
                     }
     ];
}


-(IBAction)didClickButtonCancelSearch:(id)sender {

    [self cancelSearch];
}

-(void)cancelSearch {
    
    _isShowingCancelButton = NO;
    imgViewSearch.image = _imgSearchBarDefault;
    [self showCancelButtonSearch:ADJUST_WIDTH];
    [textFieldSearch resignFirstResponder];
    
    int newY = self.view.frame.size.height - viewButtons.frame.size.height;
    [self moveViewButtonsAtY:newY];
}

@end
