//
//  ToastController.m
//  scomdcom
//
//  Created by Yongnam Park on 12. 10. 11..
//  Copyright (c) 2012년 Yongnam Park. All rights reserved.
//

#import "ToastController.h"

static ToastController *instance;
@implementation ToastController
@synthesize toastView;


+ (ToastController*)instance{
    if (!instance){
        instance = [[ToastController alloc] init];
    }
    return instance;
}

+ (void)showMiniToast:(NSString*)text{
    
    UIWindow *window = (UIWindow*)[[[UIApplication sharedApplication] windows]objectAtIndex:0];
    UIViewController *root = [window rootViewController];
    
    CGRect rootFrame = root.view.frame;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    label.center = root.view.center;
    
    CGRect frame = label.frame;
    frame.origin.y = rootFrame.size.height - 48 - 20;
    label.frame = frame;
    
    label.text = text;
    label.backgroundColor = [UIColor colorWithRed:0.431 green:0.792 blue:0.992 alpha:1.000];
    label.font = [UIFont boldSystemFontOfSize:14.0f];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.alpha = .0f;
    
    [root.view addSubview:label];
    
    [UIView animateWithDuration:0.7f
                     animations:^{
                         label.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:1.5f
                                          animations:^{
                                              label.alpha = .0f;
                                          } completion:^(BOOL finished) {
                                              [label removeFromSuperview];
                                          }];
                     }];
}

+ (void)showToast:(ToastType)type{
    
    UIWindow *window = (UIWindow*)[[[UIApplication sharedApplication] windows]objectAtIndex:0];
    UIViewController *root = [window rootViewController];
    
    UIImage *toastBgImage = [UIImage imageNamed:@"ToastBg.png"];
    CGSize size = toastBgImage.size;
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    bgView.image = toastBgImage;
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:bgView.frame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    if (type == ToastTypeZzim){
        label.text = @"찜";
    } else if (type==ToastTypeUnzzim){
        label.text = @"찜 해제";
    }
    
    [bgView addSubview:label];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    bgView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
    
    
    bgView.alpha = .0f;
    [root.view addSubview:bgView];
    
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         bgView.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                         [NSThread sleepForTimeInterval:1];
                         
                         [UIView animateWithDuration:0.5f
                                          animations:^{
                                              bgView.alpha = .0f;
                                          } completion:^(BOOL finished) {
                                              [bgView removeFromSuperview];
                                          }];
                     }];
    

}

- (void)hide{
    if (toastView){
        [UIView animateWithDuration:0.3f
                         animations:^{
                             toastView.alpha = .0f;
                         } completion:^(BOOL finished) {
                             [toastView removeFromSuperview];
                             toastView = nil;
                         }];
    }
    
    
}

+ (void)showToastImage:(UIImage*)image{
    UIWindow *window = (UIWindow*)[[[UIApplication sharedApplication] windows]objectAtIndex:0];
    UIViewController *root = [window rootViewController];
    
    
    
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor clearColor];
    
    UIImage *toastBgImage = image;
    CGSize size = toastBgImage.size;
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    bgView.userInteractionEnabled = YES;
    bgView.image = toastBgImage;

    ToastController *toast = [ToastController instance];
    toast.toastView = view;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:toast action:@selector(hide)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [bgView addGestureRecognizer:tap];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    bgView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
    
    bgView.alpha = .0f;
    [view addSubview:bgView];
    
    if (root.modalViewController)
        [root.modalViewController.view addSubview:view];
    else
        [root.view addSubview:view];
    
    
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         bgView.alpha = 1.0f;
                         bgView.transform = CGAffineTransformMakeScale(1.3, 1.3);
                     } completion:^(BOOL finished) {
                         
                         
                         [UIView animateWithDuration:0.3f
                                          animations:^{
                                              bgView.transform = CGAffineTransformMakeScale(1, 1);
                                          } completion:^(BOOL finished) {
                                              [NSThread sleepForTimeInterval:1];
                                              [toast hide];
                                          }];
                     }];

}


@end
