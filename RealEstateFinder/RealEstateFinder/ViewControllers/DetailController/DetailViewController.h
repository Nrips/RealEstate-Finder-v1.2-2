//
//  DetailViewController.h
//  RealEstateFinder
//
//  
//  Copyright (c) 2014 MangasaurGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <MGListViewDelegate, UIGestureRecognizerDelegate, MGMapViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    MGRawView* _headerView;
    MGRawView* _commandView;
    float _imageHeight;
    float _lastY;
    BOOL _isAnimatingCommandView;
    NSArray* _arrayPhotos;
}

@property (nonatomic, retain) IBOutlet MGListView* tableViewMain;
@property (nonatomic, retain) RealEstate* realEstate;

@end
