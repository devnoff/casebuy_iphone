//
//  ShopViewController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 24..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductTileController.h"
#import "ProductListController.h"
#import "ProductCategoryController.h"

typedef enum {
    ShopDispTypeCategoryTile,
    ShopDispTypeCategoryProductsList,
    ShopDispTypeSubCAtegoryProductsList
} ShopDispType;

typedef enum {
    LeftBtnTypeBack,
    LeftBtnTypeDevice
} LeftBtnType;

typedef enum {
    ShopTypeCategory,
    ShopTypeTile,
    ShopTypeList
} ShopType;

@protocol ShopViewControllerDelegate;
@interface ShopViewController : BaseViewController<UIScrollViewDelegate>{
    
    IBOutlet UITableView *_tableView;
    IBOutlet UIActivityIndicatorView *_activity;
    UIView *footerView;
    
    NSMutableArray *_listData;
    
    ProductTileController *_tileController;
    ProductListController *_listController;
    ProductCategoryController *_categoryController;
    
    UIRefreshControl *refreshControl;
    
    BOOL loadingData;
    BOOL bottomIndicatorShowing;
    
    
    CGPoint _lastPos;
    
    NSString *sortBy;
}

@property (nonatomic, getter = tableView) UITableView *tableView;
@property (nonatomic) LeftBtnType leftType;
@property (nonatomic) ShopDispType dispType;
@property (nonatomic) ShopType shopType;
@property (nonatomic) NSInteger categoryId;

- (id)initForList;
- (id)initForCategory;

- (void)loadData;
- (void)clearData;
- (void)locateNavigationButtons;

@end


@protocol ShopViewControllerDelegate <NSObject>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end