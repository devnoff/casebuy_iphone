//
//  ProductLikedController.h
//  caseshop
//
//  Created by Yongnam Park on 13. 1. 28..
//  Copyright (c) 2013년 CultStory Inc. All rights reserved.
//

#import "MoreViewController.h"
#import "ProductListController.h"

@interface ProductLikedController : MoreViewController<ProductListControllerDelegate>{
    ProductListController *_productList;
    
}

@end
