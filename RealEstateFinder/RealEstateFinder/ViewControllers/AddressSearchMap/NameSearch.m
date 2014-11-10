//
//  NameSearch.m
//  Search
//
//  Created by Neuron Mac on 30/07/14.
//  Copyright (c) 2014 Neuron Mac. All rights reserved.
//

#import "NameSearch.h"

@implementation NameSearch
@synthesize  name;
+ (id)nameFinder:(NSString *)name {
    NameSearch *nam = [NameSearch new];
	
	nam.name = name;
	return nam;
}

@end
