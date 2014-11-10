

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate> {
    
    MGRawView* _registerView;
}

@property (nonatomic, retain) IBOutlet MGRawScrollView* scrollViewRegister;

-(IBAction)didClickCancelLogin:(id)sender;

@end
