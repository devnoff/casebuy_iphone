//
//  ShopMainController.h
//  caseshop
//
//  Created by Yongnam Park on 13. 1. 24..
//  Copyright (c) 2013년 CultStory Inc. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductListController.h"
#import "ProductTileController.h"

@interface ShopMainController : BaseViewController{
    
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UIActivityIndicatorView *_activity;
    UITableView *_tableView;

    IBOutlet UIImageView *pop1;
    IBOutlet UIImageView *pop2;
    IBOutlet UIImageView *pop3;
    IBOutlet UIImageView *pop4;
    
    IBOutlet UIImageView *new1;
    IBOutlet UIImageView *new2;
    IBOutlet UIImageView *new3;
    IBOutlet UIImageView *new4;
    IBOutlet UIImageView *new5;
    IBOutlet UIImageView *new6;
    
    IBOutlet UIImageView *best1;
    IBOutlet UIImageView *best2;
    IBOutlet UIImageView *best3;
    IBOutlet UIImageView *best4;
    
    NSArray *_pops;
    NSArray *_news;
    NSArray *_bests;
    
    ProductTileController *_tileController;
    ProductListController *_listController;
    NSMutableArray *_listData;
    
    
}


@property (nonatomic) NSInteger categoryId;

- (void)loadData;
@end
