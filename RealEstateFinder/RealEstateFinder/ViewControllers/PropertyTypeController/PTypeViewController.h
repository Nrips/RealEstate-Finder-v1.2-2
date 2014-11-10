//
//  PTypeViewController.h
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PropertyTypeDelegate <NSObject>

-(void) didSelectPropertyType:(NSString*)propertyType;

@end

@interface PTypeViewController : UIViewController <MGListViewDelegate> {
    
    id <PropertyTypeDelegate> _propertyTypeDelegate;
}

@property (nonatomic, retain) IBOutlet MGListView* listView;
@property (nonatomic, retain) NSMutableArray* arrayData;
@property (nonatomic, retain) id <PropertyTypeDelegate> propertyTypeDelegate;

@end
