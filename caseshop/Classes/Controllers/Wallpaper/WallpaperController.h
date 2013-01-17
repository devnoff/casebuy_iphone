//
//  WallpaperController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 24..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "BaseViewController.h"

@interface WallpaperController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *_tableView;
    IBOutlet UIActivityIndicatorView *_activity;
    NSMutableArray *_listData;
    
    UIRefreshControl *refreshControl;
    
    UIView *footerView;
    
    BOOL loadingData;
}

@property (nonatomic) NSInteger relatedCaseId;

@end
