//
//  AgentDetailViewController.h
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgentDetailViewController : UIViewController {
    MGRawView* _agentDetailView;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollViewMain;
@property (nonatomic, retain) Agent* agent;

@end
