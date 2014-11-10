//
//  Favorite.h
//  RealEstateFinder
//
//
//  Copyright (c) 2014 MangasaurGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Favorite : NSManagedObject

@property (nonatomic, retain) NSNumber * favorite_id;
@property (nonatomic, retain) NSNumber * realestate_id;

@end
