//
//  OrderPaymentController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 21..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "OrderWebController.h"
#import "PaymentController.h"

@interface OrderPaymentController : OrderWebController<PaymentControllerDelegate>

@property (nonatomic) NSInteger orderId;
@property (nonatomic) NSInteger payableAmount;
@property (nonatomic,strong) NSString *orderCode;
@property (nonatomic,strong) NSString *selectedMethod;

@end
