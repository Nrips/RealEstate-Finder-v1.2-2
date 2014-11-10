

#import "AgentImagesViewController.h"
#import "AppDelegate.h"

@interface AgentImagesViewController ()

@end

@implementation AgentImagesViewController

@synthesize agent;
@synthesize galleryView;
@synthesize arrayPhotos;
@synthesize parentView;
@synthesize agentPhotosDelegate = _agentPhotosDelegate;

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
    
    NSURL* url = [NSURL URLWithString:photo.thumb_url];
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

-(void)didClickDeleteButton:(id)sender {
    UIButton* button = (UIButton*)sender;
    int index = (int)button.tag;
    
    Photo* photo = [arrayPhotos objectAtIndex:index];
    
    if(photo.isImagePicked) {
        [MGFileManager deleteImageAtFilePath:photo.thumb_url];
        [MGFileManager deleteImageAtFilePath:photo.photo_url];
    }
    
    [arrayPhotos removeObjectAtIndex:index];
    [self updateGallery];
    
    for(int x = 0; x < _arrayPhotosFromFile.count; x++) {
        
        Photo* photoFromFile = [_arrayPhotosFromFile objectAtIndex:x];
        
        if([photo.thumb_url isEqualToString:photoFromFile.thumb_url] &&
           [photo.photo_url isEqualToString:photoFromFile.photo_url]) {
            [_arrayPhotosFromFile removeObjectAtIndex:x];
            break;
        }
    }
}

-(IBAction)didClickSelectImageButton:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Extra_iPhone" bundle:nil];
    AgentImageViewController*vc;
    vc = [storyboard instantiateViewControllerWithIdentifier:@"storyboardImagePicker"];
    vc.pickerDelegate = self;
    vc.agent = agent;
    vc.pickerDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(IBAction)didClickAddURLButton:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Extra_iPhone" bundle:nil];
    AgentUrlViewController*vc;
    vc = [storyboard instantiateViewControllerWithIdentifier:@"storyboardImageUrl"];
    vc.photoDelegate = self;
    vc.agent = agent;
    vc.photoDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)didClickDoneButton:(id)sender {
    
    if (arrayPhotos.count > MAX_PHOTOS_UPLOAD_AGENT) {
        NSString* status = [NSString stringWithFormat:@"Only %d photos are allowed to be define.", MAX_PHOTOS_UPLOAD_AGENT];
        [MGUtilities showAlertTitle:@"Max Photo Error" message:status];
        return;
    }
    
    [self.agentPhotosDelegate returnPhotoArrays:arrayPhotos];
    [self.agentPhotosDelegate returnPhotoArrayFromFile:_arrayPhotosFromFile];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"segueImagePicker"]) {
        
        
    }
    if([[segue identifier] isEqualToString:@"segueImageURL"]) {
        
        
    }
}

-(void)returnPhoto:(Photo *)photo {

    [arrayPhotos addObject:photo];
}

-(void) returnPickerPhoto:(Photo *)photo {

    [arrayPhotos addObject:photo];
    [_arrayPhotosFromFile addObject:photo];
}




@end
