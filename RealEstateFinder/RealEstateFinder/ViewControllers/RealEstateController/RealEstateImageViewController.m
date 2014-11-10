

#import "RealEstateImageViewController.h"
#import "AppDelegate.h"

@interface RealEstateImageViewController ()

@end

@implementation RealEstateImageViewController

@synthesize pickerDelegate = _pickerDelegate;
@synthesize realEstate;
@synthesize scrollViewMain;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [MGUIAppearance createLogo:HEADER_LOGO];
    self.view.backgroundColor = BG_VIEW_COLOR;
    
    [MGUIAppearance enhanceNavBarController:self.navigationController
                               barTintColor:WHITE_TEXT_COLOR
                                  tintColor:WHITE_TEXT_COLOR
                             titleTextColor:WHITE_TEXT_COLOR];
    
    _photoUploadView = [[MGRawView alloc] initWithNibName:@"PhotoUploadView"];
    scrollViewMain.contentSize = _photoUploadView.frame.size;
    [scrollViewMain addSubview:_photoUploadView];
    
    [_photoUploadView.buttonThumb addTarget:self
                                     action:@selector(didClickThumbButton:)
                           forControlEvents:UIControlEventTouchUpInside];
    
    [_photoUploadView.buttonLargePhoto addTarget:self
                                     action:@selector(didClickPhotoButton:)
                           forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    _photoUploadView.buttonLargePhoto.hidden = YES;
    _photoUploadView.imgViewPhoto.hidden = YES;
    _photoUploadView.buttonLargePhoto.backgroundColor = [UIColor clearColor];
    //_photoUploadView.buttonLargePhoto = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didClickThumbButton:(id)sender {
    
    _isThumbSelected = YES;
    [self showPicker];
}

-(void)didClickPhotoButton:(id)sender {
    
    _isThumbSelected = NO;
    [self showPicker];
}


-(void)showPicker {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    imagePicker.sourceType =
    UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
    
    imagePicker.allowsEditing = YES;
    
    
    if(DOES_SUPPORT_IOS7) {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    WHITE_TEXT_COLOR, NSForegroundColorAttributeName, nil];
        
        [[imagePicker navigationBar] setTitleTextAttributes:attributes];
        [[imagePicker navigationBar ] setTintColor:[UIColor whiteColor]];
        
    }
    
    [self presentViewController:imagePicker animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
    

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    
    // Handle a still image picked from a photo album
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        
        editedImage = (UIImage *)[info objectForKey: UIImagePickerControllerEditedImage];
        originalImage = (UIImage *)[info objectForKey: UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToUse = editedImage;
            
        } else {
            imageToUse = originalImage;
        }
        
        // Do something with imageToUse
        if(_isThumbSelected) {
            _imgThumb = imageToUse;
            [self displayImage:_photoUploadView.imgViewThumb image:imageToUse];
        }
        else {
            _imgPhoto = imageToUse;
            [self displayImage:_photoUploadView.imgViewPhoto image:imageToUse];
        }
        
    }
    
//    [[picker parentViewController] dismissViewControllerAnimated:YES completion:nil];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)displayImage:(UIImageView*) imgView image:(UIImage*)img{
    CGSize size = imgView.frame.size;
    
    if([MGUtilities isRetinaDisplay]) {
        size.height *= 2;
        size.width *= 2;
    }
    
    UIImage* croppedImage = [img imageByScalingAndCroppingForSize:size];
    imgView.image = croppedImage;
    
    [MGUtilities createBorders:imgView
                   borderColor:THEME_GREEN_TINT_COLOR
                   shadowColor:WHITE_TEXT_COLOR
                   borderWidth:3.0
                  borderRadius:0.0f];
}

-(IBAction)didClickDoneButton:(id)sender {
    
    if(_imgThumb == nil) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"IMAGE_SELECTION_ERROR")
                            message:LOCALIZED(@"IMAGE_SELECTION_ERROR_DETAILS")];
        
        return;
    }
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    NSString* className = NSStringFromClass([Photo class]);
    NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
    Photo* photo = (Photo*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    
    photo.thumb_url = [self writeImage:_imgThumb isThumb:YES];
    photo.photo_url = [self writeImage:_imgPhoto isThumb:NO];
    photo.isImagePicked = YES;
    photo.realestate_id = realEstate.realestate_id;
    
    [self.pickerDelegate returnPickerPhoto:photo];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString*)writeImage:(UIImage*)image isThumb:(int)isThumb {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/images"];
    
    NSError* error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:&error];
    }
    
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString* uniqueId = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    
    NSString* fileName = [NSString stringWithFormat:@"thumb_%@.png",uniqueId];
    
    if(!isThumb)
        fileName = [NSString stringWithFormat:@"large_%@.png",uniqueId];
    
    NSLog(@"filename = %@", fileName);
    
    NSString* path = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSData* data = UIImagePNGRepresentation(image);
    [data writeToFile:path atomically:YES];
    
    return path;
}


@end
