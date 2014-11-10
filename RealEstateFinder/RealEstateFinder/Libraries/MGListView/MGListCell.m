

#import "MGListCell.h"

@implementation MGListCell


@synthesize labelTitle;
@synthesize labelSubtitle;
@synthesize topLeftLabelSubtitle;


@synthesize labelDescription;
@synthesize labelInfo;
@synthesize labelDetails;
@synthesize labelExtraInfo;
@synthesize imgViewThumb;
@synthesize imgViewBg;
@synthesize imgViewPic;


@synthesize selectedImage;
@synthesize unselectedImage;
@synthesize imgViewSelectionBackground;

@synthesize selectedColor;
@synthesize unSelectedColor;
@synthesize imgViewArrow;

@synthesize selectedImageArrow;
@synthesize unselectedImageArrow;

@synthesize selectedImageIcon;
@synthesize unselectedImageIcon;

@synthesize imgViewIcon;

@synthesize object;


@synthesize labelStatus;
@synthesize labelPrice;
@synthesize labelBeds;
@synthesize labelBath;
@synthesize labelSqft;
@synthesize labelPriceSqft;
@synthesize labelRooms;
@synthesize labelLotSize;
@synthesize labelBuiltIn;
@synthesize labelPropertyType;
@synthesize labelDateAdded;
@synthesize labelAddress;
@synthesize labelAddress2;
@synthesize labelDesc;

@synthesize labelStatusVal;
@synthesize labelPriceVal;
@synthesize labelBedsVal;
@synthesize labelBathVal;
@synthesize labelSqftVal;
@synthesize labelPriceSqftVal;
@synthesize labelRoomsVal;
@synthesize labelLotSizeVal;
@synthesize labelBuiltInVal;
@synthesize labelPropertyTypeVal;
@synthesize labelDateAddedVal;
@synthesize topLeftLabelAddressVal;
@synthesize topLeftLabelAddress2Val;
@synthesize topLeftLabelDescVal;
@synthesize mapViewCell;

@synthesize labelHeader1;
@synthesize labelHeader2;
@synthesize labelHeader3;
@synthesize labelHeader4;
@synthesize imgViewFave;

@synthesize buttonDirections;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
    [super setSelected:selected animated:animated];
    
    if(selected) {
        imgViewSelectionBackground.image = selectedImage;
        imgViewArrow.image = selectedImageArrow;
        labelTitle.textColor = selectedColor;
        imgViewIcon.image = selectedImageIcon;
    }
    else {
        imgViewSelectionBackground.image = unselectedImage;
        imgViewArrow.image = unselectedImageArrow;
        labelTitle.textColor = unSelectedColor;
        imgViewIcon.image = unselectedImageIcon;
    }
}

@end
