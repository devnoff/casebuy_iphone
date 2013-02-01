//
//  ProductListController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 26..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProductListController.h"
#import "ProductListCell.h"
#import "ProductDetailController.h"
#import "DeviceSelectController.h"
#import "CSImageCache.h"
#import "CurrencyHelper.h"
#import "AppDelegate.h"
#import "ShopViewController.h"

@interface ProductListController ()

@end

@implementation ProductListController
@synthesize listData=_listData,parentController,canEdit,delegate;


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _listData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([[AppDelegate sharedAppdelegate] isIphone5]){
//        return 454;
//    }
//    return 366;
    return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
    static NSString *identifier = @"MyCell";
	ProductListCell *cell = (ProductListCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"ProductListCell" owner:nil options:nil];
		cell = [arr objectAtIndex:0];
	}
    
    NSDictionary *item = [_listData objectAtIndex:indexPath.row];
    
    
    [cell setTitle:[item objectForKey:@"title"]
             price:[CurrencyHelper formattedString:[NSNumber numberWithFloat:[[item objectForKey:@"sales_price"] floatValue]] withIdentifier:IDENTIFIED_LOCALE]
             photo:nil];
    

    [cell.photoView setImageWithURL:[NSURL URLWithString:[item objectForKey:@"image"]]];    
    
    return cell;
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ShopViewController *parent = (ShopViewController*)parentController;
//    [parent.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    // 애니메이션 후 로드
    [self performSelector:@selector(openDetailViewWithIndex:) withObject:[NSNumber numberWithInteger:indexPath.row] afterDelay:.0];
}

- (void)openDetailViewWithIndex:(NSNumber*)index{
    ShopViewController *parent = (ShopViewController*)parentController;
    
    ProductDetailController *detail = [[ProductDetailController alloc] initWithNibName:@"ProductDetailController" bundle:nil];
    detail.productId = [[[_listData objectAtIndex:index.integerValue] objectForKey:@"id"] integerValue];
    detail.hidesBottomBarWhenPushed = YES;

    [parent.navigationController pushViewController:detail animated:YES];
//    detail.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [parent presentViewController:detail
//                         animated:YES
//                       completion:^{
//                           
//                       }];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return canEdit;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (delegate && [delegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]){
        [delegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (parentController && [parentController respondsToSelector:@selector(scrollViewDidScroll:)]){
        [parentController performSelector:@selector(scrollViewDidScroll:) withObject:scrollView];
    }
}




@end
