//
//  ProductCategoryController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 26..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <SDWebImage/UIButton+WebCache.h>
#import "ProductCategoryController.h"
#import "AppDelegate.h"
#import "CategoryCell.h"
#import "DeviceSelectController.h"
#import "ProductListController.h"
#import "CSImageCache.h"
#import "ShopViewController.h"

@interface ProductCategoryController ()

@end

@implementation ProductCategoryController
@synthesize listData=_listData;




#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ceil(_listData.count / 2.0) ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[AppDelegate sharedAppdelegate] isIphone5])
        return 160;
    
    return 135;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"MyCell";
	CategoryCell *cell = (CategoryCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"CategoryCell" owner:nil options:nil];
		cell = [arr objectAtIndex:0];
        cell.leftButton.delegate = self;
        cell.rightButton.delegate = self;
	}
    
    NSInteger idxLeft = (indexPath.row * 2.0);
    NSInteger idxRight = idxLeft + 1;
    NSInteger maxIdx = _listData.count - 1;
    
    
    
    NSDictionary *left = [_listData objectAtIndex:idxLeft];
    [cell.leftButton setTitle:[left objectForKey:@"title"] forState:UIControlStateNormal];
    
    [cell.leftButton setImageWithURL:[NSURL URLWithString:[left objectForKey:@"image"]] forState:UIControlStateNormal];
    cell.leftButton.categoryId = [[left objectForKey:@"categories_id"] integerValue];
    cell.leftButton.tag = idxLeft;
    [cell showLeft];
    
    if (idxRight <= maxIdx){
        NSDictionary *right = [_listData objectAtIndex:idxRight];
        [cell.rightButton setTitle:[right objectForKey:@"title"] forState:UIControlStateNormal];
        [cell.rightButton setImageWithURL:[NSURL URLWithString:[right objectForKey:@"image"]] forState:UIControlStateNormal];
        cell.rightButton.categoryId = [[right objectForKey:@"categories_id"] integerValue];
        cell.rightButton.tag = idxRight;
        [cell showRight];
    }
    
    
    return cell;
}



#pragma mark - CategoryTileBtnDelegate

- (void)categoryTileBtnDidSelected:(CategoryTileButton *)button{
    ShopViewController *list = [[ShopViewController alloc] initWithNibName:@"ShopViewController" bundle:nil];
    list.categoryId = button.categoryId;
    list.dispType = ShopDispTypeSubCAtegoryProductsList;
    NSString *title = [[_listData objectAtIndex:button.tag] objectForKey:@"title"];
    list.title = title;
    [self.parentController.navigationController pushViewController:list animated:YES];
    
}

@end
