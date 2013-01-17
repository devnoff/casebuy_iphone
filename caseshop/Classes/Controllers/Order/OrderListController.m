//
//  OrderListController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 9..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "OrderListController.h"
#import "MoreCell.h"
#import "API.h"
#import "AppDelegate.h"
#import "OrderDetailController.h"

@interface OrderListController ()

@end

@implementation OrderListController

- (void)dealloc{
    _tableView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewShouldRefresh{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"YOUR ORDERS", nil);
    
    
    _listData = [[NSMutableArray alloc] init];
    
    Class refresh = NSClassFromString(@"UIRefreshControl");
    
    if (refresh){
        refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
        [_tableView addSubview:refreshControl];
    }
    
    [self loadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - Data

- (void)loadData{
    API *apiRequest = [[API alloc] init];
    
    NSString *uuid = [[AppDelegate sharedAppdelegate] uuid];
    
    [apiRequest get:[NSString stringWithFormat:@"s/orderList?uuid=%@",uuid]
       successBlock:^(NSDictionary *result){
           NSLog(@"result: %@", result);
           
           int resultCode = [[result objectForKey:@"code"] intValue];
           if (resultCode == kAPI_RESULT_OK){
               
               NSArray *list = [result objectForKey:@"result"];
               
               [_listData removeAllObjects];
               [_listData addObjectsFromArray:list];
               
               [_tableView reloadData];
               
               [refreshControl endRefreshing];
               
               if (_listData.count < 1){
                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CASEBUY"
                                                                    message:NSLocalizedString(@"No record of order founded :)", nil)
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"OKAY",nil)
                                                          otherButtonTitles:nil];
                   
                   [alert show];
                   return;
               }
               
           }
     
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);
        }];

}

- (void)refresh{
    [self loadData];
}


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MyCell";
	MoreCell *cell = (MoreCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[MoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
		
	}
    
    NSDictionary *order = [_listData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [order objectForKey:@"date_order"];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:.5];
    
    NSDictionary *order = [_listData objectAtIndex:indexPath.row];
    
    OrderDetailController *detail = [[OrderDetailController alloc] initWithNibName:@"OrderDetailController" bundle:nil];
    detail.orderCode = [order objectForKey:@"order_code"];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
