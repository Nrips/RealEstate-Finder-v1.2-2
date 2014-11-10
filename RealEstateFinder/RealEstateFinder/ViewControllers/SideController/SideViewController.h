//
//  SideViewController.h
//  RealEstateFinder
//
//  
//  Copyright (c) 2014 MangasaurGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
    
    BOOL _isLoggedIn;
    NSMutableArray* _arrayUserSettings;
}

@property(nonatomic, retain) IBOutlet UITableView* tableViewSide;
@property (nonatomic, retain) UIActionSheet* actionSheet;

-(IBAction)didClickFoldButton:(id)sender;
@end
