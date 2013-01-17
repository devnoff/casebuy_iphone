//
//  PaymentController.h
//  scomdcom
//
//  Created by Yongnam Park on 12. 10. 4..
//  Copyright (c) 2012년 Yongnam Park. All rights reserved.
//

#import "BaseViewController.h"

#define CSPaymentMethodCard @"card"
#define CSPaymentMethodVirtual @"virtual"
#define CSPaymentMethodMobile @"hp"


@protocol PaymentControllerDelegate;
@interface PaymentController : BaseViewController<UIWebViewDelegate,UITextFieldDelegate>{
    IBOutlet UIWebView *_webView;
    
    IBOutlet UITextField *_textField;
    
}

@property (nonatomic) NSInteger orderId;
@property (nonatomic,strong) NSString *method;
@property (nonatomic,strong) NSMutableDictionary *virInfo;
@property (nonatomic,weak) id<PaymentControllerDelegate> delegate;

@end


@protocol PaymentControllerDelegate <NSObject>

- (void)paymentControllerSuccessPaid:(PaymentController*)controller;
- (void)paymentControllerFailedPaid:(PaymentController*)controller;
- (void)paymentControllerCancelPayment:(PaymentController*)controller;

@end