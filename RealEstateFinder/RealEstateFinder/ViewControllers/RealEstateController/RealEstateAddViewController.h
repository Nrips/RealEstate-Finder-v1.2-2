//
//  AgentAddViewController.h
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealEstateImagesViewController.h"
#import "PTypeViewController.h"

@interface RealEstateAddViewController : UIViewController<RealEstatePhotosDelegate, UITextFieldDelegate, UITextViewDelegate, MGMapViewDelegate, CLLocationManagerDelegate, PropertyTypeDelegate> {
    
    CLLocationManager* _myLocationManager;
    CLLocation* _myLocation;
    MGRawView* _realEstateView;
    int _index;
    NSString* _realestate_id;
    CLLocationCoordinate2D _dropAtCoords;
}

@property (nonatomic, retain) IBOutlet MGRawScrollView* scrollViewMain;
@property (nonatomic, retain) NSMutableArray* arrayPhotos;

@end
