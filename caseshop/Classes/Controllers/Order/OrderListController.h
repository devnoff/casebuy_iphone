//
//  OrderListController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 9..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderListController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    IBOutlet UITableView *_tableView;
    NSMutableArray *_listData;
    
    UIRefreshControl *refreshControl;
}

@end
