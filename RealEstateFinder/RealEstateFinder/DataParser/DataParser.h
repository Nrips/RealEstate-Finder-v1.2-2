//
//  DataParser.h
//  RealEstateFinder
//
//
//  Copyright (c) 2014 MangasaurGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXMLEx.h"
#import "AppDelegate.h"

@interface DataParser : MGParser

+(NSMutableArray*)parseDataFromURLFormatJSON:(NSString*)urlStr;

+(NSMutableArray*)parseCarDataXMLFromURL:(NSString*)urlStr;

+(void)fetchServerData;

@end
