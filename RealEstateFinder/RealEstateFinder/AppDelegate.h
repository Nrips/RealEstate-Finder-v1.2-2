//
//  AppDelegate.h
//  RealEstateFinder
//
//  
//  Copyright (c) 2014 MangasaurGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"
#import "SideViewController.h"
#import "PaperFoldNavigationController.h"
#import <MapKit/MapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) ContentViewController* contentViewController;
@property (nonatomic, strong) SideViewController* sideViewController;
@property (nonatomic, strong) PaperFoldNavigationController* paperFoldNavController;

@property (nonatomic, assign) CLLocationCoordinate2D recentSearchedDestinationCoordinate;
@property (nonatomic, strong) NSMutableArray *recentPlacesArray;
@property (nonatomic, strong) NSString *destinationString;
@property (nonatomic, strong) NSString *directionRouteType;

+(AppDelegate*) instance;
+(void) foldLeftView;
+(void) unfoldLeftView;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSString *strTitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) MKPlacemark *placemark;
@property (nonatomic, strong) MKMapItem *mapItem;

@property (strong, nonatomic) FBSession *session;

@end
