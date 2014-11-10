//
//  DataSource.m
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource


+(NSMutableArray*) getPriceSearchDataSource {
    
    NSMutableArray* array = [NSMutableArray new];
    
    [array addObject:[DataSource formatNumber:10000]];
    [array addObject:[DataSource formatNumber:20000]];
    [array addObject:[DataSource formatNumber:30000]];
    [array addObject:[DataSource formatNumber:50000]];
    [array addObject:[DataSource formatNumber:100000]];
    [array addObject:[DataSource formatNumber:130000]];
    
    for(int x = 150000; x <= 4000000; x+=50000) {
        
        [array addObject:[DataSource formatNumber:x]];
    }
    
    return array;
}

+(NSString*) formatNumber:(int)val {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *format = [NSString stringWithFormat:@"%@ %@",
                        LOCALIZED_NOT_NULL(@"SEARCH_CURRENCY_SIGN"),
                        [formatter stringFromNumber:[NSNumber numberWithInt:val]]];
    return format;
}


+(NSMutableArray*) getSquareFootageDataSource {
    
    NSMutableArray* array = [NSMutableArray new];
    
    [array addObject:@"0+"];
    
    for(int x = 400; x <= 2000; x+=100)
        [array addObject:[NSString stringWithFormat:@"%d+", x]];
    
    for(int x = 2500; x <= 5000; x+=500)
        [array addObject:[NSString stringWithFormat:@"%d+", x]];
    
    return array;
}

+(NSMutableArray*) getYearBuiltDataSource {
    
    NSMutableArray* array = [NSMutableArray new];
    
    NSDate* date = [NSDate date];
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    NSInteger year = [components year];
    
    for(int x = (int)year; x >= LOWEST_YEAR ; x--) {
        [array addObject:[NSString stringWithFormat:@"%d", x]];
    }
    
    return array;
}

+(NSMutableArray*) getLotSizeDataSource {
    
    NSMutableArray* array = [NSMutableArray new];
    
    [array addObject:@"0+"];
    
    for(int x = 1000; x <= 15000; x+=1000)
        [array addObject:[NSString stringWithFormat:@"%d+ sqft", x]];
    
    return array;
}
@end
