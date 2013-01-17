//
//  ProductTileController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 29..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//
#import <SDWebImage/UIButton+WebCache.h>
#import "ProductTileController.h"
#import "CSImageCache.h"
#import "ProductDetailController.h"

@implementation ProductTileController
@synthesize listData=_listData,parentController;


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ceil(_listData.count / 2.0) ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"MyCell";
	ProductTileCell *cell = (ProductTileCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"ProductTileCell" owner:nil options:nil];
		cell = [arr objectAtIndex:0];
        [cell.leftButton addTarget:self action:@selector(productTileButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightButton addTarget:self action:@selector(productTileButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

	}
    
    NSInteger idxLeft = (indexPath.row * 2.0);
    NSInteger idxRight = idxLeft + 1;
    NSInteger maxIdx = _listData.count - 1;
    
    NSDictionary *left = [_listData objectAtIndex:idxLeft];
    
    
    
    [cell.leftButton setImageWithURL:[NSURL URLWithString:[left objectForKey:@"thumb"]] forState:UIControlStateNormal];

    
    // 상품번호
    cell.leftButton.tag = [[left objectForKey:@"id"] integerValue];
    
    if (idxRight <= maxIdx){
        NSDictionary *right = [_listData objectAtIndex:idxRight];
        [cell.rightButton setImageWithURL:[NSURL URLWithString:[right objectForKey:@"thumb"]] forState:UIControlStateNormal];
        
        cell.rightButton.tag = [[right objectForKey:@"id"] integerValue];

    }
    


    
    return cell;
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - ProducTileButtonDelegate

- (void)productTileButtonTapped:(ProductTileButton *)button{
    ProductDetailController *detail = [[ProductDetailController alloc] initWithNibName:@"ProductDetailController" bundle:nil];
    detail.productId = button.tag;
    
    detail.hidesBottomBarWhenPushed = YES;
    
    if (self.parentController)
        [self.parentController.navigationController pushViewController:detail animated:YES];
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (parentController && [parentController respondsToSelector:@selector(scrollViewDidScroll:)]){
        [parentController performSelector:@selector(scrollViewDidScroll:) withObject:scrollView];
    }
}

@end
