//
//  CoreDataController.m
//  RealEstateFinder
//
//  
//  Copyright (c) 2014 MangasaurGames. All rights reserved.
//

#import "CoreDataController.h"
#import "AppDelegate.h"

@implementation CoreDataController

+(void) deleteAllObjects:(NSString *) entityDescription {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    if(items != nil) {
        for (NSManagedObject *managedObject in items) {
            if(managedObject != nil)
                [context deleteObject:managedObject];
        }
        
        NSLog(@"Deleted %d %@ item(s)", (int)items.count, entityDescription);
        
        if (![context save:&error]) {
            NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
        }
    }
    
}


+(NSArray*) getCountries {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Country" inManagedObjectContext:context];
    
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pid = %d", categoryId];
    //    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"country" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}


+(NSArray*) getMakeBySearchingName:(NSString*)make {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Make" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"make_name CONTAINS[cd] %@", make];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"make_name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

+(NSArray*) getDataByCriteria:(NSString*)criteria toSearch:(NSString*)search forEntity:(NSString*)entityStr {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityStr inManagedObjectContext:context];
    
    if ([search length] > 0) {
        NSString* clause = [NSString stringWithFormat:@"%@ CONTAINS[cd] ", criteria];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[clause stringByAppendingString:@"%@"], search];
        [fetchRequest setPredicate:predicate];
    }
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

+(NSUInteger) getDataCountByCriteria:(NSString*)criteria toSearch:(NSString*)search forEntity:(NSString*)entityStr {
    
    NSArray* array = [self getDataByCriteria:criteria toSearch:search forEntity:entityStr];
    
    if(array == nil)
        return 0;
    
    return [array count];
    
}


+(Agent*) getAgentByAgentId:(int)agentId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Agent" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"agent_id = %d", agentId];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    Agent* obj = fetchedObjects.count == 0 ? nil : [fetchedObjects objectAtIndex:0];
    
    return obj;
}

+(RealEstate*) getRealEstateByAgentId:(int)agentId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RealEstate" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"agent_id = %d", agentId];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    RealEstate* obj = fetchedObjects.count == 0 ? nil : [fetchedObjects objectAtIndex:0];
    
    return obj;
}


+(RealEstate*) getRealEstateByRealEstateId:(int)realEstateId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RealEstate" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"realestate_id = %d", realEstateId];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    RealEstate* obj = fetchedObjects.count == 0 ? nil : [fetchedObjects objectAtIndex:0];
    
    return obj;
}

+(NSArray*) getAgents {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Agent" inManagedObjectContext:context];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}


+(NSArray*) getRealEstatesByAgentId:(int)agentId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RealEstate" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"agent_id = %d", agentId];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"realestate_id" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    
    return fetchedObjects;
}

+(NSArray*) getRealEstates {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RealEstate" inManagedObjectContext:context];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"realestate_id" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    
    return fetchedObjects;
}

+(NSArray*) getRealEstatesForSaleOrRent:(NSString*)criteria {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RealEstate" inManagedObjectContext:context];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status CONTAINS[cd] %@", criteria];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"realestate_id" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    
    return fetchedObjects;
}


+(NSArray*) getFeaturedRealEstates {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RealEstate" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"featured = %d", 1];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"realestate_id" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    
    return fetchedObjects;
}


+(NSArray*) getPhotosByRealEstateId:(int)realEstateId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"realestate_id = %d", realEstateId];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    
    return fetchedObjects;
}


+(NSArray*) getFavoriteRealEstate {
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:context];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"realestate_id" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}


+(NSArray*) getPropertyTypes {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PropertyType" inManagedObjectContext:context];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"property_type" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

+(Favorite*) getFavoriteByRealEstateId:(int)realEstateId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"realestate_id = %d", realEstateId];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count > 0 ? [fetchedObjects objectAtIndex:0] : nil;
}


+(Photo*) getPhotoByRealEstateId:(int)realEstateId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"realestate_id = %d", realEstateId];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count > 0 ? [fetchedObjects objectAtIndex:0] : nil;
}


+(Photo*) getPhotoByPhotoId:(int)photoId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"photo_id = %d", photoId];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count > 0 ? [fetchedObjects objectAtIndex:0] : nil;
}


+(void)insertAgentFromDictionary:(NSDictionary*)dic {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSString* className = NSStringFromClass([Agent class]);
    NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
    Agent* obj = (Agent*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    
    obj.address = [dic objectForKey:@"address"];
    obj.agent_id = [NSNumber numberWithInt:[[dic objectForKey:@"agent_id"] intValue]];
    obj.contact_no = [dic objectForKey:@"contact_no"];
    obj.country = [dic objectForKey:@"country"];
    obj.created_at = [dic objectForKey:@"created_at"];
    obj.email = [dic objectForKey:@"email"];
    obj.name = [dic objectForKey:@"name"];
    obj.sms = [dic objectForKey:@"sms"];
    obj.updated_at = [dic objectForKey:@"updated_at"];
    obj.zipcode = [dic objectForKey:@"zipcode"];
    obj.fb = [dic objectForKey:@"fb"];
    obj.twitter = [dic objectForKey:@"twitter"];
    obj.linkedin = [dic objectForKey:@"linkedin"];
    obj.company = [dic objectForKey:@"company"];
    
    NSError* error;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

+(void)insertCountryFromDictionary:(NSDictionary*)dic {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSString* className = NSStringFromClass([Country class]);
    NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
    Country* obj = (Country*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    
    obj.country = [dic objectForKey:@"country"];
    obj.country_id = [NSNumber numberWithInt:[[dic objectForKey:@"country_id"] intValue]];
    obj.created_at = [dic objectForKey:@"created_at"];
    obj.updated_at = [dic objectForKey:@"updated_at"];
    
    NSError* error;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

+(void)insertPriceHistoryFromDictionary:(NSDictionary*)dic {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSString* className = NSStringFromClass([PriceHistory class]);
    NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
    PriceHistory* obj = (PriceHistory*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    
    obj.change = [dic objectForKey:@"change"];
    obj.created_at = [dic objectForKey:@"created_at"];
    obj.price = [dic objectForKey:@"price"];
    obj.pricehistory_id = [NSNumber numberWithInt:[[dic objectForKey:@"pricehistory_id"] intValue]];
    obj.realestate_id = [NSNumber numberWithInt:[[dic objectForKey:@"realestate_id"] intValue]];
    obj.updated_at = [dic objectForKey:@"updated_at"];
    
    NSError* error;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

+(void)insertRealEstateFromDictionary:(NSDictionary*)dic {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSString* className = NSStringFromClass([RealEstate class]);
    NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
    
    RealEstate* obj = (RealEstate*)[[NSManagedObject alloc] initWithEntity:entity
                                            insertIntoManagedObjectContext:context];
    obj.address = [dic objectForKey:@"address"];
    obj.agent_id = [NSNumber numberWithInt:[[dic objectForKey:@"agent_id"] intValue]];
    obj.baths = [dic objectForKey:@"baths"];
    obj.beds = [dic objectForKey:@"beds"];
    obj.built_in = [dic objectForKey:@"built_in"];
    obj.country = [dic objectForKey:@"country"];
    obj.created_at = [dic objectForKey:@"created_at"];
    obj.desc = [dic objectForKey:@"desc1"];
    obj.featured = [NSNumber numberWithInt:[[dic objectForKey:@"featured"] intValue]];
    obj.lat = [dic objectForKey:@"lat"];
    obj.lon = [dic objectForKey:@"lon"];
    obj.lot_size = [dic objectForKey:@"lot_size"];
    obj.price = [dic objectForKey:@"price"];
    obj.price_per_sqft = [dic objectForKey:@"price_per_sqft"];
    obj.property_type = [dic objectForKey:@"property_type"];
    obj.realestate_id = [NSNumber numberWithInt:[[dic objectForKey:@"realestate_id"] intValue]];
    obj.rooms = [dic objectForKey:@"rooms"];
    obj.sqft = [dic objectForKey:@"sqft"];
    obj.status = [dic objectForKey:@"status"];
    obj.updated_at = [dic objectForKey:@"updated_at"];
    obj.zipcode = [dic objectForKey:@"zipcode"];
    
    NSError* error;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

+(void)insertPhotoFromDictionary:(NSDictionary*)dic {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSString* className = NSStringFromClass([Photo class]);
    NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
    Photo* obj = (Photo*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    
    obj.photo_id = [NSNumber numberWithInt:[[dic objectForKey:@"photo_id"] intValue]];
    obj.realestate_id = [NSNumber numberWithInt:[[dic objectForKey:@"realestate_id"] intValue]];
    obj.photo_url = [dic objectForKey:@"photo_url"];
    obj.thumb_url = [dic objectForKey:@"thumb_url"];
    obj.created_at = [dic objectForKey:@"created_at"];
    obj.updated_at = [dic objectForKey:@"updated_at"];
    
    NSError* error;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


+(void)insertFavorite:(int)realEstateId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSString* className = NSStringFromClass([Favorite class]);
    NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
    Favorite* obj = (Favorite*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    
    obj.realestate_id = [NSNumber numberWithInt:realEstateId];
    
    NSError* error;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


+(void)updatePhotoAgentFromDictionary:(NSDictionary*)dic {
    
    Agent* agent = [CoreDataController getAgentByAgentId:[[dic objectForKey:@"agent_id"] intValue]];
    agent.photo_url = [dic objectForKey:@"photo_url"];
    agent.thumb_url = [dic objectForKey:@"thumb_url"];
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError* error;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

+(Photo*) getDummyPhoto {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSString* className = NSStringFromClass([Photo class]);
    NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
    Photo* photo = (Photo*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    
    photo.agent_id = [NSNumber numberWithInt:-1];
    photo.photo_id = [NSNumber numberWithInt:-1];
    photo.thumb_url = @"";
    photo.photo_url = @"";
    
    return photo;
}

+(SearchParams*) getSearchParamsBySearchId:(int)searchId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SearchParams" inManagedObjectContext:context];
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"search_id = %d", searchId];
//    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    SearchParams* obj = fetchedObjects.count == 0 ? nil : [fetchedObjects objectAtIndex:0];
    
    return obj;
}

+(void)insertSearchParams:(SearchParams*)params {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    SearchParams* paramsStored = [CoreDataController getSearchParamsBySearchId:1];
    
    if(paramsStored == nil) {
        NSString* className = NSStringFromClass([SearchParams class]);
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:className
                                                  inManagedObjectContext:context];
        
        paramsStored = (SearchParams*)[[NSManagedObject alloc] initWithEntity:entity
                                               insertIntoManagedObjectContext:context];
        
        paramsStored.search_id = [NSNumber numberWithInt:1];
    }
    
    paramsStored.status_index = params.status_index;
    paramsStored.price_range_min = params.price_range_min;
    paramsStored.price_range_max = params.price_range_max;
    paramsStored.property_type = params.property_type;
    paramsStored.beds_index = params.beds_index;
    paramsStored.baths_index = params.baths_index;
    paramsStored.sqft_min = params.sqft_min;
    paramsStored.sqft_max = params.sqft_max;
    paramsStored.years_built_min = params.years_built_min;
    paramsStored.years_built_max = params.years_built_max;
    paramsStored.lot_size_min = params.lot_size_min;
    paramsStored.lot_size_max = params.lot_size_max;
    

    
    NSError* error;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}



@end
