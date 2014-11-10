//
//  AgentAddViewController.h
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgentImagesViewController.h"
#import "UserSession.h"

@interface AgentAddViewController : UIViewController<AgentPhotosDelegate, UITextFieldDelegate> {

    MGRawView* _agentView;
    int _index;
}

@property (nonatomic, retain) IBOutlet MGRawScrollView* scrollViewMain;
@property (nonatomic, retain) NSMutableArray* arrayPhotos;
@property (nonatomic, strong) UserSession*usersession;

@end
