//
//  ProductListController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 26..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface ProductListController : NSObject<UITableViewDataSource, UITableViewDelegate>{

    NSMutableArray *_listData;
    
}

@property (nonatomic,strong) NSMutableArray *listData;
@property (nonatomic,strong) UIViewController *parentController;

@end
