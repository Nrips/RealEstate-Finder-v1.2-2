//
//  KOPopupView.h
//  KOPopupViewExample
//
//  
//  Copyright (c) 2013 Kohtenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KOPopupView : UIView

@property (nonatomic, strong) UIView *handleView;
+ (KOPopupView *)popupView;
- (void)show;
- (void)hideAnimated:(BOOL)animated;
- (void)willRotateToOrientation:(UIInterfaceOrientation) toInterfaceOrientation withDuration:(NSTimeInterval)duration;
@end
