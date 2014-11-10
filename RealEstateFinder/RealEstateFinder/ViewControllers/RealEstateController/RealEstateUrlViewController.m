

#import "RealEstateUrlViewController.h"
#import "AppDelegate.h"

@interface RealEstateUrlViewController ()

@end

@implementation RealEstateUrlViewController

@synthesize textFieldPhotoUrl;
@synthesize textFieldThumbUrl;
@synthesize photoDelegate = _photoDelegate;
@synthesize realEstate;

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
    
    [MGUtilities createBordersInView:textFieldPhotoUrl
                         borderColor:THEME_GREEN_TINT_COLOR
                         shadowColor:[UIColor clearColor]
                         borderWidth:2.0f
                        borderRadius:0.0];
    
    [MGUtilities createBordersInView:textFieldThumbUrl
                         borderColor:THEME_GREEN_TINT_COLOR
                         shadowColor:[UIColor clearColor]
                         borderWidth:2.0f
                        borderRadius:0.0];
    
    textFieldPhotoUrl.delegate = self;
    textFieldThumbUrl.delegate = self;
    
    
    textFieldPhotoUrl.autocorrectionType = UITextAutocorrectionTypeNo;
    textFieldThumbUrl.autocorrectionType = UITextAutocorrectionTypeNo;
    textFieldPhotoUrl.text = @"";
    textFieldThumbUrl.text = @"http://www.mcbridehomes.com/images/community/slideshow/med/1552.jpg";
}

- (void)viewWillAppear:(BOOL)animated
{
    //
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > MAX_CHARS_INPUT) ? NO : YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)didClickDoneButton:(id)sender {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    NSString* className = NSStringFromClass([Photo class]);
    NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
    
    
    Photo* photo = (Photo*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    
    photo.photo_url = [textFieldPhotoUrl text];
    photo.thumb_url = [textFieldThumbUrl text];
    photo.isImagePicked = NO;
    photo.realestate_id = realEstate.realestate_id;
    
    if([photo.thumb_url length] == 0) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"TEXTFIELD_EMPTY_ERROR")
                            message:LOCALIZED(@"TEXTFIELD_EMPTY_ERROR_DETAILS")];
        
        return;
    }

    [self.photoDelegate returnPhoto:photo];
    
//    [parentViewController.arrayPhotos addObject:photo];
    [self.navigationController popViewControllerAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
