//
//  NoticeViewController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 29..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "BaseViewController.h"

@interface NoticeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *_tableView;
    
    NSMutableArray *_listData;
}

@end
