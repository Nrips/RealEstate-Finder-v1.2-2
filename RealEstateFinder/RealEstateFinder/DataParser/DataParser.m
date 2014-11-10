//
//  DataParser.m
//  RealEstateFinder
//
//
//  Copyright (c) 2014 MangasaurGames. All rights reserved.
//

#import "DataParser.h"

@implementation DataParser

+(NSMutableArray*)parseDataFromURLFormatJSON:(NSString*)urlStr {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSDictionary* dict = [self getJSONAtURL:urlStr];
    
    if(dict == nil)
        return nil;
    
    if([dict isKindOfClass:[NSNull class]])
        return nil;
    
    NSMutableArray* array = [NSMutableArray new];
    
    
    NSDictionary* dataDict = [dict valueForKey:@"agents"];
    if(dataDict != nil) {
        for (NSDictionary* agentDict in dataDict) {
            
            NSString* className = NSStringFromClass([Agent class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            Agent* obj = (Agent*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            obj.address = [agentDict objectForKey:@"address"];
            obj.agent_id = [NSNumber numberWithInt:[[agentDict objectForKey:@"agent_id"] intValue]];
            obj.contact_no = [agentDict objectForKey:@"contact_no"];
            obj.country = [agentDict objectForKey:@"country"];
            obj.created_at = [agentDict objectForKey:@"created_at"];
            obj.email = [agentDict objectForKey:@"email"];
            obj.name = [agentDict objectForKey:@"name"];
            obj.sms = [agentDict objectForKey:@"sms"];
            obj.updated_at = [agentDict objectForKey:@"updated_at"];
            obj.zipcode = [agentDict objectForKey:@"zipcode"];
            obj.fb = [agentDict objectForKey:@"fb"];
            obj.twitter = [agentDict objectForKey:@"twitter"];
            obj.linkedin = [agentDict objectForKey:@"linkedin"];
            obj.company = [agentDict objectForKey:@"company"];
            obj.photo_url = [agentDict objectForKey:@"photo_url"];
            obj.thumb_url = [agentDict objectForKey:@"thumb_url"];
            
            [array addObject:obj];
        }
    }
    
    dataDict = [dict valueForKey:@"countries"];
    if(dataDict != nil) {
        for (NSDictionary* dic in dataDict) {
            
            NSString* className = NSStringFromClass([Country class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            Country* obj = (Country*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            obj.country = [dic objectForKey:@"country"];
            obj.country_id = [NSNumber numberWithInt:[[dic objectForKey:@"country_id"] intValue]];
            obj.created_at = [dic objectForKey:@"created_at"];
            obj.updated_at = [dic objectForKey:@"updated_at"];
            
            [array addObject:obj];
        }
        
    }
    
    dataDict = [dict valueForKey:@"property_types"];
    if(dataDict != nil) {
        for (NSDictionary* dic in dataDict) {
            
            NSString* className = NSStringFromClass([PropertyType class]);
            
            NSEntityDescription *entity = [NSEntityDescription entityForName:className
                                                      inManagedObjectContext:context];
            
            PropertyType* obj = (PropertyType*)[[NSManagedObject alloc] initWithEntity:entity
                                                        insertIntoManagedObjectContext:context];
            
            obj.property_type = [dic objectForKey:@"property_type"];
            obj.created_at = [dic objectForKey:@"created_at"];
            obj.propertytype_id = [NSNumber numberWithInt:[[dic objectForKey:@"propertytype_id"] intValue]];
            obj.updated_at = [dic objectForKey:@"updated_at"];
            
            [array addObject:obj];
        }
        
    }
    
    dataDict = [dict valueForKey:@"price_history"];
    if(dataDict != nil) {
        for (NSDictionary* dic in dataDict) {
            
            NSString* className = NSStringFromClass([PriceHistory class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            PriceHistory* obj = (PriceHistory*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            obj.change = [dic objectForKey:@"change"];
            obj.created_at = [dic objectForKey:@"created_at"];
            obj.price = [dic objectForKey:@"price"];
            obj.pricehistory_id = [NSNumber numberWithInt:[[dic objectForKey:@"pricehistory_id"] intValue]];
            obj.realestate_id = [NSNumber numberWithInt:[[dic objectForKey:@"realestate_id"] intValue]];
            obj.updated_at = [dic objectForKey:@"updated_at"];
            
            [array addObject:obj];
        }
        
    }
    
    dataDict = [dict valueForKey:@"real_estates"];
    if(dataDict != nil) {
        for (NSDictionary* dic in dataDict) {
            
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
            obj.desc = [dic objectForKey:@"desc"];
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
            
            [array addObject:obj];
            
        }
        
    }
    
    dataDict = [dict valueForKey:@"photos"];
    if(dataDict != nil) {
        for (NSDictionary* dic in dataDict) {
            
            NSString* className = NSStringFromClass([Photo class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            Photo* obj = (Photo*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            obj.photo_id = [NSNumber numberWithInt:[[dic objectForKey:@"photo_id"] intValue]];
            obj.realestate_id = [NSNumber numberWithInt:[[dic objectForKey:@"realestate_id"] intValue]];
            obj.photo_url = [dic objectForKey:@"photo_url"];
            obj.thumb_url = [dic objectForKey:@"thumb_url"];
            obj.created_at = [dic objectForKey:@"created_at"];
            obj.updated_at = [dic objectForKey:@"updated_at"];
            
            [array addObject:obj];
        }
        
    }
    
    return array;
}


+(NSMutableArray*)parseCarDataXMLFromURL:(NSString*)urlStr {
    TBXMLEx* xml = nil;
    xml = [TBXMLEx parserWithURL:urlStr];
    
    if(xml == nil)
        return nil;
    
    if([xml isKindOfClass:[NSNull class]])
        return nil;
    
    return [self parseCarXML:xml];
}

+(NSMutableArray*)parseCarXML:(TBXMLEx*) xml {
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    if (xml.rootElement) {
        
        // agents node
        TBXMLElementEx* node = [xml.rootElement child:@"agents"];
        TBXMLElementEx* subNode = [node child:@"item"];
        while ([subNode next]) {
            
            NSString* className = NSStringFromClass([Agent class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            Agent* obj = (Agent*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            obj.address = [[subNode child:@"address"] value];
            obj.agent_id = [NSNumber numberWithInt:[[subNode child:@"agent_id"] intValue]];
            obj.contact_no = [[subNode child:@"contact_no"] value];
            obj.country = [[subNode child:@"country"] value];
            obj.created_at = [[subNode child:@"created_at"] value];
            obj.email = [[subNode child:@"email"] value];
            obj.name = [[subNode child:@"name"] value];
            obj.sms = [[subNode child:@"sms"] value];
            obj.updated_at = [[subNode child:@"updated_at"] value];
            obj.zipcode = [[subNode child:@"zipcode"] value];
            obj.fb = [[subNode child:@"fb"] value];
            obj.twitter = [[subNode child:@"twitter"] value];
            obj.linkedin = [[subNode child:@"linkedin"] value];
            obj.company = [[subNode child:@"company"] value];
            obj.photo_url = [[subNode child:@"photo_url"] value];
            obj.thumb_url = [[subNode child:@"thumb_url"] value];
            
            [array addObject:obj];
        }
        
        // countries node
        node = [xml.rootElement child:@"countries"];
        subNode = [node child:@"item"];
        
        while ([subNode next]) {
            
            NSString* className = NSStringFromClass([Country class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            Country* obj = (Country*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            obj.country = [[subNode child:@"country"] value];
            obj.country_id = [NSNumber numberWithInt:[[subNode child:@"country_id"] intValue]];
            obj.created_at = [[subNode child:@"created_at"] value];
            obj.updated_at = [[subNode child:@"updated_at"] value];
            
            [array addObject:obj];
        }
        
        // property_types node
        node = [xml.rootElement child:@"property_types"];
        subNode = [node child:@"item"];
        
        while ([subNode next]) {
            
            NSString* className = NSStringFromClass([PropertyType class]);
            
            NSEntityDescription *entity = [NSEntityDescription entityForName:className
                                                      inManagedObjectContext:context];
            
            PropertyType* obj = (PropertyType*)[[NSManagedObject alloc] initWithEntity:entity
                                                        insertIntoManagedObjectContext:context];

            obj.property_type = [[subNode child:@"property_type"] value];
            obj.created_at = [[subNode child:@"created_at"] value];
            obj.propertytype_id = [NSNumber numberWithInt:[[subNode child:@"propertytype_id"] intValue]];
            obj.updated_at = [[subNode child:@"updated_at"] value];
            
            [array addObject:obj];
        }
        
        // price_history node
        node = [xml.rootElement child:@"price_history"];
        subNode = [node child:@"item"];
        
        while ([subNode next]) {
            
            NSString* className = NSStringFromClass([PriceHistory class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            PriceHistory* obj = (PriceHistory*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            obj.change = [[subNode child:@"change"] value];
            obj.created_at = [[subNode child:@"created_at"] value];
            obj.price = [[subNode child:@"price"] value];
            obj.pricehistory_id = [NSNumber numberWithInt:[[subNode child:@"pricehistory_id"] intValue]];
            obj.realestate_id = [NSNumber numberWithInt:[[subNode child:@"realestate_id"] intValue]];
            obj.updated_at = [[subNode child:@"updated_at"] value];
            
            [array addObject:obj];
        }
        
        
        // real_estates node
        node = [xml.rootElement child:@"real_estates"];
        subNode = [node child:@"item"];
        
        while ([subNode next]) {
            
            NSString* className = NSStringFromClass([RealEstate class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            
            RealEstate* obj = (RealEstate*)[[NSManagedObject alloc] initWithEntity:entity
                                                    insertIntoManagedObjectContext:context];
            obj.address = [[subNode child:@"address"] value];
            obj.agent_id = [NSNumber numberWithInt:[[subNode child:@"agent_id"] intValue]];
            obj.baths = [[subNode child:@"baths"] value];
            obj.beds = [[subNode child:@"beds"] value];
            obj.built_in = [[subNode child:@"built_in"] value];
            obj.country = [[subNode child:@"country"] value];
            obj.created_at = [[subNode child:@"created_at"] value];
            obj.desc = [[subNode child:@"desc1"] value];
            obj.featured = [NSNumber numberWithInt:[[subNode child:@"featured"] intValue]];
            obj.lat = [[subNode child:@"lat"] value];
            obj.lon = [[subNode child:@"lon"] value];
            obj.lot_size = [[subNode child:@"lot_size"] value];
            obj.price = [[subNode child:@"price"] value];
            obj.price_per_sqft = [[subNode child:@"price_per_sqft"] value];
            obj.property_type = [[subNode child:@"property_type"] value];
            obj.realestate_id = [NSNumber numberWithInt:[[subNode child:@"realestate_id"] intValue]];
            obj.rooms = [[subNode child:@"rooms"] value];
            obj.sqft = [[subNode child:@"sqft"] value];
            obj.status = [[subNode child:@"status"] value];
            obj.updated_at = [[subNode child:@"updated_at"] value];
            obj.zipcode = [[subNode child:@"zipcode"] value];
            
            [array addObject:obj];
        }
        
        // photos node
        node = [xml.rootElement child:@"photos"];
        subNode = [node child:@"item"];
        
        while ([subNode next]) {
            
            NSString* className = NSStringFromClass([Photo class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            Photo* obj = (Photo*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            obj.photo_id = [NSNumber numberWithInt:[[subNode child:@"photo_id"] intValue]];
            obj.realestate_id = [NSNumber numberWithInt:[[subNode child:@"realestate_id"] intValue]];
            obj.photo_url = [[subNode child:@"photo_url"] value];
            obj.thumb_url = [[subNode child:@"thumb_url"] value];
            obj.created_at = [[subNode child:@"created_at"] value];
            obj.updated_at = [[subNode child:@"updated_at"] value];
            
            [array addObject:obj];
        }
        
    }
    
    return array;
}


+(void)fetchServerData {
    
    if(WILL_DOWNLOAD_DATA && [MGUtilities hasInternetConnection]) {
        
        AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSManagedObjectContext* context = delegate.managedObjectContext;
        
        [CoreDataController deleteAllObjects:@"Agent"];
        [CoreDataController deleteAllObjects:@"Country"];
        [CoreDataController deleteAllObjects:@"PriceHistory"];
        [CoreDataController deleteAllObjects:@"RealEstate"];
        [CoreDataController deleteAllObjects:@"Photo"];
        [CoreDataController deleteAllObjects:@"PropertyType"];
        
        @try {
            
            NSMutableArray* arrayData;
            if(WILL_USE_JSON_FORMAT) {
                arrayData = [DataParser parseDataFromURLFormatJSON:DATA_JSON_URL];
            }
            else {
                arrayData = [DataParser parseCarDataXMLFromURL:DATA_XML_URL];
            }
            
            if(arrayData != nil && arrayData.count > 0) {
                NSError *error;
                if ([context hasChanges] && ![context save:&error]) {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"exception = %@", exception.debugDescription);
        }
        
    }
}

@end
