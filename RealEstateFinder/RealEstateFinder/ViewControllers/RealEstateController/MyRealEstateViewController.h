//
//  MyRealEstateViewController.h
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRealEstateViewController : UIViewController <MGListViewDelegate>

@property (nonatomic, retain) IBOutlet MGListView* listView;

-(IBAction)addRealEstate:(id)sender;

@end
