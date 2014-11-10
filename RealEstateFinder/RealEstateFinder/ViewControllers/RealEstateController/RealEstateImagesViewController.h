

#import <UIKit/UIKit.h>
#import "RealEstateUrlViewController.h"
#import "RealEstateImageViewController.h"

@protocol RealEstatePhotosDelegate <NSObject>

-(void) returnPhotoArrays:(NSMutableArray*)photos;
-(void) returnPhotoArrayFromFile:(NSMutableArray*)photos;

@end

@interface RealEstateImagesViewController : UIViewController <MGGalleryViewDelegate, RealEstateAddUrlDelegate, RealEstateAddPickerDelegate> {

    int _index;
    id <RealEstatePhotosDelegate> _realEstatePhotosDelegate;
    NSMutableArray* _arrayPhotosFromFile;
}

@property (nonatomic, retain) NSMutableArray* arrayPhotos;
@property (nonatomic, retain) RealEstate* realEstate;

@property (nonatomic, retain) id <RealEstatePhotosDelegate> realEstatePhotosDelegate;

@property (nonatomic, retain) MGGalleryView* galleryView;
@property (nonatomic, retain) IBOutlet UIView* parentView;

@property (nonatomic, retain) IBOutlet UIButton* buttonAddURL;
@property (nonatomic, retain) IBOutlet UIButton* buttonAddImage;
@property (nonatomic, retain) IBOutlet UIButton* buttonDone;

-(IBAction)didClickAddURLButton:(id)sender;
-(IBAction)didClickSelectImageButton:(id)sender;
-(IBAction)didClickDoneButton:(id)sender;

@end
