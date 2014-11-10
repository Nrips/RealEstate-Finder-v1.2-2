//
//  Detail2ViewController.m
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "Detail2ViewController.h"

@interface Detail2ViewController ()

@end

@implementation Detail2ViewController
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
    
    _detailImageView = [[MGRawView alloc]  initWithNibName:@"DetailImageView"];
    _detailImageView.imgViewPhoto.contentMode = UIViewContentModeScaleAspectFill;
    _detailImageView.imgViewPhoto.clipsToBounds = YES;
    _imageHeight = _detailImageView.imgViewPhoto.frame.size.height;
    
    Photo* p = [CoreDataController getPhotoByRealEstateId:[realEstate.realestate_id intValue]];
    
    if(p != nil)
        [self setImage:p.photo_url imageView:_detailImageView.imgViewPhoto];
    
    
    _detailView = [[MGRawView alloc]  initWithNibName:@"DetailView"];
    
    [self.view addSubview:_detailImageView];
    
//    UIEdgeInsets contentInset = scrollViewMain.contentInset;
//    contentInset.top = 64;
    
    scrollViewMain.delegate = self;
//    scrollViewMain.contentInset = contentInset;
    scrollViewMain.contentSize = _detailView.frame.size;
    [scrollViewMain addSubview:_detailView];
    scrollViewMain.layer.zPosition = 999;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    NSLog(@"url: %@", urlRequest);
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:MAP_INFO_PLACEHOLDER_IMAGE];
    
    [imgView setImageWithURLRequest:urlRequest
                   placeholderImage:imgPlaceholder
                            success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
                                
                                CGSize size = weakImgRef.frame.size;
                                
                                if([MGUtilities isRetinaDisplay]) {
                                    size.height *= 2;
                                    size.width *= 2;
                                }
                                
                                UIImage* croppedImage = [image imageByScalingAndCroppingForSize:size];
                                weakImgRef.image = croppedImage;
                                
                            } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                
                            }];
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat yPos = -scrollView.contentOffset.y;
    
    if (yPos > 0) {
        CGRect imgRect = _detailImageView.imgViewPhoto.frame;
//        imgRect.origin.y = scrollView.contentOffset.y;
        imgRect.size.height =  200 + yPos;
        _detailImageView.imgViewPhoto.frame = imgRect;
        
        NSLog(@"s = %@", NSStringFromCGRect(_detailImageView.imgViewPhoto.frame));
    }
    
    
}

@end
