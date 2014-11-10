

#import <UIKit/UIKit.h>

@protocol RealEstateAddPickerDelegate <NSObject>

-(void) returnPickerPhoto:(Photo*)photo;

@end

@interface RealEstateImageViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    BOOL _isThumbSelected;
    id <RealEstateAddPickerDelegate> _pickerDelegate;
    UIImage* _imgThumb;
    UIImage* _imgPhoto;
    MGRawView* _photoUploadView;
}

@property (nonatomic, retain) IBOutlet MGRawScrollView* scrollViewMain;
@property (nonatomic, retain) id <RealEstateAddPickerDelegate> pickerDelegate;
@property (nonatomic, retain) RealEstate* realEstate;

-(IBAction)didClickDoneButton:(id)sender;


@end
