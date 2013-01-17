//
//  OrderInfoController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 21..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "OrderWebController.h"
#import "AddressFinishController.h"

@interface OrderInfoController : OrderWebController<AddressFinishControllerDelegate>{

}

@property (nonatomic,strong) NSString *targetName;

@end
