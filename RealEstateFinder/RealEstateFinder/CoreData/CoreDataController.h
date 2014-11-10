//
//  CoreDataController.h
//  RealEstateFinder
//
//  
//  Copyright (c) 2014 MangasaurGames. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataController : NSObject

+(void) deleteAllObjects:(NSString *) entityDescription;

+(NSArray*) getCountries;
+(Agent*) getAgentByAgentId:(int)agentId;
+(RealEstate*) getRealEstateByAgentId:(int)agentId;
+(RealEstate*) getRealEstateByRealEstateId:(int)realEstateId;
+(NSArray*) getRealEstatesByAgentId:(int)agentId;
+(NSArray*) getAgents;
+(NSArray*) getRealEstates;
+(NSArray*) getPhotosByRealEstateId:(int)realEstateId;
+(NSArray*) getFavoriteRealEstate;
+(Favorite*) getFavoriteByRealEstateId:(int)realEstateId;
+(Photo*) getPhotoByRealEstateId:(int)realEstateId;
+(Photo*) getPhotoByPhotoId:(int)photoId;
+(void)insertAgentFromDictionary:(NSDictionary*)dic;
+(void)insertCountryFromDictionary:(NSDictionary*)dic;
+(void)insertPriceHistoryFromDictionary:(NSDictionary*)dic;
+(void)insertRealEstateFromDictionary:(NSDictionary*)dic;
+(void)insertPhotoFromDictionary:(NSDictionary*)dic;

+(NSArray*) getRealEstatesForSaleOrRent:(NSString*)criteria;
+(void)insertFavorite:(int)favoriteId;
+(NSArray*) getFeaturedRealEstates;
+(void)updatePhotoAgentFromDictionary:(NSDictionary*)dic;

+(NSArray*) getPropertyTypes;
+(Photo*) getDummyPhoto;
+(SearchParams*) getSearchParamsBySearchId:(int)searchId;
+(void)insertSearchParams:(SearchParams*)params;

@end
