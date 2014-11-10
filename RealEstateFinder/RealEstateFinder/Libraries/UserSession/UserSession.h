

#import <Foundation/Foundation.h>

@interface UserSession : NSObject

@property (nonatomic, retain) NSString* userId;
@property (nonatomic, retain) NSString* loginHash;
@property (nonatomic, retain) NSString* facebookId;
@property (nonatomic, retain) NSString* twitterId;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* fullName;
@property (nonatomic, retain) NSString* email;

@end


@interface AgentSession : NSObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * agent_id;
@property (nonatomic, retain) NSString * contact_no;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sms;
@property (nonatomic, retain) NSString * updated_at;
@property (nonatomic, retain) NSString * zipcode;
@property (nonatomic, retain) NSString * photo_url;
@property (nonatomic, retain) NSString * thumb_url;
@property (nonatomic, retain) NSString * twitter;
@property (nonatomic, retain) NSString * fb;
@property (nonatomic, retain) NSString * linkedin;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * user_id;

@end
