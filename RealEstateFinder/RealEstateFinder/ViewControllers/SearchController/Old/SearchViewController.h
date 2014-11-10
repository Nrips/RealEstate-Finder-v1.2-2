//
//  SearchViewController.h
//  RealEstateFinder
//
//  Created by Jonnel Ryan on 6/6/14.
//  Copyright (c) 2014 Client. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <MGNestedTabDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    
    NSMutableArray* arrayPriceRangeMin;
    NSMutableArray* arrayPriceRangeMax;
}

@property (nonatomic, retain) IBOutlet MGNestedTab* nestedTab;

@property (nonatomic, retain) IBOutlet UITextField* textFieldSearch;
@property (nonatomic, retain) IBOutlet UIImageView* imgViewSearch;
@property (nonatomic, retain) IBOutlet UITableView* tableViewMain;

@property (nonatomic, retain) IBOutlet UIView* viewButtons;
@property (nonatomic, retain) IBOutlet UIButton* buttonCancel;
@property (nonatomic, retain) IBOutlet UIButton* buttonSearch;

-(IBAction)didClickButtonCancel:(id)sender;
-(IBAction)didClickButtonSearch:(id)sender;

@end
