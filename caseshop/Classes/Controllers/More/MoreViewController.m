//
//  MoreViewController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 24..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreCell.h"
#import "OrderListController.h"
#import "NoticeViewController.h"
#import "CSWebViewController.h"
#import "ProductLikedController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

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

    self.navigationItem.leftBarButtonItem = nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MyCell";
	MoreCell *cell = (MoreCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[MoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
		
	}
    
    
    if (indexPath.row == 0){
        cell.textLabel.text = NSLocalizedString(@"YOUR ORDERS", nil);
    }
    
    else if (indexPath.row == 1){
        cell.textLabel.text = NSLocalizedString(@"NOTICE", nil);
    }
    
    else if (indexPath.row == 2){
        cell.textLabel.text = NSLocalizedString(@"LEGAL", nil);
    }
    
    else if (indexPath.row == 3){
        cell.textLabel.text = NSLocalizedString(@"CONTACT", nil);
    }
    
    else if (indexPath.row == 4){
        cell.textLabel.text = NSLocalizedString(@"COMPANY", nil);
    }
    
    else if (indexPath.row == 5){
        cell.textLabel.text = NSLocalizedString(@"LIKED PRODUCTS", nil);
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0){
        OrderListController *orderList = [[OrderListController alloc] initWithNibName:@"OrderListController" bundle:nil];
        [self.navigationController pushViewController:orderList animated:YES];
    }
    
    else if (indexPath.row == 1){
        NoticeViewController *notice = [[NoticeViewController alloc] initWithNibName:@"NoticeViewController" bundle:nil];
        [self.navigationController pushViewController:notice animated:YES];
    }
    
    else if (indexPath.row == 2){
        CSWebViewController *legal = [[CSWebViewController alloc] initWithNibName:@"CSWebViewController" bundle:nil];
        legal.title = NSLocalizedString(@"LEGAL", nil);
        legal.startUrl = [NSString stringWithFormat:@"%@%@",APIURL,@"s/mobile/legalView"];
        [self.navigationController pushViewController:legal animated:YES];
    }
    
    else if (indexPath.row == 3){
        
        [MailController mailWithTitle:NSLocalizedString(@"[CASEBUY.ME]CONTACT FOR ASKING", nil)
                            recipient:@"casebuy@cultstory.com"
                                 memo:NSLocalizedString(@"Sent from CASEBUY iPhone App", nil)
                               target:self];
    }
    
    else if (indexPath.row == 4){
        CSWebViewController *legal = [[CSWebViewController alloc] initWithNibName:@"CSWebViewController" bundle:nil];
        legal.title = NSLocalizedString(@"COMPANY", nil);
        legal.startUrl = @"http://m.cultstory.com/about";
        legal.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:legal animated:YES];
    }
    
    else if (indexPath.row == 5){
        ProductLikedController *liked = [[ProductLikedController alloc] initWithNibName:@"MoreViewController" bundle:nil];
        liked.title = NSLocalizedString(@"LIKED PRODUCTS", nil);
        liked.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:liked animated:YES];
    }
    
    [tableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:.5];
    
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissModalViewControllerAnimated:YES];
    
    if (error){
        NSLog(@"error: %@", error);
    }
    
}

@end
