//
//  RealEstate.h
//  RealEstateFinder
//
//  
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RealEstate : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * agent_id;
@property (nonatomic, retain) NSString * baths;
@property (nonatomic, retain) NSString * beds;
@property (nonatomic, retain) NSString * built_in;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * featured;
@property (nonatomic, retain) NSString * lat;
@property (nonatomic, retain) NSString * lon;
@property (nonatomic, retain) NSString * lot_size;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * price_per_sqft;
@property (nonatomic, retain) NSString * property_type;
@property (nonatomic, retain) NSNumber * realestate_id;
@property (nonatomic, retain) NSString * rooms;
@property (nonatomic, retain) NSString * sqft;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * updated_at;
@property (nonatomic, retain) NSString * zipcode;

@end
