

#import "RealEstateImagesViewController.h"
#import "AppDelegate.h"

@interface RealEstateImagesViewController ()

@end

@implementation RealEstateImagesViewController

@synthesize realEstate;
@synthesize galleryView;
@synthesize arrayPhotos;
@synthesize parentView;
@synthesize realEstatePhotosDelegate = _realEstatePhotosDelegate;

@synthesize buttonAddImage;
@synthesize buttonAddURL;
@synthesize buttonDone;

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
    
    if(arrayPhotos == nil)
        arrayPhotos = [NSMutableArray new];
    
    galleryView = [[MGGalleryView alloc] initWithFrame:parentView.frame nibName:@"GalleryEntryView"];
    galleryView.frame = CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height);
    
    galleryView.galleryDelegate = self;
    galleryView.numberOfColumns = 4;
    galleryView.spacing = 4;
    galleryView.height = 75;
    galleryView.backgroundColor = [UIColor clearColor];
    [parentView addSubview:galleryView];
    
    UIEdgeInsets insets = galleryView.contentInset;
    UIEdgeInsets insetsScroll = galleryView.scrollIndicatorInsets;
    
    insets.top = TOP_BAR_OFFSET;
    galleryView.contentInset = insets;
    
    insetsScroll.top = TOP_BAR_OFFSET;
    galleryView.scrollIndicatorInsets = insetsScroll;
    
    _arrayPhotosFromFile = [NSMutableArray new];
    
    [buttonAddURL setTitle:LOCALIZED(@"BUTTON_ADD_URL") forState:UIControlStateNormal];
    [buttonAddURL setTitle:LOCALIZED(@"BUTTON_ADD_URL") forState:UIControlStateSelected];
    
    [buttonAddImage setTitle:LOCALIZED(@"BUTTON_ADD_IMAGE") forState:UIControlStateNormal];
    [buttonAddImage setTitle:LOCALIZED(@"BUTTON_ADD_IMAGE") forState:UIControlStateSelected];
    
    [buttonDone setTitle:LOCALIZED(@"BUTTON_DONE") forState:UIControlStateNormal];
    [buttonDone setTitle:LOCALIZED(@"BUTTON_DONE") forState:UIControlStateSelected];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self updateGallery];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

-(void) updateGallery {

    galleryView.numberOfItems = arrayPhotos.count;
    [galleryView setNeedsReLayout];
}

#pragma mark - Gallery

-(void) MGGalleryView:(MGGalleryView *)galleryView didCreateView:(MGRawView *)rawView atIndex:(int)index {
    
    Photo* photo = [arrayPhotos objectAtIndex:index];
    
    [rawView.buttonDelete setTag:index];
    [rawView.buttonDelete addTarget:self
                             action:@selector(didClickDeleteButton:)
                   forControlEvents:UIControlEventTouchUpInside];
    
    if(photo.isImagePicked) {
        
        NSData* imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:photo.thumb_url]];
        UIImage* thumbNail = [[UIImage alloc] initWithData:imgData];
        
        CGSize size = rawView.imgViewThumb.frame.size;
        if([MGUtilities isRetinaDisplay]) {
            size.height *= 2;
            size.width *= 2;
        }
        
        UIImage* croppedImage = [thumbNail imageByScalingAndCroppingForSize:size];
        rawView.imgViewThumb.image = croppedImage;
        
        [MGUtilities createBorders:rawView.imgViewThumb
                       borderColor:THEME_GREEN_TINT_COLOR
                       shadowColor:WHITE_TEXT_COLOR
                       borderWidth:3.0
                      borderRadius:0.0f];
        
        return;
    }
    
    NSURL* url = [NSURL URLWithString:photo.photo_url];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(rawView.imgViewThumb ) weakImgRef = rawView.imgViewThumb;
    UIImage* imgPlaceholder = [UIImage imageNamed:GALLERY_THUMB_PLACEHOLDER_IMAGE];
    
    [rawView.imgViewThumb setImageWithURLRequest:urlRequest placeholderImage:imgPlaceholder
     
    success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
         
         CGSize size = weakImgRef.frame.size;
         
         if([MGUtilities isRetinaDisplay]) {
             size.height *= 2;
             size.width *= 2;
         }
         
         UIImage* croppedImage = [image imageByScalingAndCroppingForSize:size];
         weakImgRef.image = croppedImage;
         
         [MGUtilities createBorders:weakImgRef
                        borderColor:THEME_GREEN_TINT_COLOR
                        shadowColor:WHITE_TEXT_COLOR
                        borderWidth:3.0
                       borderRadius:0.0f];
         
    } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
        
        [MGUtilities createBorders:weakImgRef
                       borderColor:THEME_GREEN_TINT_COLOR
                       shadowColor:WHITE_TEXT_COLOR
                       borderWidth:3.0
                      borderRadius:0.0f];
    }];
}

-(void)didClickDeleteButton:(id)sender
{
    //TODO: Delete Photo Issue.
    
    UIButton* button = (UIButton*)sender;
    
    int index = (int)button.tag;
    
    Photo* photo = [arrayPhotos objectAtIndex:index];
    
    if(photo.isImagePicked)
    {
        [MGFileManager deleteImageAtFilePath:photo.thumb_url];
    }
    
    [arrayPhotos removeObjectAtIndex:index];
    [self updateGallery];
    
    for(int x = 0; x <_arrayPhotosFromFile.count; x++) {
        
        Photo* photoFromFile = [_arrayPhotosFromFile objectAtIndex:x];
        
        if([photo.thumb_url isEqualToString:photoFromFile.thumb_url])
        {
            [_arrayPhotosFromFile removeObjectAtIndex:x];
            break;
        }
    }
}

-(IBAction)didClickSelectImageButton:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Extra_iPhone" bundle:nil];
    RealEstateImageViewController*vc;
    vc = [storyboard instantiateViewControllerWithIdentifier:@"storyboardImagePickerRealEstate"];
    vc.pickerDelegate = self;
    vc.realEstate = realEstate;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(IBAction)didClickAddURLButton:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Extra_iPhone" bundle:nil];
    RealEstateUrlViewController*vc;
    vc = [storyboard instantiateViewControllerWithIdentifier:@"storyboardImageUrlRealEstate"];
    vc.photoDelegate = self;
    vc.realEstate = realEstate;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)didClickDoneButton:(id)sender {
    
    if (arrayPhotos.count > MAX_PHOTOS_UPLOAD_REALESTATE) {
        
        NSString* status = [NSString stringWithFormat:@"%d %@",
                            MAX_PHOTOS_UPLOAD_AGENT,
                            LOCALIZED(@"MAX_PHOTOS_UPLOAD_AGENT")];
        
        [MGUtilities showAlertTitle:LOCALIZED(@"MAX_PHOTOS_UPLOAD_AGENT_ERROR")
                            message:status];
        return;
    }
    
    [self.realEstatePhotosDelegate returnPhotoArrays:arrayPhotos];
    [self.realEstatePhotosDelegate returnPhotoArrayFromFile:_arrayPhotosFromFile];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)returnPhoto:(Photo *)photo {

    [arrayPhotos addObject:photo];
    
    // TODO: Adding URL.
    [_arrayPhotosFromFile addObject:photo];
}

-(void) returnPickerPhoto:(Photo *)photo {

    [arrayPhotos addObject:photo];
    [_arrayPhotosFromFile addObject:photo];
}




@end
