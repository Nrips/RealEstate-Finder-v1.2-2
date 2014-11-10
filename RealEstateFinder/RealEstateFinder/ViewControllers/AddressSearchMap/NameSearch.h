//
//  NameSearch.h
//  Search
//
//  Created by Neuron Mac on 30/07/14.
//  Copyright (c) 2014 Neuron Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NameSearch : NSObject

@property (nonatomic, copy) NSString  *name;
+ (id)nameFinder:(NSString *)name;
@end
