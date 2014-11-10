//
//  SearchRawView.m
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "SearchRawView.h"

@implementation SearchRawView

//@synthesize pickerPrice;
@synthesize buttonPropertyType;
@synthesize segmentBeds;
@synthesize segmentBaths;

//@synthesize pickerSquareFootage;
//@synthesize pickerYearsBuilt;
//@synthesize pickerLotSize;

@synthesize rangeSliderPrice;
@synthesize rangeSliderSquareFoot;
@synthesize rangeSliderBuiltIn;
@synthesize rangeSliderLotSize;

@synthesize labelPriceMin;
@synthesize labelPriceMax;

@synthesize labelSquareFootMin;
@synthesize labelSquareFootMax;

@synthesize labelBuiltInMin;
@synthesize labelBuiltInMax;

@synthesize labelLotSizeMin;
@synthesize labelLotSizeMax;

@synthesize labelFilters;
@synthesize labelPriceRange;
@synthesize labelPropertyType;
@synthesize labelBeds;
@synthesize labelBaths;
@synthesize labelSquareFootage;
@synthesize labelYearsBuilt;
@synthesize labelLotSize;

-(id)initWithNibName:(NSString*)nibNameOrNil {
    
    self = [super init];
    
    if (self) {
        // Initialization code
        NSArray* _nibContents = [[NSBundle mainBundle] loadNibNamed:nibNameOrNil
                                                              owner:self
                                                            options:nil];
        self = [_nibContents objectAtIndex:0];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame nibName:(NSString*)nibNameOrNil {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        NSArray* _nibContents = [[NSBundle mainBundle] loadNibNamed:nibNameOrNil
                                                              owner:self
                                                            options:nil];
        self = [_nibContents objectAtIndex:0];
        //        self.frame = frame;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    for (UIView * view in [self subviews]) {
        if (view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
            return YES;
        }
    }
    return NO;
}


@end
