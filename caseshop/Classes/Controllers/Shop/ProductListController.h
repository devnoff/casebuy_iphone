//
//  ProductListController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 26..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol ProductListControllerDelegate;
@interface ProductListController : NSObject<UITableViewDataSource, UITableViewDelegate>{

    NSMutableArray *_listData;
    
}

@property (nonatomic,assign) id<ProductListControllerDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *listData;
@property (nonatomic,strong) UIViewController *parentController;
@property (nonatomic) BOOL canEdit;

@end


@protocol ProductListControllerDelegate <NSObject>

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

@end