//
//  ShopViewController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 24..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "ShopViewController.h"
#import "DeviceSelectController.h"
#import "API.h"
#import "AppDelegate.h"
#import "Flurry.h"
#import "ToastController.h"

@interface ShopViewController ()

@end

@implementation ShopViewController
@synthesize leftType,dispType,categoryId,shopType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        shopType = ShopTypeList;
    }
    return self;
}

- (id)initForList{
    
    
    return [self initWithNibName:@"ShopViewController" bundle:nil];
}

- (id)initForCategory{
    
    
    return [self initWithNibName:@"ShopViewController" bundle:nil];
}

- (void)dealloc{
    _tableView = nil;
    _activity = nil;
    footerView = nil;
}

- (UITableView*)tableView{
    return _tableView;
}

#pragma mark - Animations

- (void)fadeInTableView{
    _activity.hidden = YES;
    
    [UIView animateWithDuration:.3
                     animations:^{
                         _tableView.alpha = 1.0f;
                     }];
}


#pragma mark - Footer Loading

- (void)animateShowFooter{
    
    
    bottomIndicatorShowing = YES;
    
    _tableView.tableFooterView = footerView;
    
    CGRect frame = footerView.frame;
    frame.size.height = 44;
    
    _activity.hidden = NO;
    [UIView animateWithDuration:.3
                     animations:^{
                         _activity.alpha = 1.0f;
                         [_activity startAnimating];
                         [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];


                         
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)animateHideFooter{
    
    
    bottomIndicatorShowing = NO;
    
    
    CGRect frame = footerView.frame;
    frame.size.height = 0;
    
    [UIView animateWithDuration:.3
                     animations:^{
                         _activity.alpha = .0f;
                         
                         if (_tableView.contentInset.bottom == 0)
                             [_tableView setContentInset:UIEdgeInsetsMake(0, 0, -44, 0)];
                     }
                     completion:^(BOOL finished) {

                     }];
}

#pragma mark - Actions

- (void)device{
    DeviceSelectController *device = [[DeviceSelectController alloc] initWithNibName:@"DeviceSelectController" bundle:nil];
    device.currDeviceIdx = 1;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:device];
    [self presentModalViewController:nav animated:YES];
}

- (void)list{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.shopType = ShopTypeList;
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

    self.shopType = ShopTypeTile;
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
    
    
    /*
     * Flurry Analytics
     */
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     self.title, @"Title", // Capture author info
     nil];
    
    [Flurry logEvent:@"Product_List_Viewed" withParameters:params];
}

- (void)dataForTile{
    _tableView.delegate = _tileController;
    _tableView.dataSource = _tileController;
    _tileController.listData = _listData;
    
    /*
     * Flurry Analytics
     */
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     self.title, @"Title", // Capture author info
     nil];
    
    [Flurry logEvent:@"Product_Tile_Viewed" withParameters:params];
}

- (void)dataForCategory{
    _tableView.delegate = _categoryController;
    _tableView.dataSource = _categoryController;
    _categoryController.listData = _listData;
    
    /*
     * Flurry Analytics
     */
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     self.title, @"Title", // Capture author info
     nil];
    
    [Flurry logEvent:@"Product_Category_Viewed" withParameters:params];
}


#pragma mark - Button Actions




#pragma mark - Data

- (void)clearData{
    [_listData removeAllObjects];
    [_tableView reloadData];
//    shopType = ShopTypeList;
//    dispType = ShopDispTypeCategoryProductsList;
}

- (void)refresh{
    _activity.alpha = .0f;
    [self clearData];
    [self loadData];

}

- (void)loadSubCategoryProducts{
    
    if (loadingData){
        return;
    }
    
    if (!refreshControl.refreshing)
        [self animateShowFooter];
    
    
    loadingData = YES;
    
    API *apiRequest = [[API alloc] init];
    
    [apiRequest get:[NSString stringWithFormat:@"s/products?categories_id=%d&offset=%d",categoryId,_listData.count]
       successBlock:^(NSDictionary *result){
           NSLog(@"loadSubCategoryProducts: %@", result);
           
           int resultCode = [[result objectForKey:@"code"] intValue];
           if (resultCode == kAPI_RESULT_OK){
               
               BOOL flashScroll = _listData.count > 0;
               
               [_listData addObjectsFromArray:[result objectForKey:@"result"]];
               [_tableView reloadData];
               [refreshControl endRefreshing];
               
               [self performSelectorOnMainThread:@selector(fadeInTableView) withObject:nil waitUntilDone:NO];
               
               if (flashScroll){
                   [_tableView flashScrollIndicators];
                   
//                   int count = [[result objectForKey:@"result"] count];
                   
                   [self animateHideFooter];
               }
               
               loadingData = NO;
           }
           
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);
            loadingData = NO;
        }];

}

- (void)loadCategoryProducts{
    
    if (loadingData){
        return;
    }
    
    if (!refreshControl.refreshing)
        [self animateShowFooter];
    
    loadingData = YES;
    
    API *apiRequest = [[API alloc] init];
    
    [apiRequest get:[NSString stringWithFormat:@"s/categoryProducts?categories_id=%d&offset=%d",categoryId,_listData.count]
       successBlock:^(NSDictionary *result){
           NSLog(@"loadCategoryProducts: %@", result);
           int resultCode = [[result objectForKey:@"code"] intValue];
           if (resultCode == kAPI_RESULT_OK){

               BOOL flashScroll = _listData.count > 0;
               
               [_listData addObjectsFromArray:[result objectForKey:@"result"]];
               [_tableView reloadData];
               [refreshControl endRefreshing];

               [self fadeInTableView];
               
               if (flashScroll){
                   [_tableView flashScrollIndicators];
                   
//                   int count = [[result objectForKey:@"result"] count];
                   
                   [self animateHideFooter];
               }
               
               loadingData = NO;
           }
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);
            loadingData = NO;
        }];
}

- (void)loadCategories{
    
    if (loadingData){
        return;
    }
    
    loadingData = YES;
    
    API *apiRequest = [[API alloc] init];
    
    [apiRequest get:[NSString stringWithFormat:@"s/categoryTags?categories_id=%d",categoryId]
       successBlock:^(NSDictionary *result){
           NSLog(@"result: %@", result);
           
           _activity.alpha = .0f;
           
           int resultCode = [[result objectForKey:@"code"] intValue];
           if (resultCode == kAPI_RESULT_OK){
               [_listData addObjectsFromArray:[[result objectForKey:@"result"] objectForKey:@"tags"]];
               [_tableView reloadData];
               
               [refreshControl endRefreshing];
               [UIView animateWithDuration:.3
                                animations:^{
                                    _tableView.alpha = 1.0f;
                                    _tableView.hidden = NO;
                                }
                                completion:^(BOOL finished){
                                    
                                }];
               
               loadingData = NO;
           }
           
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);
            loadingData = NO;
        }];

}

- (void)loadData{
    
    
    if (dispType == ShopDispTypeCategoryTile){

        [self dataForCategory];
        [self loadCategories];
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    else if (dispType == ShopDispTypeCategoryProductsList){
        if (shopType == ShopTypeList){
            [self dataForList];
        } else {
            [self dataForTile];
        }
        
        [self loadCategoryProducts];
    }
    
    else {
        if (shopType == ShopTypeList){
            [self dataForList];
        } else {
            [self dataForTile];
        }
        [self loadSubCategoryProducts];
    }


    
}

- (void)getProductCountOfCategory{
    

    
    API *apiRequest = [[API alloc] init];
    
    [apiRequest get:[NSString stringWithFormat:@"s/productCountCategory?categories_id=%d",categoryId]
       successBlock:^(NSDictionary *result){
           NSLog(@"result: %@", result);
           
           _activity.alpha = .0f;
           
           int resultCode = [[result objectForKey:@"code"] intValue];
           if (resultCode == kAPI_RESULT_OK){
               
               NSInteger count = [[result objectForKey:@"result"] integerValue];
               
               if (count < CATEGORY_MINIMUM_COUNT){
                   dispType = ShopDispTypeCategoryProductsList;
               } else {
                   dispType = ShopDispTypeCategoryTile;
               }
               
               [self locateNavigationButtons];
               [self loadData];
               
           }
           
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);
        }];

}

#pragma mark - Appearance

- (void)locateNavigationButtons{
     
    if (dispType == ShopDispTypeCategoryTile){
        [self setLeftButtonType:LeftButtonTypeDevice];
        self.navigationItem.rightBarButtonItem = nil;
        
    } else if (dispType == ShopDispTypeCategoryProductsList){
        [self setLeftButtonType:LeftButtonTypeDevice];
        [self setRightButtonType:RightButtonTypeTile];
        
    } else {
        [self setRightButtonType:RightButtonTypeTile];
    }
}

#pragma mark - View Life Cycle

- (void)viewShouldRefresh{
    [super viewShouldRefresh];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    

    [self refresh];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"ShopViewController viewDidLoad");
    
//    _tableView.decelerationRate = 0.991;
    
    if (!_listData)
        _listData = [[NSMutableArray alloc] init];
    
    if (!_tileController){
        _tileController = [[ProductTileController alloc] init];
        _tileController.parentController = self;
    }
    
    if (!_listController){
        _listController = [[ProductListController alloc] init];
        _listController.parentController = self;
    }
    
    if (!_categoryController){
        _categoryController = [[ProductCategoryController alloc] init];
        _categoryController.parentController = self;
    }
    
    
    // 하단 로딩 인디케이터
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [footerView setClipsToBounds:YES];
    [_activity removeFromSuperview];
    _activity.center = CGPointMake(footerView.center.x, footerView.center.y);
    _activity.alpha = .0f;
    [footerView addSubview:_activity];

    
    
    
    // 새로고침 
    Class refresh = NSClassFromString(@"UIRefreshControl");
    
    if (refresh){
        refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
        [_tableView addSubview:refreshControl];

    }
    

    // 데이터 로딩
    if (dispType != ShopDispTypeSubCAtegoryProductsList){
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        self.categoryId = [def integerForKey:kCURRENT_CATEGORY_ID];
        
        self.title = [def objectForKey:kCURRENT_CATEGORY_TITLE];
        self.navigationController.tabBarItem.title = @"";
        [self getProductCountOfCategory];
        
    } else {
        
        [self loadData];
    }
    
    [self locateNavigationButtons];
    
    
    
    // 타이틀 바 터치 시 스크롤 탑
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTapped)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;

    [self.navigationController.navigationBar addGestureRecognizer:tap];
    
    
    
}

- (void)titleTapped{
    if (_listData.count > 0){
        NSIndexPath *top = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"ShopViewController go memory warming");
    

    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint pos = scrollView.contentOffset;
    CGSize size = scrollView.contentSize;
    
    CGFloat posY = pos.y + scrollView.frame.size.height;
    
    if (posY == size.height){
        NSLog(@"Last row");
        if (!loadingData){
            [self animateShowFooter];
            [self loadData];
        }
    
    }
    
    

}

@end
