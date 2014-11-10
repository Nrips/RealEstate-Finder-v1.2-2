

#import <UIKit/UIKit.h>

@protocol AddPickerDelegate <NSObject>

-(void) returnPickerPhoto:(Photo*)photo;

@end

@interface AgentImageViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    BOOL _isThumbSelected;
    id <AddPickerDelegate> _pickerDelegate;
    UIImage* _imgThumb;
    UIImage* _imgPhoto;
    MGRawView* _photoUploadView;
}

@property (nonatomic, retain) IBOutlet MGRawScrollView* scrollViewMain;
@property (nonatomic, retain) id <AddPickerDelegate> pickerDelegate;
@property (nonatomic, retain) Agent* agent;

-(IBAction)didClickDoneButton:(id)sender;


@end
