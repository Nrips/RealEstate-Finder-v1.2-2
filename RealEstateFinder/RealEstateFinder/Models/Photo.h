//
//  Photo.h
//  RealEstateFinder
//
//
//  Copyright (c) 2014 MangasaurGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSNumber * photo_id;
@property (nonatomic, retain) NSNumber * realestate_id;
@property (nonatomic, retain) NSString * photo_url;
@property (nonatomic, retain) NSString * thumb_url;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * updated_at;
@property (nonatomic, assign) BOOL isImagePicked;

@property (nonatomic, retain) NSNumber * agent_id;

@end
