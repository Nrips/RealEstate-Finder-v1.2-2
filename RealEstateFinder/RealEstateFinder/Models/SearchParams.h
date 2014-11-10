//
//  SearchParams.h
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SearchParams : NSManagedObject

@property (nonatomic, retain) NSNumber * status_index;
@property (nonatomic, retain) NSNumber * price_range_min;
@property (nonatomic, retain) NSNumber * price_range_max;
@property (nonatomic, retain) NSString * property_type;
@property (nonatomic, retain) NSNumber * beds_index;
@property (nonatomic, retain) NSNumber * baths_index;
@property (nonatomic, retain) NSNumber * sqft_min;
@property (nonatomic, retain) NSNumber * sqft_max;
@property (nonatomic, retain) NSNumber * years_built_min;
@property (nonatomic, retain) NSNumber * years_built_max;
@property (nonatomic, retain) NSNumber * lot_size_min;
@property (nonatomic, retain) NSNumber * lot_size_max;
@property (nonatomic, retain) NSNumber * search_id;

@end
