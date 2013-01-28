//
//  BaseViewController.h
//  scomdcom
//
//  Created by Yongnam Park on 12. 9. 7..
//  Copyright (c) 2012년 Yongnam Park. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RightButtonTypeDone,
    RightButtonTypeNext,
    RightButtonTypeReply,
    RightButtonTypeTile,
    RightButtonTypeList,
    RightButtonTypeEdit
} RightButtonType;

typedef enum {
    LeftButtonTypeDevice,
    LeftButtonTypeCancel,
    LeftButtonTypeEdit,
    LeftButtonTypeDone
}LeftButtonType;

typedef enum {
    EmptyImageTypeNone,
    EmptyImageTypeCart,
    EmptyImageTypeZzim,
    EmptyImageTypeOrder,
    EmptyImageTypeQna,
    EmptyImageTypeInquery
} EmptyImageType;

@protocol MyController;
@protocol MyController <NSObject>
@optional
- (void)justSelected;
@end


@interface BaseViewController : UIViewController{
    UIView *_loadingMask;
    UIImageView *_empty;
    
}

- (void)back;
- (void)cancel;
- (void)done;
- (void)close;
- (void)next;
- (void)reply;
- (void)zzim;
- (void)customAction;
- (void)edit;
- (void)device;
- (void)list;
- (void)tile;

- (void)viewShouldRefresh;

- (void)setLeftBackButton;
- (void)setLeftCloseButton;
- (void)setLeftCancelButton;
- (void)setRightButtonType:(RightButtonType)type;
- (void)setLeftButtonType:(LeftButtonType)type;
- (void)setRightCustomButtonWithTitle:(NSString*)title target:(id)target selector:(SEL)selecto;
- (void)setLeftCustomButtonWithTitle:(NSString*)title target:(id)target selector:(SEL)selector;
- (void)setLeftCustomButtonWithTitle:(NSString*)title;
- (void)setRightZzimButtonZzimmed:(BOOL)zzimmed target:(id) target;
- (void)setRightEditButton;
- (void)setLeftDoneButton;
- (void)setLeftEditButton;
- (void)setRightCustomButtonWithTitle:(NSString*)title;
- (void)setRightCustomDoneButtonWithTitle:(NSString*)title;

- (void)showBlackLoadingMask;
- (void)hideBlackLoadingMask;


- (void)showEmptyViewType:(EmptyImageType)type;


@end
