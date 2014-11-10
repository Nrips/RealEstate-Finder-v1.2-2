//
//  SearchRawView.h
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchRawView : UIView

//@property (nonatomic, retain) IBOutlet UIPickerView* pickerPrice;
@property (nonatomic, retain) IBOutlet UIButton* buttonPropertyType;
@property (nonatomic, retain) IBOutlet UISegmentedControl* segmentBeds;
@property (nonatomic, retain) IBOutlet UISegmentedControl* segmentBaths;

//@property (nonatomic, retain) IBOutlet UIPickerView* pickerSquareFootage;
//@property (nonatomic, retain) IBOutlet UIPickerView* pickerYearsBuilt;
//@property (nonatomic, retain) IBOutlet UIPickerView* pickerLotSize;

@property (nonatomic, retain) IBOutlet NMRangeSlider* rangeSliderPrice;
@property (nonatomic, retain) IBOutlet NMRangeSlider* rangeSliderSquareFoot;
@property (nonatomic, retain) IBOutlet NMRangeSlider* rangeSliderBuiltIn;
@property (nonatomic, retain) IBOutlet NMRangeSlider* rangeSliderLotSize;

@property (nonatomic, retain) IBOutlet UILabel* labelPriceMin;
@property (nonatomic, retain) IBOutlet UILabel* labelPriceMax;

@property (nonatomic, retain) IBOutlet UILabel* labelSquareFootMin;
@property (nonatomic, retain) IBOutlet UILabel* labelSquareFootMax;

@property (nonatomic, retain) IBOutlet UILabel* labelBuiltInMin;
@property (nonatomic, retain) IBOutlet UILabel* labelBuiltInMax;

@property (nonatomic, retain) IBOutlet UILabel* labelLotSizeMin;
@property (nonatomic, retain) IBOutlet UILabel* labelLotSizeMax;

@property (nonatomic, retain) IBOutlet UILabel* labelFilters;
@property (nonatomic, retain) IBOutlet UILabel* labelPriceRange;
@property (nonatomic, retain) IBOutlet UILabel* labelPropertyType;
@property (nonatomic, retain) IBOutlet UILabel* labelBeds;
@property (nonatomic, retain) IBOutlet UILabel* labelBaths;
@property (nonatomic, retain) IBOutlet UILabel* labelSquareFootage;
@property (nonatomic, retain) IBOutlet UILabel* labelYearsBuilt;
@property (nonatomic, retain) IBOutlet UILabel* labelLotSize;

-(id)initWithNibName:(NSString*)nibNameOrNil;

- (id)initWithFrame:(CGRect)frame nibName:(NSString*)nibNameOrNil;

@end
