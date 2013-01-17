//
//  WallpaperController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 24..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//
#import <SDWebImage/UIButton+WebCache.h>
#import "WallpaperController.h"
#import "API.h"
#import "WallpaperCell.h"
#import "CSImageCache.h"
#import "WallpaperDetailController.h"
#import "ToastController.h"


@interface WallpaperController ()

@end

@implementation WallpaperController
@synthesize relatedCaseId;

- (void)dealloc{
    _tableView = nil;
    _activity = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)forProductRelation{
    return self.relatedCaseId!=PRODUCT_ID_INVALID;
}

#pragma mark - Footer Loading

- (void)animateShowFooter{

    _tableView.tableFooterView = footerView;
    
    CGRect frame = footerView.frame;
    frame.size.height = 44;

    [UIView animateWithDuration:.3
                     animations:^{
                         _activity.alpha = 1.0f;
//                         _tableView.tableFooterView.frame = frame;
                         [_tableView setContentInset:UIEdgeInsetsMake(15, 0, 0, 0)];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)animateHideFooter{
    
    
    CGRect frame = footerView.frame;
    frame.size.height = 0;
    
    [UIView animateWithDuration:.3
                     animations:^{
                         _activity.alpha = .0f;
//                         _tableView.tableFooterView.frame = frame;
                         [_tableView setContentInset:UIEdgeInsetsMake(15, 0, -44, 0)];
                     }
                     completion:^(BOOL finished) {
//                         _tableView.tableFooterView = nil;
                     }];
}

#pragma mark - Data

- (void)loadData{
    
    if (loadingData){
        return;
    }
    if (_listData.count > 0)
        [self animateShowFooter];
    
    
    loadingData = YES;
    
    API *apiRequest = [[API alloc] init];
    
    NSString *productParam = self.relatedCaseId!=PRODUCT_ID_INVALID?[NSString stringWithFormat:@"&products_id=%d",self.relatedCaseId]:@"";
    
    [apiRequest get:[NSString stringWithFormat:@"s/wallpapers?offset=%d%@",_listData.count,productParam]
       successBlock:^(NSDictionary *result){
           NSLog(@"result: %@", result);
           
//           _activity.hidden = YES;
           
           int resultCode = [[result objectForKey:@"code"] intValue];
           if (resultCode == kAPI_RESULT_OK){
               
               BOOL flashScroll = _listData.count > 0;
               
               // 상품 목록
               NSArray *items = [result objectForKey:@"result"];
               
               [_tableView reloadData];
               
               [_listData addObjectsFromArray:items];
               
               [UIView animateWithDuration:.3
                                animations:^{
                                    _tableView.alpha = 1.0f;
                                }
                                completion:^(BOOL finished){
                                    [_tableView reloadData];
                                    [refreshControl endRefreshing];
                                    if (flashScroll){
                                        [_tableView flashScrollIndicators];
                                        
                                    }
                                    int count = [[result objectForKey:@"result"] count];
                                    
                                    if (count >= 24){
                                        //                                            [ToastController showMiniToast:[NSString stringWithFormat:@"%d %@",count,NSLocalizedString(@"more items below", nil)]];
                                        [self animateShowFooter];
                                    } else {
                                        
                                        [self animateHideFooter];
                                    }
                                    
                                    loadingData = NO;
                                }];
               
           }
           
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);
            loadingData = NO;
        }];
}


#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (![self forProductRelation]){
        self.navigationItem.leftBarButtonItem = nil;
    } else {
        self.title = NSLocalizedString(@"RELATED WALLPAPERS", nil);
    }
    
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [footerView setClipsToBounds:YES];
    [_activity removeFromSuperview];
    _activity.center = CGPointMake(footerView.center.x, 15);
    _activity.alpha = .0f;
    [footerView addSubview:_activity];
    [self animateShowFooter];
    
    Class refresh = NSClassFromString(@"UIRefreshControl");
    
    if (refresh){
        refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
        [_tableView addSubview:refreshControl];
    }
    
    [_tableView setContentInset:UIEdgeInsetsMake(15, 0, 0, 0)];
    
    _listData = [[NSMutableArray alloc] init];
    
    [self loadData];

    
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


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return ceil(_listData.count / 2.0) ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"MyCell";
	WallpaperCell *cell = (WallpaperCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[WallpaperCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.leftBtn addTarget:self action:@selector(wallpaperButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightBtn addTarget:self action:@selector(wallpaperButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	}

    NSInteger idxLeft = (indexPath.row * 2.0);
    NSInteger idxRight = idxLeft + 1;
    NSInteger maxIdx = _listData.count - 1;
    
    if (idxLeft > maxIdx){
        return cell;
    }
    
    NSDictionary *left = [_listData objectAtIndex:idxLeft];
    NSString *leftPath = [NSString stringWithFormat:@"%@%@",[left objectForKey:@"resource_dir_path"],[left objectForKey:@"filename"]];
    
    [cell.leftBtn setImageWithURL:[NSURL URLWithString:leftPath] forState:UIControlStateNormal];
    
    cell.leftBtn.itemId = [[left objectForKey:@"id"] integerValue];
    
    if (idxRight <= maxIdx){
        NSDictionary *right = [_listData objectAtIndex:idxRight];
        NSString *rightPath = [NSString stringWithFormat:@"%@%@",[right objectForKey:@"resource_dir_path"],[right objectForKey:@"filename"]];
        [cell.rightBtn setImageWithURL:[NSURL URLWithString:rightPath] forState:UIControlStateNormal];
        cell.rightBtn.itemId = [[right objectForKey:@"id"] integerValue];
        
    } 
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 127.0f;
}


#pragma mark - Wallpaper Button

- (void)wallpaperButtonTapped:(WallpaperButton*)button{
    NSLog(@"item id: %d",button.itemId);
    
    if (button.itemId == PRODUCT_ID_INVALID){
        return;
    }
    
    WallpaperDetailController *wall = [[WallpaperDetailController alloc] initWithNibName:@"WallpaperDetailController" bundle:nil];
    wall.itemId = button.itemId;
    wall.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wall animated:YES];
    
    
    
}

#pragma mark - Refresh


- (void)refresh{
    [_listData removeAllObjects];
    [self loadData];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint pos = scrollView.contentOffset;
    CGSize size = scrollView.contentSize;
    
    CGFloat posY = pos.y + scrollView.frame.size.height;
    
    if (posY == size.height){
        NSLog(@"Last row");
        if (!loadingData)
            [self loadData];
    }
    
}


@end
