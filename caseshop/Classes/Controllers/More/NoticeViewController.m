//
//  NoticeViewController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 29..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "NoticeViewController.h"
#import "API.h"
#import "MoreCell.h"
#import "NoticeDetailController.h"


@interface NoticeViewController ()

@end

@implementation NoticeViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"NOTICE";
    _listData = [[NSMutableArray alloc] init];
    
    
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


#pragma mark - Data

- (void)loadData{
    API *apiRequest = [[API alloc] init];
    
    
    [apiRequest get:@"s/noticeList"
       successBlock:^(NSDictionary *result){
           NSLog(@"result: %@", result);
           
           int resultCode = [[result objectForKey:@"code"] intValue];
           if (resultCode == kAPI_RESULT_OK){
               
               NSArray *list = [result objectForKey:@"result"];
               
               [_listData removeAllObjects];
               [_listData addObjectsFromArray:list];
               
               [_tableView reloadData];
               
           }
           
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);
        }];
    
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
    
    cell.textLabel.text = [order objectForKey:@"title"];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:.5];
    
    NSDictionary *notice = [_listData objectAtIndex:indexPath.row];

    NoticeDetailController *detail = [[NoticeDetailController alloc] initWithNibName:@"NoticeDetailController" bundle:nil];
    detail.itemId = [[notice objectForKey:@"id"] integerValue];
    detail.title = [notice objectForKey:@"title"];
    [self.navigationController pushViewController:detail animated:YES];
}


@end
