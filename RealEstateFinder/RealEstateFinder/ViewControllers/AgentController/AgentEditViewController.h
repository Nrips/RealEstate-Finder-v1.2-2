

#import <UIKit/UIKit.h>
#import "AgentImagesViewController.h"

@interface AgentEditViewController : UIViewController <AgentPhotosDelegate, UITextFieldDelegate, UITextViewDelegate> {
    
    
    MGRawView* _agentView;
    int _index;
    
    NSMutableArray* _storedPhotos;
}

@property (nonatomic, retain) IBOutlet MGRawScrollView* scrollViewMain;
@property (nonatomic, retain) NSMutableArray* arrayPhotos;

@end
