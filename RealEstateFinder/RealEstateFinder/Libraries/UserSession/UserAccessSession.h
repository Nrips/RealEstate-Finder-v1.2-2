

#import <Foundation/Foundation.h>
#import "UserSession.h"

@interface UserAccessSession : NSObject

+(void)storeUserSession:(UserSession*)session;
+(UserSession*)getUserSession;

+(AgentSession*)getAgentSession;
+(void)storeAgentSession:(AgentSession*)session;

+(void) clearAllSession;
+(BOOL)isLoggedIn;

@end
