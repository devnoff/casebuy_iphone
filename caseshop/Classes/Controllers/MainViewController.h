//
//  MainViewController.h
//  scomdcom
//
//  Created by Yongnam Park on 12. 9. 5..
//  Copyright (c) 2012년 Yongnam Park. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopMainController.h"
#import "ShopViewController.h"


@interface MainViewController : UITabBarController{
    NSMutableArray *_controllers;
    ShopMainController *_shopController;
    
    UIButton *_badge;
}

- (void)updateCartCount:(NSNotification *)notif;
- (void)showCart;
- (void)setShopType:(ShopType)type withCategoryId:(NSInteger)categoryId title:(NSString*)title;

@end
