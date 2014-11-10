//
//  DataSource.h
//  RealEstateFinder
//
//  
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject

+(NSString*) formatNumber:(int)val;
+(NSMutableArray*) getPriceSearchDataSource;

+(NSMutableArray*) getSquareFootageDataSource;

+(NSMutableArray*) getYearBuiltDataSource;

+(NSMutableArray*) getLotSizeDataSource;

@end
