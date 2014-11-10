//
//  SearchViewController.m
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
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
@synthesize buttonClearSearch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)updateSliderChangedPrice:(NMRangeSlider*)sender {
    
    NSNumberFormatter *formatterMin = [NSNumberFormatter new];
    [formatterMin setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formattedMin = [formatterMin stringFromNumber:[NSNumber numberWithInteger:_searchView.rangeSliderPrice.lowerValue]];
    _searchView.labelPriceMin.text = [NSString stringWithFormat:@"%@ %@",
                                      LOCALIZED_NOT_NULL(@"SEARCH_CURRENCY_SIGN"),
                                      formattedMin];
    
    NSNumberFormatter *formatterMax = [NSNumberFormatter new];
    [formatterMax setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formattedMax = [formatterMax stringFromNumber:[NSNumber numberWithInteger:_searchView.rangeSliderPrice.upperValue]];
    _searchView.labelPriceMax.text = [NSString stringWithFormat:@"%@ %@",
                                      LOCALIZED_NOT_NULL(@"SEARCH_CURRENCY_SIGN"),
                                      formattedMax];
}

- (void)updateSliderChangedBuiltIn:(NMRangeSlider*)sender {
    
    _searchView.labelBuiltInMin.text = [NSString stringWithFormat:@"%d",
                                        (int)_searchView.rangeSliderBuiltIn.lowerValue];
    
    _searchView.labelBuiltInMax.text = [NSString stringWithFormat:@"%d",
                                        (int)_searchView.rangeSliderBuiltIn.upperValue];
}

- (void)updateSliderChangedSquareFoot:(NMRangeSlider*)sender {
    
    NSNumberFormatter *formatterMin = [NSNumberFormatter new];
    [formatterMin setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formattedMin = [formatterMin stringFromNumber:[NSNumber numberWithInteger:_searchView.rangeSliderSquareFoot.lowerValue]];
    _searchView.labelSquareFootMin.text = [NSString stringWithFormat:@"%@",
                                        formattedMin];
    
    NSNumberFormatter *formatterMax = [NSNumberFormatter new];
    [formatterMax setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formattedMax = [formatterMax stringFromNumber:[NSNumber numberWithInteger:_searchView.rangeSliderSquareFoot.upperValue]];
    _searchView.labelSquareFootMax.text = [NSString stringWithFormat:@"%@",
                                        formattedMax];
}


- (void)updateSliderChangedLotSize:(NMRangeSlider*)sender {
    
    NSNumberFormatter *formatterMin = [NSNumberFormatter new];
    [formatterMin setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formattedMin = [formatterMin stringFromNumber:[NSNumber numberWithInteger:_searchView.rangeSliderLotSize.lowerValue]];
    _searchView.labelLotSizeMin.text = [NSString stringWithFormat:@"%@",
                                      formattedMin];
    
    NSNumberFormatter *formatterMax = [NSNumberFormatter new];
    [formatterMax setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formattedMax = [formatterMax stringFromNumber:[NSNumber numberWithInteger:_searchView.rangeSliderLotSize.upperValue]];
    _searchView.labelLotSizeMax.text = [NSString stringWithFormat:@"%@",
                                      formattedMax];
    
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
    textFieldSearch.placeholder = LOCALIZED(@"SEARCH_KEYWORDS");
    textFieldSearch.autocorrectionType = UITextAutocorrectionTypeNo;
    
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
    
    [buttonClearSearch setTitle:LOCALIZED(@"CLEAR") forState:UIControlStateNormal];
    [buttonClearSearch setTitle:LOCALIZED(@"CLEAR") forState:UIControlStateSelected];
    
    _searchView = [[SearchRawView alloc] initWithNibName:@"SearchView2"];
    scrollViewMain.contentSize = _searchView.frame.size;
    [scrollViewMain addSubview:_searchView];
    
    
     [_searchView.labelYearsBuilt setText:LOCALIZED(@"SEARCH_YEARS_BUILT")];
    [_searchView.labelBaths setText:LOCALIZED(@"SEARCH_BATHS")];
    [_searchView.labelBeds setText:LOCALIZED(@"SEARCH_BEDS")];
    [_searchView.labelFilters setText:LOCALIZED(@"SEARCH_FILTERS")];
    [_searchView.labelLotSize setText:LOCALIZED(@"SEARCH_LOT_SIZE")];
    [_searchView.labelPriceRange setText:LOCALIZED(@"SEARCH_PRICE_RANGE")];
    [_searchView.labelPropertyType setText:LOCALIZED(@"SEARCH_PROPERTY_TYPE")];
    [_searchView.labelSquareFootage setText:LOCALIZED(@"SEARCH_SQUARE_FOOTAGE")];
    

    [_searchView.buttonPropertyType addTarget:self
                                       action:@selector(didClickButtonPropertyType:)
                             forControlEvents:UIControlEventTouchUpInside];
    
    
    
    viewButtons.backgroundColor = [THEME_GREEN_TINT_COLOR colorWithAlphaComponent:0.7];
    viewButtons.layer.zPosition = 999;
    
    
    
    [_searchView.segmentBaths setTintColor:THEME_GREEN_TINT_COLOR];
    [_searchView.segmentBeds setTintColor:THEME_GREEN_TINT_COLOR];
    
    
    SearchParams* params = [CoreDataController getSearchParamsBySearchId:1];
    
    if(params != nil) {
        _statusIndex = [params.status_index intValue];
        _priceRangeMin = [params.price_range_min intValue];
        _priceRangeMax = [params.price_range_max intValue];
        _propertyType = params.property_type;
        _bedsIndex = [params.beds_index intValue];
        _bathsIndex = [params.baths_index intValue];
        _sqftMin = [params.sqft_min intValue];
        _sqftMax = [params.sqft_max intValue];
        _yearsBuiltMin = [params.years_built_min intValue];
        _yearsBuiltMax = [params.years_built_max intValue];
        _lotSizeMin = [params.lot_size_min intValue];
        _lotSizeMax = [params.lot_size_max intValue];
        
    } else {
        _statusIndex = STATUS_INDEX_DEFAULT;
        _priceRangeMin = PRICE_RANGE_MIN_DEFAULT;
        _priceRangeMax = PRICE_RANGE_MAX_DEFAULT;
        _propertyType = PROPERTY_TYPE_DEFAULT;
        _bedsIndex = BEDS_INDEX_DEFAULT;
        _bathsIndex = BATHS_INDEX_DEFAULT;
        _sqftMin = SQUARE_FEET_MIN_DEFAULT;
        _sqftMax = SQUARE_FEET_MAX_DEFAULT;
        _yearsBuiltMin = YEARS_BUILT_IN_MIN_DEFAULT;
        _yearsBuiltMax = YEARS_BUILT_IN_MAX_DEFAULT;
        _lotSizeMin = LOT_SIZE_MIN_DEFAULT;
        _lotSizeMax = LOT_SIZE_MAX_DEFAULT;
    }
    
    [_searchView.buttonPropertyType setTitle:_propertyType
                                    forState:UIControlStateNormal];
    
    [_searchView.buttonPropertyType setTitle:_propertyType
                                    forState:UIControlStateSelected];
    
    [nestedTab setSelectedTab:_statusIndex];
    
    UIImage* image = nil;
    
    image = [UIImage imageNamed:SLIDER_TRACK];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    _searchView.rangeSliderPrice.trackBackgroundImage = image;
    
    image = [UIImage imageNamed:SLIDER_FILL];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)];
    _searchView.rangeSliderPrice.trackImage = image;
    
    image = [UIImage imageNamed:SLIDER_HANDLE];
    _searchView.rangeSliderPrice.lowerHandleImageNormal = image;
    _searchView.rangeSliderPrice.upperHandleImageNormal = image;
    
    image = [UIImage imageNamed:SLIDER_HANDLE_SELECTED];
    _searchView.rangeSliderPrice.lowerHandleImageHighlighted = image;
    _searchView.rangeSliderPrice.upperHandleImageHighlighted = image;
    
    _searchView.rangeSliderPrice.minimumValue = PRICE_RANGE_MIN_DEFAULT;
    _searchView.rangeSliderPrice.maximumValue = PRICE_RANGE_MAX_DEFAULT;
    
    _searchView.rangeSliderPrice.upperValue = _priceRangeMax; //4000000;
    _searchView.rangeSliderPrice.lowerValue = _priceRangeMin; //0;
    
    _searchView.rangeSliderPrice.minimumRange = PRICE_RANGE_MIN_RANGE;
    _searchView.rangeSliderPrice.stepValue = PRICE_RANGE_STEP_VALUE;
    [self updateSliderChangedPrice:_searchView.rangeSliderPrice];
    
    [_searchView.rangeSliderPrice addTarget:self
                                     action:@selector(updateSliderChangedPrice:)
                           forControlEvents:UIControlEventValueChanged];
    
    
    
    image = [UIImage imageNamed:SLIDER_TRACK];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    _searchView.rangeSliderBuiltIn.trackBackgroundImage = image;
    
    image = [UIImage imageNamed:SLIDER_FILL];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)];
    _searchView.rangeSliderBuiltIn.trackImage = image;
    
    image = [UIImage imageNamed:SLIDER_HANDLE];
    _searchView.rangeSliderBuiltIn.lowerHandleImageNormal = image;
    _searchView.rangeSliderBuiltIn.upperHandleImageNormal = image;
    
    image = [UIImage imageNamed:SLIDER_HANDLE_SELECTED];
    _searchView.rangeSliderBuiltIn.lowerHandleImageHighlighted = image;
    _searchView.rangeSliderBuiltIn.upperHandleImageHighlighted = image;
    
    _searchView.rangeSliderBuiltIn.minimumValue = YEARS_BUILT_IN_MIN_DEFAULT;
    _searchView.rangeSliderBuiltIn.maximumValue = YEARS_BUILT_IN_MAX_DEFAULT;
    
    _searchView.rangeSliderBuiltIn.upperValue = _yearsBuiltMax; //2014;
    _searchView.rangeSliderBuiltIn.lowerValue = _yearsBuiltMin; //1900;
    
    _searchView.rangeSliderBuiltIn.minimumRange = YEARS_BUILT_IN_MIN_RANGE;
    _searchView.rangeSliderBuiltIn.stepValue = YEARS_BUILT_IN_STEP_VALUE;
    [self updateSliderChangedBuiltIn:_searchView.rangeSliderBuiltIn];
    
    [_searchView.rangeSliderBuiltIn addTarget:self
                                     action:@selector(updateSliderChangedBuiltIn:)
                           forControlEvents:UIControlEventValueChanged];
    
    
    
    image = [UIImage imageNamed:SLIDER_TRACK];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    _searchView.rangeSliderSquareFoot.trackBackgroundImage = image;
    
    image = [UIImage imageNamed:SLIDER_FILL];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)];
    _searchView.rangeSliderSquareFoot.trackImage = image;
    
    image = [UIImage imageNamed:SLIDER_HANDLE];
    _searchView.rangeSliderSquareFoot.lowerHandleImageNormal = image;
    _searchView.rangeSliderSquareFoot.upperHandleImageNormal = image;
    
    image = [UIImage imageNamed:SLIDER_HANDLE_SELECTED];
    _searchView.rangeSliderSquareFoot.lowerHandleImageHighlighted = image;
    _searchView.rangeSliderSquareFoot.upperHandleImageHighlighted = image;
    
    _searchView.rangeSliderSquareFoot.minimumValue = SQUARE_FEET_MIN_DEFAULT;
    _searchView.rangeSliderSquareFoot.maximumValue = SQUARE_FEET_MAX_DEFAULT;
    
    _searchView.rangeSliderSquareFoot.upperValue = _sqftMax; //4000;
    _searchView.rangeSliderSquareFoot.lowerValue = _sqftMin; //0;
    
    _searchView.rangeSliderSquareFoot.minimumRange = SQUARE_FEET_MIN_RANGE;
    _searchView.rangeSliderSquareFoot.stepValue = SQUARE_FEET_STEP_VALUE;
    [self updateSliderChangedSquareFoot:_searchView.rangeSliderSquareFoot];
    
    [_searchView.rangeSliderSquareFoot addTarget:self
                                       action:@selector(updateSliderChangedSquareFoot:)
                             forControlEvents:UIControlEventValueChanged];
    
    
    
    image = [UIImage imageNamed:SLIDER_TRACK];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    _searchView.rangeSliderLotSize.trackBackgroundImage = image;
    
    image = [UIImage imageNamed:SLIDER_FILL];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)];
    _searchView.rangeSliderLotSize.trackImage = image;
    
    image = [UIImage imageNamed:SLIDER_HANDLE];
    _searchView.rangeSliderLotSize.lowerHandleImageNormal = image;
    _searchView.rangeSliderLotSize.upperHandleImageNormal = image;
    
    image = [UIImage imageNamed:SLIDER_HANDLE_SELECTED];
    _searchView.rangeSliderLotSize.lowerHandleImageHighlighted = image;
    _searchView.rangeSliderLotSize.upperHandleImageHighlighted = image;
    
    _searchView.rangeSliderLotSize.minimumValue = LOT_SIZE_MIN_DEFAULT;
    _searchView.rangeSliderLotSize.maximumValue = LOT_SIZE_MAX_DEFAULT;
    
    _searchView.rangeSliderLotSize.upperValue = _lotSizeMax; //50000;
    _searchView.rangeSliderLotSize.lowerValue = _lotSizeMin; //2000;
    
    _searchView.rangeSliderLotSize.minimumRange = LOT_SIZE_MIN_RANGE;
    _searchView.rangeSliderLotSize.stepValue = LOT_SIZE_STEP_VALUE;
    [self updateSliderChangedLotSize:_searchView.rangeSliderLotSize];
    
    
    [_searchView.segmentBaths setSelectedSegmentIndex:_bathsIndex];
    [_searchView.segmentBeds setSelectedSegmentIndex:_bedsIndex];
    
    [_searchView.rangeSliderLotSize addTarget:self
                                          action:@selector(updateSliderChangedLotSize:)
                                forControlEvents:UIControlEventValueChanged];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    
    UIEdgeInsets inset = scrollViewMain.contentInset;
    inset.bottom = viewButtons.frame.size.height;
    scrollViewMain.contentInset = inset;
    
    UIEdgeInsets scrollInset = scrollViewMain.scrollIndicatorInsets;
    scrollInset.bottom = viewButtons.frame.size.height;
    scrollViewMain.scrollIndicatorInsets = scrollInset;
    
    if(SHOW_ADS_SEARCH_VIEW) {
        
        UIEdgeInsets inset = scrollViewMain.contentInset;
        inset.top = ADV_VIEW_OFFSET;
        scrollViewMain.contentInset = inset;
        
        inset = scrollViewMain.scrollIndicatorInsets;
        inset.top = ADV_VIEW_OFFSET;
        scrollViewMain.scrollIndicatorInsets = inset;
        
        [MGUtilities createAdAtY:110
                  viewController:self
                         bgColor:AD_BG_COLOR];
    }
}

-(void)keyboardDidShow:(id)sender {
    
    UIEdgeInsets inset = scrollViewMain.contentInset;
    inset.bottom = 216;
    scrollViewMain.contentInset = inset;
    
    inset = scrollViewMain.scrollIndicatorInsets;
    inset.bottom = 216;
    scrollViewMain.scrollIndicatorInsets = inset;
}

-(void)keyboardDidHide:(id)sender {
    
    UIEdgeInsets inset = scrollViewMain.contentInset;
    inset.bottom = NAV_BAR_OFFSET;
    scrollViewMain.contentInset = inset;
    
    inset = scrollViewMain.scrollIndicatorInsets;
    inset.bottom = NAV_BAR_OFFSET;
    scrollViewMain.scrollIndicatorInsets = inset;
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
    
    NSString* status = [nestedTab.titles  objectAtIndex:nestedTab.selectedTabIndex];
    
    int priceMin = _searchView.rangeSliderPrice.lowerValue;
    int priceMax = _searchView.rangeSliderPrice.upperValue;
    
    NSString* propertyType = [[_searchView.buttonPropertyType titleLabel] text];
    
    NSString* strBeds = [_searchView.segmentBeds titleForSegmentAtIndex:_searchView.segmentBeds.selectedSegmentIndex];
    NSString* strBaths = [_searchView.segmentBaths titleForSegmentAtIndex:_searchView.segmentBaths.selectedSegmentIndex];

    int squareFootageMin = _searchView.rangeSliderSquareFoot.lowerValue;
    int squareFootageMax = _searchView.rangeSliderSquareFoot.upperValue;
    
    int yearsBuiltMin = _searchView.rangeSliderBuiltIn.lowerValue;
    int yearsBuiltMax = _searchView.rangeSliderBuiltIn.upperValue;
    
    int lotSizeMin = _searchView.rangeSliderLotSize.lowerValue;
    int lotSizeMax = _searchView.rangeSliderLotSize.upperValue;
    
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    NSString* className = NSStringFromClass([SearchParams class]);
    NSEntityDescription *entity = [NSEntityDescription entityForName:className
                                              inManagedObjectContext:context];
    
    SearchParams* paramsStored = (SearchParams*)[[NSManagedObject alloc] initWithEntity:entity
                                                         insertIntoManagedObjectContext:nil];
    
    paramsStored.status_index = [NSNumber numberWithInt:nestedTab.selectedTabIndex];
    paramsStored.price_range_min = [NSNumber numberWithInt:priceMin];
    paramsStored.price_range_max = [NSNumber numberWithInt:priceMax];
    paramsStored.property_type = propertyType;
    paramsStored.beds_index = [NSNumber numberWithInteger:[_searchView.segmentBeds selectedSegmentIndex]];
    paramsStored.baths_index = [NSNumber numberWithInteger:[_searchView.segmentBaths selectedSegmentIndex]];
    paramsStored.sqft_min = [NSNumber numberWithInt:squareFootageMin];
    paramsStored.sqft_max = [NSNumber numberWithInt:squareFootageMax];
    paramsStored.years_built_min = [NSNumber numberWithInt:yearsBuiltMin];
    paramsStored.years_built_max = [NSNumber numberWithInt:yearsBuiltMax];
    paramsStored.lot_size_min = [NSNumber numberWithInt:lotSizeMin];
    paramsStored.lot_size_max = [NSNumber numberWithInt:lotSizeMax];
    
    [CoreDataController insertSearchParams:paramsStored];
    
    
    
    int countParams = 0;
    
    if(keywords.length > 0)
        countParams += 1;
    
    if(status.length > 0)
        countParams += 1;
    
    if(priceMin >= 0 && priceMax >= 0)
        countParams += 1;
    
    if(propertyType.length > 0 && ![propertyType containsString:LOCALIZED_NOT_NULL(@"ALL_TYPE")])
        countParams += 1;
    
    if(_searchView.segmentBeds.selectedSegmentIndex != 0)
        countParams += 1;
    
    if(_searchView.segmentBaths.selectedSegmentIndex != 0)
        countParams += 1;
    
    if(squareFootageMin >= 0 && squareFootageMax >= 0)
        countParams += 1;
    
    if(yearsBuiltMin >= 0 && yearsBuiltMin >= 0)
        countParams += 1;
    
    if(lotSizeMin >= 0 && lotSizeMax >= 0)
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
        
        if(priceMin >= 0 && priceMax >= 0) {
            
            float realEstatePrice = [self cleanStringToFloat:realEstate.price];
            if(realEstatePrice >= priceMin && realEstatePrice <= priceMax) {
                qualifyCount += 1;
            }
        }
        
        if(propertyType.length > 0 && ![propertyType containsString:LOCALIZED_NOT_NULL(@"ALL_TYPE")]) {
            
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
        
        if(squareFootageMin >= 0 && squareFootageMax >= 0) {
            
            int realEstateSqFt = [self cleanStringToFloat:realEstate.sqft];
            
            if(realEstateSqFt >= squareFootageMin && realEstateSqFt <= squareFootageMax) {
                qualifyCount += 1;
            }
        }
        
        if(yearsBuiltMin >= 0 && yearsBuiltMin >= 0) {
            
            float realEstateBuitIn = [self cleanStringToFloat:realEstate.built_in];
            
            if(realEstateBuitIn >= yearsBuiltMin && realEstateBuitIn <= yearsBuiltMax) {
                qualifyCount += 1;
            }
        }
        
        if(lotSizeMin >= 0 && lotSizeMax >= 0) {
            
            int realEstateLotSize = [self cleanStringToFloat:realEstate.lot_size];
            
            if(realEstateLotSize >= lotSizeMin && realEstateLotSize <= lotSizeMax) {
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

-(void)didClickButtonPropertyType:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    PTypeViewController* pTypeViewController = [storyboard instantiateViewControllerWithIdentifier:@"storyboardPropertyType"];
    pTypeViewController.propertyTypeDelegate = self;
    
    NSMutableArray* array = [NSMutableArray new];
    [array insertObject:LOCALIZED_NOT_NULL(@"ALL_TYPE") atIndex:0];
    
    NSArray* arrayPropertyType = [CoreDataController getPropertyTypes];
    
    for(PropertyType* type in arrayPropertyType)
        [array addObject:type.property_type];
    
    pTypeViewController.arrayData = array;
    
    [self.navigationController pushViewController:pTypeViewController animated:YES];
    
}

-(void)didSelectPropertyType:(NSString *)propertyType {
    
    [_searchView.buttonPropertyType setTitle:propertyType
                                    forState:UIControlStateNormal];
    
    [_searchView.buttonPropertyType setTitle:propertyType
                                    forState:UIControlStateSelected];
}

-(IBAction)didClickButtonClearSearch:(id)sender {
    
    _statusIndex = STATUS_INDEX_DEFAULT;
    _priceRangeMin = PRICE_RANGE_MIN_DEFAULT;
    _priceRangeMax = PRICE_RANGE_MAX_DEFAULT;
    _propertyType = PROPERTY_TYPE_DEFAULT;
    _bedsIndex = BEDS_INDEX_DEFAULT;
    _bathsIndex = BATHS_INDEX_DEFAULT;
    _sqftMin = SQUARE_FEET_MIN_DEFAULT;
    _sqftMax = SQUARE_FEET_MAX_DEFAULT;
    _yearsBuiltMin = YEARS_BUILT_IN_MIN_DEFAULT;
    _yearsBuiltMax = YEARS_BUILT_IN_MAX_DEFAULT;
    _lotSizeMin = LOT_SIZE_MIN_DEFAULT;
    _lotSizeMax = LOT_SIZE_MAX_DEFAULT;
    
    [_searchView.buttonPropertyType setTitle:_propertyType
                                    forState:UIControlStateNormal];
    
    [_searchView.buttonPropertyType setTitle:_propertyType
                                    forState:UIControlStateSelected];
    
    [nestedTab setSelectedTab:_statusIndex];
    
    [_searchView.segmentBaths setSelectedSegmentIndex:_bathsIndex];
    [_searchView.segmentBeds setSelectedSegmentIndex:_bedsIndex];

    _searchView.rangeSliderPrice.upperValue = _priceRangeMax;
    _searchView.rangeSliderPrice.lowerValue = _priceRangeMin;
    
    _searchView.rangeSliderSquareFoot.upperValue = _sqftMax;
    _searchView.rangeSliderSquareFoot.lowerValue = _sqftMin;
    
    _searchView.rangeSliderLotSize.upperValue = _lotSizeMax;
    _searchView.rangeSliderLotSize.lowerValue = _lotSizeMin;
    
    _searchView.rangeSliderBuiltIn.upperValue = _yearsBuiltMax;
    _searchView.rangeSliderBuiltIn.lowerValue = _yearsBuiltMin;
    
    [self updateSliderChangedBuiltIn:_searchView.rangeSliderBuiltIn];
    [self updateSliderChangedLotSize:_searchView.rangeSliderLotSize];
    [self updateSliderChangedPrice:_searchView.rangeSliderPrice];
    [self updateSliderChangedSquareFoot:_searchView.rangeSliderSquareFoot];
}


@end
