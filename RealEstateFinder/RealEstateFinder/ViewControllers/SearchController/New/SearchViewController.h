//
//  SearchViewController.h
//  RealEstateFinder
//
//  Created by Jonnel Ryan on 6/6/14.
//  Copyright (c) 2014 Client. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchResultDelegate <NSObject>

-(void) searchResults:(NSMutableArray*)array;

@end

@interface SearchViewController : UIViewController <MGNestedTabDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate> {
    
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
}

@property (nonatomic, retain) IBOutlet MGRawScrollView* scrollViewMain;

@property (nonatomic, retain) IBOutlet MGNestedTab* nestedTab;

@property (nonatomic, retain) IBOutlet UITextField* textFieldSearch;
@property (nonatomic, retain) IBOutlet UIImageView* imgViewSearch;

@property (nonatomic, retain) IBOutlet UIView* viewButtons;
@property (nonatomic, retain) IBOutlet UIButton* buttonCancel;
@property (nonatomic, retain) IBOutlet UIButton* buttonSearch;

@property (nonatomic, retain) IBOutlet UIButton* buttonCancelSearch;

-(IBAction)didClickButtonCancel:(id)sender;
-(IBAction)didClickButtonSearch:(id)sender;
-(IBAction)didClickButtonCancelSearch:(id)sender;

@property (nonatomic, retain) id <SearchResultDelegate> searchResultDelegate;

@end
