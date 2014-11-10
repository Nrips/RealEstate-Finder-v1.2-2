//
//  Detail2ViewController.h
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Detail2ViewController : UIViewController <UIScrollViewDelegate> {
    
    MGRawView* _detailImageView;
    MGRawView* _detailView;
    float _imageHeight;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollViewMain;
@property (nonatomic, retain) RealEstate* realEstate;

@end
