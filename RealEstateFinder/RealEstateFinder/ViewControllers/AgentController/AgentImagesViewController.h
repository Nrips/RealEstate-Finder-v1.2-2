

#import <UIKit/UIKit.h>
#import "AgentUrlViewController.h"
#import "AgentImageViewController.h"

@protocol AgentPhotosDelegate <NSObject>

-(void) returnPhotoArrays:(NSMutableArray*)photos;
-(void) returnPhotoArrayFromFile:(NSMutableArray*)photos;

@end

@interface AgentImagesViewController : UIViewController <MGGalleryViewDelegate, AddUrlDelegate, AddPickerDelegate> {

    int _index;
    id <AgentPhotosDelegate> _agentPhotosDelegate;
    NSMutableArray* _arrayPhotosFromFile;
}

@property (nonatomic, retain) NSMutableArray* arrayPhotos;
@property (nonatomic, retain) Agent* agent;

@property (nonatomic, retain) id <AgentPhotosDelegate> agentPhotosDelegate;

@property (nonatomic, retain) MGGalleryView* galleryView;
@property (nonatomic, retain) IBOutlet UIView* parentView;

-(IBAction)didClickAddURLButton:(id)sender;
-(IBAction)didClickSelectImageButton:(id)sender;
-(IBAction)didClickDoneButton:(id)sender;

@property (nonatomic, retain) IBOutlet UIButton* buttonAddURL;
@property (nonatomic, retain) IBOutlet UIButton* buttonAddImage;
@property (nonatomic, retain) IBOutlet UIButton* buttonDone;

@end
