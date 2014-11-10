//
//  PropertyType.h
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PropertyType : NSManagedObject

@property (nonatomic, retain) NSNumber * propertytype_id;
@property (nonatomic, retain) NSString * property_type;
@property (nonatomic, retain) NSString * updated_at;
@property (nonatomic, retain) NSString * created_at;

@end
