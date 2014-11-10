//
//  AddressSearchMapVC.h
//  RealEstateFinder
//
//  Created by utk@rsh on 04/11/14.
//  Copyright (c) 2014 Client. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressSearchMapVC : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate>
{
    UISearchDisplayController *searchDisplayController;
}

@property (nonatomic, retain) NSMutableArray *listContent;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) UISearchDisplayController	*searchDisplayController;

@end
