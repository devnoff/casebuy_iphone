//
//  ShopMainController.m
//  caseshop
//
//  Created by Yongnam Park on 13. 1. 24..
//  Copyright (c) 2013년 CultStory Inc. All rights reserved.
//

#import "ShopMainController.h"
#import "DeviceSelectController.h"
#import "API.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ShopViewController.h"

#define FLAG_POP 1
#define FLAG_NEW 2
#define FLAG_ALL 3
#define FLAG_BEST 4

@interface ShopMainController ()

@end

@implementation ShopMainController
@synthesize categoryId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



#pragma mark - InitailizeView


- (void)initForTableView{
    
    _scrollView.hidden = YES;
    _tableView.hidden = NO;
    
    [self setRightButtonType:RightButtonTypeTile];
    
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:_tableView];
        
    }
    
    [self dataForList];
    
}

- (void)initForMainContent{
    self.navigationItem.rightBarButtonItem = nil;
    _tableView.hidden = YES;
    _scrollView.hidden = NO;
}

- (void)list{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self dataForList];
    [_tableView reloadData];
    
    [UIView transitionWithView:_tableView
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        
                    }
                    completion:^(BOOL finished){
                        self.navigationItem.rightBarButtonItem.enabled = YES;
                        [self setRightButtonType:RightButtonTypeTile];
                        
                    }];
    
    
}

- (void)tile{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self dataForTile];
    [_tableView reloadData];
    [UIView transitionWithView:_tableView
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        
                    }
                    completion:^(BOOL finished){
                        self.navigationItem.rightBarButtonItem.enabled = YES;
                        [self setRightButtonType:RightButtonTypeList];
                        
                    }];
}


- (void)dataForList{
    _tableView.delegate = _listController;
    _tableView.dataSource = _listController;
    _listController.listData = _listData;
}

- (void)dataForTile{
    _tableView.delegate = _tileController;
    _tableView.dataSource = _tileController;
    _tileController.listData = _listData;
}

#pragma mark - Button Actions

- (void)device{
    DeviceSelectController *device = [[DeviceSelectController alloc] initWithNibName:@"DeviceSelectController" bundle:nil];
    device.currDeviceIdx = 1;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:device];
    [self presentModalViewController:nav animated:YES];
}


- (IBAction)flagBtnTapped:(id)sender{
    ShopViewController *shop = [[ShopViewController alloc] initWithNibName:@"ShopViewController" bundle:nil];
    shop.categoryId = self.categoryId;
    shop.shopType = ShopTypeList;
    shop.dispType = ShopDispTypeCategoryProductsList;
    
    if ([(UIButton*)sender tag] == FLAG_ALL){
        shop.flag = @"";
    }
    else if ([(UIButton*)sender tag] == FLAG_POP){
        shop.flag = @"pop";
    }
    else if ([(UIButton*)sender tag] == FLAG_NEW){
        shop.flag = @"new";
    }
    else if ([(UIButton*)sender tag] == FLAG_BEST){
        shop.flag = @"hit";
    }
    
    
    shop.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shop animated:YES];
}


#pragma mark - Data

- (void)getProductCountOfCategory{
    
    
    API *apiRequest = [[API alloc] init];
    
    [apiRequest get:[NSString stringWithFormat:@"s/productCountCategory?categories_id=%d",categoryId]
       successBlock:^(NSDictionary *result){
           NSLog(@"result: %@", result);
           
           _activity.alpha = .0f;
           
           int resultCode = [[result objectForKey:@"code"] intValue];
           if (resultCode == kAPI_RESULT_OK){
               
               NSInteger count = [[result objectForKey:@"result"] integerValue];
               NSInteger minCount = [[result objectForKey:@"min_count"] integerValue];
               
               if (count < minCount){
                   // 상품 바로 보기
                   [self loadProductData];
                   
               } else {
                   // 메인 상품 보기
                   [self loadMainContentData];
               }
               
               
           }
           
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);
        }];
}

- (void)loadMainContentData{
    API *apiRequest = [[API alloc] init];
    
    [self clearThumbnails];
    
    [apiRequest get:[NSString stringWithFormat:@"s/mainContentCategory?categories_id=%d",categoryId]
       successBlock:^(NSDictionary *result){
           NSLog(@"mainContentCategory: %@, category id: %d", result, categoryId);
           
           int resultCode = [[result objectForKey:@"code"] intValue];
           if (resultCode == kAPI_RESULT_OK){
               
               NSDictionary *data = [result objectForKey:@"result"];
               [self setContentThumbnailsForData:data];
               
               [self initForMainContent];
           }
           
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);
            
        }];
}

- (void)loadProductData{
    API *apiRequest = [[API alloc] init];
    
    [_listData removeAllObjects];
    [apiRequest get:[NSString stringWithFormat:@"s/categoryProducts?categories_id=%d&offset=%d",categoryId,_listData.count]
       successBlock:^(NSDictionary *result){
           NSLog(@"loadProductData: %@", result);
           int resultCode = [[result objectForKey:@"code"] intValue];
           if (resultCode == kAPI_RESULT_OK){
               
               BOOL flashScroll = _listData.count > 0;
               
               
               [_listData addObjectsFromArray:[result objectForKey:@"result"]];
               [_tableView reloadData];
               
               
               [self initForTableView];
               
               if (flashScroll){
                   [_tableView flashScrollIndicators];
                   
               }
               
            
           }
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);
        }];
}

- (void)loadData{
    [self getProductCountOfCategory];

}

- (void)clearThumbnails{
    for (UIImageView *v in _pops){
        v.image = nil;
    }
    for (UIImageView *v in _news){
        v.image = nil;
    }
    for (UIImageView *v in _bests){
        v.image = nil;
    }
}

- (void)setContentThumbnailsForData:(NSDictionary*)data{
    
    NSArray *pop = [data objectForKey:@"populars"];
    NSArray *new = [data objectForKey:@"new_arrivals"];
    NSArray *best = [data objectForKey:@"best_sellers"];
    
    int i = 0;
    for (NSDictionary *p in pop){
        
        if (i > _pops.count)
            return;
        
        NSString *thumbUrl = [p objectForKey:@"thumb"];
        UIImageView *c = [_pops objectAtIndex:i];
        [c setImageWithURL:[NSURL URLWithString:thumbUrl]];
        
        i++;
    }
    
    i = 0;
    for (NSDictionary *p in new){
        
        if (i > _news.count)
            return;
        
        NSString *thumbUrl = [p objectForKey:@"thumb"];
        UIImageView *c = [_news objectAtIndex:i];
        [c setImageWithURL:[NSURL URLWithString:thumbUrl]];
        
        i++;
    }
    
    i = 0;
    for (NSDictionary *p in best){
        
        if (i > _bests.count)
            return;
        
        NSString *thumbUrl = [p objectForKey:@"thumb"];
        UIImageView *c = [_bests objectAtIndex:i];
        [c setImageWithURL:[NSURL URLWithString:thumbUrl]];
        
        i++;
    }
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = nil;
    [self setLeftButtonType:LeftButtonTypeDevice];
    
    [[[self.view subviews] objectAtIndex:0] setContentSize:CGSizeMake(320, 465)];
    
    _pops = @[pop1,pop2,pop3,pop4];
    _news = @[new1,new2];//,new3,new4,new5,new6
    _bests = @[best1,best2,best3,best4];
    
    _listData = [[NSMutableArray alloc] init];
    
    if (!_tileController){
        _tileController = [[ProductTileController alloc] init];
        _tileController.parentController = self;
    }
    
    if (!_listController){
        _listController = [[ProductListController alloc] init];
        _listController.parentController = self;
    }
    
    
    [self getProductCountOfCategory];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewShouldRefresh{
    [self loadData];
}

@end
