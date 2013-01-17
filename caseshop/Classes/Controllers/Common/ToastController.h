//
//  ToastController.h
//  scomdcom
//
//  Created by Yongnam Park on 12. 10. 11..
//  Copyright (c) 2012년 Yongnam Park. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    ToastTypeZzim,
    ToastTypeUnzzim
}ToastType;

@interface ToastController : NSObject{

}

@property (nonatomic,strong) UIView *toastView;

+ (void)showMiniToast:(NSString*)text;
+ (void)showToast:(ToastType)type;
+ (void)showToastImage:(UIImage*)image;
- (void)hide;
+ (ToastController*)instance;
@end
