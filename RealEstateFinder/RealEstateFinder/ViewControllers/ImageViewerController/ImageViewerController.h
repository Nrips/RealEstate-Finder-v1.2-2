//
//  ImageViewerController.h
//  RealEstateFinder
//
//  
//  Copyright (c) 2014 MangasaurGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewerController : UIViewController <MGImageViewerDelegate>

@property (nonatomic, retain) IBOutlet MGImageViewer* imageViewer;
@property (nonatomic, retain) NSArray* imageArray;
@property (nonatomic, assign) int selectedIndex;

-(IBAction)didClickBarButtonDone:(id)sender;

@end
