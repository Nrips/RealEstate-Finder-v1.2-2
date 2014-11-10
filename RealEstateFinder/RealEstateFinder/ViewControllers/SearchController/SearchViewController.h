//
//  SearchViewController.h
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTypeViewController.h"

@protocol SearchResultDelegate <NSObject>

-(void) searchResults:(NSMutableArray*)array;

@end

@interface SearchViewController : UIViewController <MGNestedTabDelegate, UITextFieldDelegate, PropertyTypeDelegate> {
    
    SearchRawView* _searchView;
    NSMutableArray* _arrayPriceRangeMin;
    NSMutableArray* _arrayPriceRangeMax;
    NSMutableArray* _arraySquareFootage;
    
    NSMutableArray* _arrayBuiltInMin;
    NSMutableArray* _arrayBuiltInMax;
    NSMutableArray* _arrayLotSize;
    
    NSString* _status;
    
    id <SearchResultDelegate> _searchResultDelegate;
    
    NSMutableArray* _arrayFilter;
    
    UIImage* _imgSearchBarDefault;
    UIImage* _imgSearchBarSelected;
    
    BOOL _isShowingCancelButton;
    
    int _statusIndex;
    int _priceRangeMin;
    int _priceRangeMax;
    NSString* _propertyType;
    int _bedsIndex;
    int _bathsIndex;
    int _sqftMin;
    int _sqftMax;
    int _yearsBuiltMin;
    int _yearsBuiltMax;
    int _lotSizeMin;
    int _lotSizeMax;
}

@property (nonatomic, retain) IBOutlet MGRawScrollView* scrollViewMain;

@property (nonatomic, retain) IBOutlet MGNestedTab* nestedTab;

@property (nonatomic, retain) IBOutlet UITextField* textFieldSearch;
@property (nonatomic, retain) IBOutlet UIImageView* imgViewSearch;

@property (nonatomic, retain) IBOutlet UIView* viewButtons;
@property (nonatomic, retain) IBOutlet UIButton* buttonCancel;
@property (nonatomic, retain) IBOutlet UIButton* buttonSearch;

@property (nonatomic, retain) IBOutlet UIButton* buttonCancelSearch;
@property (nonatomic, retain) IBOutlet UIButton* buttonClearSearch;

-(IBAction)didClickButtonCancel:(id)sender;
-(IBAction)didClickButtonSearch:(id)sender;
-(IBAction)didClickButtonCancelSearch:(id)sender;
-(IBAction)didClickButtonClearSearch:(id)sender;

@property (nonatomic, retain) id <SearchResultDelegate> searchResultDelegate;

@end
