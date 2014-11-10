

#import <UIKit/UIKit.h>

@protocol AddUrlDelegate <NSObject>

-(void) returnPhoto:(Photo*)photo;

@end

@interface AgentUrlViewController : UIViewController <UITextFieldDelegate>{
    id <AddUrlDelegate> _photoDelegate;
}

@property (nonatomic, retain) IBOutlet UITextField* textFieldThumbUrl;
@property (nonatomic, retain) IBOutlet UITextField* textFieldPhotoUrl;
@property (nonatomic, retain) id <AddUrlDelegate> photoDelegate;
@property (nonatomic, retain) Agent* agent;

-(IBAction)didClickDoneButton:(id)sender;

@end
