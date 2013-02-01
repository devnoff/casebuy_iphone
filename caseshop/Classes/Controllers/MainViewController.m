//
//  MainViewController.m
//  scomdcom
//
//  Created by Yongnam Park on 12. 9. 5..
//  Copyright (c) 2012년 Yongnam Park. All rights reserved.
//

#import "MainViewController.h"
#import "CartViewController.h"
#import "WallpaperController.h"
#import "MoreViewController.h"
#import "ProductCategoryController.h"
#import "ProductListController.h"

#import "API.h"
#import "AppDelegate.h"

@interface UIViewController(Bg)
@end
@implementation UIViewController(Bg)



@end


@interface MainViewController ()

@end

@implementation MainViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _shopController = nil;
}

- (void)loadView{
    [super loadView];
    
    
    _controllers = [[NSMutableArray alloc] init];
    
//    ShopViewController *shop = [[ShopViewController alloc] initWithNibName:@"ShopViewController" bundle:nil];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSInteger currCategory = [def integerForKey:kCURRENT_CATEGORY_ID];
    
    
    ShopMainController *shop = [[ShopMainController alloc] initWithNibName:@"ShopMainController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:shop];
    
    _shopController = shop;
    _shopController.categoryId = currCategory;
    
    UITabBarItem *tab1 = [[UITabBarItem alloc] init];
    [tab1 setFinishedSelectedImage:[UIImage imageNamed:@"Tab1_Selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"Tab1"]];
    [nav setTabBarItem:tab1];
    [shop setTitle:@"PRODUCT"];
    [tab1 setTitle:@""];
    [tab1 setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    
    [_controllers addObject:nav];
    
    CartViewController *cart = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];;
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:cart];

    
    UITabBarItem *tab2 = [[UITabBarItem alloc] init];
    [tab2 setFinishedSelectedImage:[UIImage imageNamed:@"Tab2_Selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"Tab2"]];
    [nav1 setTabBarItem:tab2];
    [cart setTitle:@"CART"];
    [tab2 setTitle:@""];
    [tab2 setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    
    [_controllers addObject:nav1];
    
    WallpaperController *wall = [[WallpaperController alloc] initWithNibName:@"WallpaperController" bundle:nil];;
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:wall];

    
    UITabBarItem *tab3 = [[UITabBarItem alloc] init];
    [tab3 setFinishedSelectedImage:[UIImage imageNamed:@"Tab3_Selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"Tab3"]];
    [nav2 setTabBarItem:tab3];
    [wall setTitle:@"WALLPAPER"];
    [tab3 setTitle:@""];
    [tab3 setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    
    
    [_controllers addObject:nav2];
    
    MoreViewController *my = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];;
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:my];
    
    UITabBarItem *tab4 = [[UITabBarItem alloc] init];
    [tab4 setFinishedSelectedImage:[UIImage imageNamed:@"Tab4_Selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"Tab4"]];
    [nav3 setTabBarItem:tab4];
    [my setTitle:@"MORE"];
    [tab4 setTitle:@""];
    [tab4 setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    
    [_controllers addObject:nav3];
    
    
    [self setViewControllers: @[nav,nav1,nav2,nav3]];

   
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"TabBarBg"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"selection-tab.png"]];
    
    if ([self.tabBar respondsToSelector:@selector(setShadowImage:)]){
        self.tabBar.shadowImage = [[UIImage alloc] init];
    }
    self.tabBar.backgroundImage = [[UIImage alloc] init];
    
    
    // 카트 뱃지
    UIFont *font = [UIFont boldSystemFontOfSize:8];
    UIImage *bg = [[UIImage imageNamed:@"CartCount"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *bgOn = [[UIImage imageNamed:@"CartCount_Selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];

    _badge = [[UIButton alloc] initWithFrame:CGRectMake(120, 8, bg.size.width, bg.size.height)];
    _badge.titleLabel.font = font;
    _badge.titleEdgeInsets = UIEdgeInsetsMake(0.6, 0, 0, 0);
    [_badge setBackgroundImage:bg forState:UIControlStateNormal];
    [_badge setBackgroundImage:bgOn forState:UIControlStateSelected];
    [_badge setTitle:@"0" forState:UIControlStateNormal];
    _badge.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_badge setTitleColor:[UIColor colorWithWhite:0.447 alpha:1.000] forState:UIControlStateNormal];
    [_badge setTitleColor:[UIColor colorWithRed:0.431 green:0.792 blue:0.992 alpha:1.000] forState:UIControlStateSelected];
    _badge.userInteractionEnabled = NO;

    [self.tabBar addSubview:_badge];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCartCount:) name:kCART_COUNT_UPDATE_NOTIFICATION object:nil];
    
    [self updateCartCount:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showCart{
    [self setSelectedIndex:1];
}

- (void)updateCartCount:(NSNotification *)notif{
    
    NSNumber *count = notif.object;
    
    if (count){
        _badge.hidden = count.integerValue < 1;
        
        if (count.integerValue < 10)
            _badge.titleEdgeInsets = UIEdgeInsetsMake(0.6, 1.4, 0, 0);
        else
            _badge.titleEdgeInsets = UIEdgeInsetsMake(0.6, 0, 0, 0);
        
        NSString *str = count.stringValue;
        CGSize size = [str sizeWithFont:_badge.titleLabel.font];
        size.width = size.width + 6;
        
        CGRect rect = _badge.frame;
        rect.size.width = size.width;
        _badge.frame = rect;
        
        [_badge setTitle:str forState:UIControlStateNormal];
        
    } else {
        
        NSString *uuid = [[AppDelegate sharedAppdelegate] uuid];
        API *apiRequest = [[API alloc] init];
        
        [apiRequest get:[NSString stringWithFormat:@"s/cartCount?uuid=%@",uuid]
           successBlock:^(NSDictionary *result){
               NSLog(@"result: %@", result);
               int resultCode = [[result objectForKey:@"code"] intValue];
               if (resultCode == kAPI_RESULT_OK){
                   NSNumber *count = [result objectForKey:@"result"];
                   
                   _badge.hidden = count.integerValue < 1;
                   
                   if (count.integerValue < 10)
                       _badge.titleEdgeInsets = UIEdgeInsetsMake(0.6, 1.4, 0, 0);
                   else
                       _badge.titleEdgeInsets = UIEdgeInsetsMake(0.6, 0, 0, 0);
                   
                   NSString *str = count.stringValue;
                   CGSize size = [str sizeWithFont:_badge.titleLabel.font];
                   size.width = size.width + 6;
                   
                   CGRect rect = _badge.frame;
                   rect.size.width = size.width;
                   _badge.frame = rect;
                   
                   [_badge setTitle:str forState:UIControlStateNormal];
               }
           }
            failureBock:^(NSError *error){
                NSLog(@"error: %@", error);
                
            }];
    }
    
    
    
    
    
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
        
    _badge.selected = selectedIndex == 1;
    
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController{
    [super setSelectedViewController:selectedViewController];
    
    // 카트 일 경우
    _badge.selected = [[_controllers objectAtIndex:1] isEqual:selectedViewController];
    
}



- (void)setShopType:(ShopType)type withCategoryId:(NSInteger)categoryId title:(NSString*)title{
    
    
    _shopController.title = title;
    _shopController.navigationController.tabBarItem.title = @"";
    _shopController.categoryId = categoryId;
    [_shopController performSelector:@selector(loadData)];
    
    return;
    
//    [_shopController clearData];
//    if (type==ShopTypeCategory){
//        _shopController.shopType = ShopTypeTile;
//        _shopController.dispType = ShopDispTypeCategoryTile;
//    } else {
//        _shopController.shopType = ShopTypeList;
//        _shopController.dispType = ShopDispTypeCategoryProductsList;
//    }
//    [_shopController locateNavigationButtons];
//    
//    if (_shopController.parentViewController)
//        [_shopController loadData];
}

@end
