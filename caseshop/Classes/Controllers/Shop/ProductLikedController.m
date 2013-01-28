//
//  ProductLikedController.m
//  caseshop
//
//  Created by Yongnam Park on 13. 1. 28..
//  Copyright (c) 2013년 CultStory Inc. All rights reserved.
//

#import "ProductLikedController.h"

@implementation ProductLikedController

- (void)viewDidLoad{
    
    self.navigationItem.hidesBackButton = YES;
    [self setLeftBackButton];

    _productList = [[ProductListController alloc] init];
    _productList.parentController = self;
    _productList.canEdit = YES;
    _productList.delegate = self;
    _tableView.delegate = _productList;
    _tableView.dataSource = _productList;
    
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSMutableArray *items = [NSMutableArray arrayWithArray:[def arrayForKey:kLIKED_ITEMS]];
    _productList.listData = items;
    
    [_tableView reloadData];
    
    
    [self setRightButtonType:RightButtonTypeEdit];
    
}

- (void)edit{
    
    [self setRightCustomButtonWithTitle:NSLocalizedString(@"DONE", nil) target:self selector:@selector(done)];
    
    if (!_tableView.editing){
        [_tableView setEditing:YES animated:YES];
    }
}

- (void)done{
    [self setRightButtonType:RightButtonTypeEdit];
    
    if (_tableView.editing){
        [_tableView setEditing:NO animated:YES];
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [_productList.listData removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:_productList.listData forKey:kLIKED_ITEMS];
        [def synchronize];
        
        [tableView endEditing:YES];
        
    }
}


@end
