


#import "UserAccessSession.h"

#define FACEBOOK_ID     @"sekln0LDNKANWdskf"
#define TWITTER_ID      @"OIanlknfalk3lnk2a"
#define USER_ID         @"23vponrnkl32brlkn"
#define LOGIN_HASH      @"340bji4riwbnlrvas"
#define FULL_NAME       @"5b03i3ipbp3454LLK"
#define USER_NAME       @"65po7jboyioen2Kid"
#define EMAIL           @"54690j945safnKNKI"

#define IS_LOGIN        @"3b90jKADN3902q3v2"


@implementation UserAccessSession

+(BOOL)isLoggedIn {
    
    BOOL isLoggedIn = [[[NSUserDefaults standardUserDefaults]objectForKey:IS_LOGIN] isEqual: @"1"] ? YES : NO;
    
    return isLoggedIn;
}

+(void)storeUserSession:(UserSession*)session {
    
    [[NSUserDefaults standardUserDefaults]setObject:session.facebookId forKey:FACEBOOK_ID];
    [[NSUserDefaults standardUserDefaults]setObject:session.twitterId forKey:TWITTER_ID];
    [[NSUserDefaults standardUserDefaults]setObject:session.userId forKey:USER_ID];
    [[NSUserDefaults standardUserDefaults]setObject:session.loginHash forKey:LOGIN_HASH];
    [[NSUserDefaults standardUserDefaults]setObject:session.fullName forKey:FULL_NAME];
    [[NSUserDefaults standardUserDefaults]setObject:session.userName forKey:USER_NAME];
    [[NSUserDefaults standardUserDefaults]setObject:session.email forKey:EMAIL];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:IS_LOGIN];
}

+(UserSession*)getUserSession {
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:USER_ID] == nil)
        return nil;
    
    UserSession* userSession = [UserSession new];
    userSession.facebookId = [[NSUserDefaults standardUserDefaults]objectForKey:FACEBOOK_ID];
    userSession.twitterId = [[NSUserDefaults standardUserDefaults]objectForKey:TWITTER_ID];
    userSession.userId = [[NSUserDefaults standardUserDefaults]objectForKey:USER_ID];
    userSession.loginHash = [[NSUserDefaults standardUserDefaults]objectForKey:LOGIN_HASH];
    userSession.fullName = [[NSUserDefaults standardUserDefaults]objectForKey:FULL_NAME];
    userSession.userName = [[NSUserDefaults standardUserDefaults]objectForKey:USER_NAME];
    userSession.email = [[NSUserDefaults standardUserDefaults]objectForKey:EMAIL];
    
    return userSession;
}

+(void)storeAgentSession:(AgentSession*)session {
    
    [[NSUserDefaults standardUserDefaults]setObject:session.address forKey:@"address"];
    [[NSUserDefaults standardUserDefaults]setObject:session.agent_id forKey:@"agent_id"];
    [[NSUserDefaults standardUserDefaults]setObject:session.contact_no forKey:@"contact_no"];
    [[NSUserDefaults standardUserDefaults]setObject:session.country forKey:@"country"];
    [[NSUserDefaults standardUserDefaults]setObject:session.created_at forKey:@"created_at"];
    [[NSUserDefaults standardUserDefaults]setObject:session.email forKey:@"email"];
    [[NSUserDefaults standardUserDefaults]setObject:session.name forKey:@"name"];
    [[NSUserDefaults standardUserDefaults]setObject:session.sms forKey:@"sms"];
    [[NSUserDefaults standardUserDefaults]setObject:session.updated_at forKey:@"updated_at"];
    [[NSUserDefaults standardUserDefaults]setObject:session.zipcode forKey:@"zipcode"];
    [[NSUserDefaults standardUserDefaults]setObject:session.photo_url forKey:@"photo_url"];
    [[NSUserDefaults standardUserDefaults]setObject:session.thumb_url forKey:@"thumb_url"];
    [[NSUserDefaults standardUserDefaults]setObject:session.twitter forKey:@"twitter"];
    [[NSUserDefaults standardUserDefaults]setObject:session.fb forKey:@"fb"];
    [[NSUserDefaults standardUserDefaults]setObject:session.linkedin forKey:@"linkedin"];
    [[NSUserDefaults standardUserDefaults]setObject:session.company forKey:@"company"];
    [[NSUserDefaults standardUserDefaults]setObject:session.user_id forKey:@"user_id"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(AgentSession*)getAgentSession {
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] == nil)
        return nil;
    
    AgentSession* session = [AgentSession new];
    session.address = [[NSUserDefaults standardUserDefaults]objectForKey:@"address"];
    session.agent_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"agent_id"];
    session.contact_no = [[NSUserDefaults standardUserDefaults]objectForKey:@"contact_no"];
    session.country = [[NSUserDefaults standardUserDefaults]objectForKey:@"country"];
    session.created_at = [[NSUserDefaults standardUserDefaults]objectForKey:@"created_at"];
    session.email = [[NSUserDefaults standardUserDefaults]objectForKey:@"email"];
    session.name = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    session.sms = [[NSUserDefaults standardUserDefaults]objectForKey:@"sms"];
    session.updated_at = [[NSUserDefaults standardUserDefaults]objectForKey:@"updated_at"];
    session.zipcode = [[NSUserDefaults standardUserDefaults]objectForKey:@"zipcode"];
    session.photo_url = [[NSUserDefaults standardUserDefaults]objectForKey:@"photo_url"];
    session.thumb_url = [[NSUserDefaults standardUserDefaults]objectForKey:@"thumb_url"];
    session.twitter = [[NSUserDefaults standardUserDefaults]objectForKey:@"twitter"];
    session.fb = [[NSUserDefaults standardUserDefaults]objectForKey:@"fb"];
    session.linkedin = [[NSUserDefaults standardUserDefaults]objectForKey:@"linkedin"];
    session.company = [[NSUserDefaults standardUserDefaults]objectForKey:@"company"];
    session.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    
    return session;
}


+(void) clearAllSession {
    
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:FACEBOOK_ID];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:TWITTER_ID];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:USER_ID];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:LOGIN_HASH];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:FULL_NAME];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:USER_NAME];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:EMAIL];
    
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"address"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"agent_id"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"contact_no"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"country"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"created_at"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"email"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"name"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"sms"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"updated_at"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"zipcode"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"photo_url"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"thumb_url"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"twitter"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"fb"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"linkedin"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"company"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"user_id"];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:IS_LOGIN];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
