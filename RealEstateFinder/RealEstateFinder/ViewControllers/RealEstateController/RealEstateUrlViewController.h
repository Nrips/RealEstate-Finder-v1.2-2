

#import <UIKit/UIKit.h>

@protocol RealEstateAddUrlDelegate <NSObject>

-(void) returnPhoto:(Photo*)photo;

@end

@interface RealEstateUrlViewController : UIViewController <UITextFieldDelegate>{
    id <RealEstateAddUrlDelegate> _photoDelegate;
}

@property (nonatomic, retain) IBOutlet UITextField* textFieldThumbUrl;
@property (nonatomic, retain) IBOutlet UITextField* textFieldPhotoUrl;
@property (nonatomic, retain) id <RealEstateAddUrlDelegate> photoDelegate;
@property (nonatomic, retain) RealEstate* realEstate;

-(IBAction)didClickDoneButton:(id)sender;

@end
