

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate> {
    
    MGRawView* _loginView;
}

@property (nonatomic, retain) IBOutlet MGRawScrollView* scrollViewLogin;


@end
