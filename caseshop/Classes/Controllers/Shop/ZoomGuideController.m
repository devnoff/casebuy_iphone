//
//  ZoomGuideController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 12. 12..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "ZoomGuideController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ZoomGuideController


+ (void)showGuideForView:(UIView*)view{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:.65];
    bgView.alpha = .0f;
    [view addSubview:bgView];
    
    
    CGPoint center = bgView.center;
    
    UIImage *leftImg = [UIImage imageNamed:@"Finger_Point"];
    UIImage *rightImg = [UIImage imageNamed:@"Finger_Point"];
    UIImage *caseImg = [UIImage imageNamed:@"Case_Model"];
    UIImage *caseImg1 = [UIImage imageNamed:@"Case_Model"];
    
    UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, leftImg.size.width, leftImg.size.height)];
    left.center = CGPointMake(center.x -20, center.y+20);
    left.alpha = .0f;
    left.image = leftImg;
    UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, rightImg.size.width, rightImg.size.height)];
    right.center = CGPointMake(center.x +20, center.y-20);
    right.alpha = .0f;
    right.image = rightImg;
    UIImageView *caseView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, caseImg.size.width, caseImg.size.height)];
    caseView.center = CGPointMake(center.x, center.y-caseImg.size.height);
    caseView.alpha = .0f;
    caseView.image = caseImg;
    UIImageView *caseView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, caseImg1.size.width, caseImg1.size.height)];
    caseView1.center = CGPointMake(center.x + 320, center.y-caseImg1.size.height);
    caseView1.alpha = .0f;
    caseView1.image = caseImg1;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    label.transform = CGAffineTransformMakeScale(.2, .2);
    label.textAlignment = UITextAlignmentCenter;
    label.center = center;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.0f];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor colorWithWhite:0 alpha:.4];
    label.shadowOffset = CGSizeMake(0, 1);
    label.text = NSLocalizedString(@"PINCH ZOOM", nil);
    label.alpha = .0f;
    
    [bgView addSubview:left];
    [bgView addSubview:right];
    [bgView addSubview:label];
    [bgView addSubview:caseView];
    [bgView addSubview:caseView1];
    
    // 핀치 줌 애니메이션
    [UIView transitionWithView:bgView
                      duration:.3
                       options: UIViewAnimationCurveEaseOut
                     animations:^{
                         bgView.alpha = 1.0f;
                         left.alpha = 1.0f;
                         right.alpha = 1.0f;
                         label.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         
                         if (finished){
                             [UIView transitionWithView:bgView
                                               duration:.7
                                                options: UIViewAnimationCurveEaseIn
                                             animations:^{
                                                 
                                                 left.transform = CGAffineTransformMakeTranslation(-50, 50);
                                                 right.transform = CGAffineTransformMakeTranslation(50, -50);
                                                 label.transform = CGAffineTransformMakeScale(1, 1);

                                             }
                                             completion:^(BOOL finished) {
                                                 [NSThread sleepForTimeInterval:.8];
                                                 
                                                 [UIView animateWithDuration:.4
                                                                  animations:^{
                                                                      left.alpha = .0f;
                                                                      right.alpha = .0f;
                                                                      label.alpha = .0f;
//                                                                      caseView.alpha = 1.0f;
                                                                  }
                                                                  completion:^(BOOL finished) {
                                                                      
                                                                      // 슬라이드 애니메이션
                                                                      label.text = NSLocalizedString(@"SLIDE PAGE", nil);
                                                                      label.center = CGPointMake(center.x, center.y - 70);
                                                                      left.transform = CGAffineTransformMakeTranslation(0, 0);
                                                                      left.center = CGPointMake(center.x + (50 + 20), center.y);
                                                                      left.alpha = 1.0f;
                                                                      
                                                                      [UIView transitionWithView:bgView
                                                                                        duration:.8
                                                                                         options: UIViewAnimationCurveEaseOut
                                                                                      animations:^{
                                                                                          label.alpha = 1.0f;
                                                                                          
                                                                                          left.transform = CGAffineTransformTranslate(left.transform, -140, 0);
                                                                                          caseView.center = CGPointMake(center.x - 320, center.y-caseImg.size.height);
                                                                                          caseView1.center = CGPointMake(center.x, center.y-caseImg.size.height);
//                                                                                          caseView1.alpha = 1.0f;
                                                                                      }
                                                                                      completion:^(BOOL finished) {
                                                                                          [NSThread sleepForTimeInterval:.8];
                                                                                          
                                                                                          if (finished){
                                                                                              [UIView animateWithDuration:.3
                                                                                                               animations:^{
                                                                                                                   bgView.alpha = 0.0f;
                                                                                                               }
                                                                                                               completion:^(BOOL finished) {
                                                                                                                   [bgView removeFromSuperview];
                                                                                                               }];
                                                                                          }
                                                                                          
                                                                                      }];
                                                                      
                                                                  }];
                                                 
                                             }];
                         }

                     }];
    
    
    
    
}


@end
