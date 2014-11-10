//
//  Country.h
//  RealEstateFinder
//
//  
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Country : NSManagedObject

@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * country_id;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * updated_at;

@end
