//
//  OrderPaypalController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 22..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "OrderWebController.h"
#import "PayPal.h"
#import "ECNetworkHandler.h"

@interface OrderPaypalController : OrderWebController<DeviceReferenceTokenDelegate>
{
    ECNetworkHandler *handler;
}

@property (nonatomic,strong) NSMutableDictionary *jsonRequestData;
@property (nonatomic,strong) NSString *checkoutToken;
@property (nonatomic,strong) NSString *deviceReferenceToken;
@property (nonatomic,strong) NSDate *deviceTokenCreated;

@end
