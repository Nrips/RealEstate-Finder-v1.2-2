//
//  FeaturedViewController.h
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeaturedViewController : UIViewController <MGListViewDelegate>

@property (nonatomic, retain) IBOutlet MGListView* listView;

@end
