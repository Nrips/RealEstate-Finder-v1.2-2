

#import <UIKit/UIKit.h>
#import "RealEstateImagesViewController.h"
#import "PTypeViewController.h"

@interface RealEstateEditViewController : UIViewController <RealEstatePhotosDelegate, UITextFieldDelegate, UITextViewDelegate, MGMapViewDelegate, CLLocationManagerDelegate, PropertyTypeDelegate> {
    
    CLLocationManager* _myLocationManager;
    CLLocation* _myLocation;
    MGRawView* _realEstateView;
    int _index;
    NSString* _deleted;
    NSMutableArray* _storedPhotos;
    NSString* _realestate_id;
    CLLocationCoordinate2D _dropAtCoords;
    MGMapAnnotation* _annotation;
}

@property (nonatomic, retain) IBOutlet MGRawScrollView* scrollViewMain;
@property (nonatomic, retain) NSMutableArray* arrayPhotos;
@property (nonatomic, retain) RealEstate* realEstate;

@end
