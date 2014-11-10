//
//  PriceHistory.h
//  RealEstateFinder
//
//  
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PriceHistory : NSManagedObject

@property (nonatomic, retain) NSString * change;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSNumber * pricehistory_id;
@property (nonatomic, retain) NSNumber * realestate_id;
@property (nonatomic, retain) NSString * updated_at;

@end
