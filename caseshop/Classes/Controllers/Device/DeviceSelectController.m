//
//  DeviceSelectController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 26..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "DeviceSelectController.h"
#import "DeviceCell.h"
#import "AppDelegate.h"
#import "API.h"
#import "MainViewController.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@interface DeviceSelectController ()

@end

@implementation DeviceSelectController
@synthesize currDeviceIdx,leftBtnHide;

- (void)dealloc{
    _tableView = nil;
    _currDeviceName = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}



#pragma mark - Actions

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Button Actions

- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Data

- (void)loadCurrentDevice{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSInteger curIdx = [def integerForKey:kCURRENT_DEVICE];
    
    NSInteger cId = [def integerForKey:kCURRENT_CATEGORY_ID];
    
    if (cId)
        currDeviceIdx = curIdx;
    
}

- (void)setCurrentDevice:(int)currIdx{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setInteger:currIdx forKey:kCURRENT_DEVICE];
    
    NSDictionary *c = [_listData objectAtIndex:currIdx];
    NSInteger cId = [[c objectForKey:@"categories_id"] integerValue];
    [def setInteger:cId forKey:kCURRENT_CATEGORY_ID];
    [def setObject:[c objectForKey:@"title"] forKey:kCURRENT_CATEGORY_TITLE];
    
    
    [def synchronize];
    
}

- (void)loadProductCountsAtIndexPath:(NSIndexPath *)indexPath{

    DeviceCell *cell = (DeviceCell*)[_tableView cellForRowAtIndexPath:indexPath];
    cell.checkImg.hidden = YES;
    cell.activity.hidden = NO;
    
    
    API *apiRequest = [[API alloc] init];
    
    [apiRequest post:@"s/categoryProductCnts"
        successBlock:^(NSDictionary *result){
            NSLog(@"result: %@", result);
            
            int resultCode = [[result objectForKey:@"code"] intValue];
            if (resultCode == kAPI_RESULT_OK){
                NSArray *counts = [result objectForKey:@"result"];
                
                if (_listData.count != counts.count)
                    return;
                
                int i = 0;
                for (NSMutableDictionary *device in _listData){
                    NSInteger cnt = [[[counts objectAtIndex:i] objectForKey:@"products_count"] integerValue];
                    [device setObject:[NSNumber numberWithInteger:cnt] forKey:@"product_count"];
                    i++;
                }
                
                [self loadCategoryListAtIndexPath:indexPath];
            }
            
            _tableView.userInteractionEnabled = YES;

        }
         failureBock:^(NSError *error){
             NSLog(@"error: %@", error);
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CASEBUY"
                                                              message:NSLocalizedString(@"Cannot Connect to Server. Please try after some minute", nil)
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"OKAY",nil)
                                                    otherButtonTitles:nil];
             
             [alert show];
             
             _tableView.userInteractionEnabled = YES;
             cell.checkImg.hidden = NO;
             cell.activity.hidden = YES;
         }];
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 타이틀
    self.title = @"CHOOSE DEVICE";
    
    
    // 왼쪽 버튼
    if (leftBtnHide){
        self.navigationItem.leftBarButtonItem = nil;
    } else {
        [self setLeftButtonType:LeftButtonTypeCancel];
    }
    
    
    // 더미 데이터
    _listData = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *iphone5 = [NSMutableDictionary dictionary];
    [iphone5 setObject:@"IPHONE 5" forKey:@"title"];
    [iphone5 setObject:[UIImage imageNamed:@"DeviceIphone5"] forKey:@"icon"];
    [iphone5 setObject:[UIImage imageNamed:@"DeviceIphone5_Selected"] forKey:@"icon_selected"];
    [iphone5 setObject:[NSNumber numberWithInteger:5] forKey:@"categories_id"];
    [iphone5 setObject:[NSNumber numberWithInteger:0] forKey:@"product_count"];
    [_listData addObject:iphone5];
    
    NSMutableDictionary *iphone4s = [NSMutableDictionary dictionary];
    [iphone4s setObject:@"IPHONE 4∙4S" forKey:@"title"];
    [iphone4s setObject:[UIImage imageNamed:@"DeviceIphone4"] forKey:@"icon"];
    [iphone4s setObject:[UIImage imageNamed:@"DeviceIphone4_Selected"] forKey:@"icon_selected"];
    [iphone4s setObject:[NSNumber numberWithInteger:4] forKey:@"categories_id"];
    [iphone4s setObject:[NSNumber numberWithInteger:0] forKey:@"product_count"];
    [_listData addObject:iphone4s];
    
    NSMutableDictionary *ipad = [NSMutableDictionary dictionary];
    [ipad setObject:@"IPAD" forKey:@"title"];
    [ipad setObject:[UIImage imageNamed:@"DeviceIpad"] forKey:@"icon"];
    [ipad setObject:[UIImage imageNamed:@"DeviceIpad_Selected"] forKey:@"icon_selected"];
    [ipad setObject:[NSNumber numberWithInteger:6] forKey:@"categories_id"];
    [ipad setObject:[NSNumber numberWithInteger:0] forKey:@"product_count"];
    [_listData addObject:ipad];
    
    NSMutableDictionary *ipadMini = [NSMutableDictionary dictionary];
    [ipadMini setObject:@"IPAD MINI" forKey:@"title"];
    [ipadMini setObject:[UIImage imageNamed:@"DeviceIpadmini"] forKey:@"icon"];
    [ipadMini setObject:[UIImage imageNamed:@"DeviceIpadmini_Selected"] forKey:@"icon_selected"];
    [ipadMini setObject:[NSNumber numberWithInteger:10] forKey:@"categories_id"];
    [ipadMini setObject:[NSNumber numberWithInteger:0] forKey:@"product_count"];
    [_listData addObject:ipadMini];
    
    
    [self loadCurrentDevice];
    
    
    if (leftBtnHide){
        NSNumber *index = [self indexForPlatform];
        if (index){
            [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index.integerValue inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            
            [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:index.integerValue inSection:0]];

        }
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSInteger cId = [def integerForKey:kCURRENT_CATEGORY_ID];
    
    if (cId){
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currDeviceIdx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[AppDelegate sharedAppdelegate] isIphone5])
        return 131;
    
    return 109;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"MyCell";
	DeviceCell *cell = (DeviceCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"DeviceCell" owner:nil options:nil];
		cell = [arr objectAtIndex:0];
	}
    
    NSDictionary *device = [_listData objectAtIndex:indexPath.row];
    
    [cell setTitle:[device objectForKey:@"title"]
              icon:[device objectForKey:@"icon"]
      iconSelected:[device objectForKey:@"icon_selected"]];
    
    
    
    
    return cell;
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    _tableView.userInteractionEnabled = NO;
    [self loadProductCountsAtIndexPath:indexPath];
    
    
}

#pragma mark - Load Category List

- (void)loadCategoryListAtIndexPath:(NSIndexPath *)indexPath{
    
    DeviceCell *cell = (DeviceCell*)[_tableView cellForRowAtIndexPath:indexPath];
    cell.checkImg.hidden = NO;
    cell.activity.hidden = YES;
    
    NSDictionary *item = [_listData objectAtIndex:indexPath.row];
    NSInteger cnt = [[item objectForKey:@"product_count"] integerValue];
    NSLog(@"%d",cnt);
    
    if (cnt < 1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CASEBUY"
                                                         message:NSLocalizedString(@"Sorry! We're preparing products :)", nil)
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"OKAY",nil)
                                               otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    [self setCurrentDevice:indexPath.row];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    _tableView.userInteractionEnabled = NO;
    
    if (leftBtnHide){
        [[AppDelegate sharedAppdelegate] loadMainViewWithShoptype:cnt>CATEGORY_MINIMUM_COUNT?ShopTypeCategory:ShopTypeList categoryId:[[item objectForKey:@"categories_id"] integerValue] withTitle:[item objectForKey:@"title"]];
    } else {
        MainViewController *main = (MainViewController*)[[[AppDelegate sharedAppdelegate] window]rootViewController];
        
        [main setShopType:cnt>CATEGORY_MINIMUM_COUNT?ShopTypeCategory:ShopTypeList withCategoryId:[[item objectForKey:@"categories_id"] integerValue] title:[item objectForKey:@"title"]];
        [self performSelector:@selector(close) withObject:nil afterDelay:.2];
    }
    
    
    
    
    
}


#pragma mark - Platform

- (NSString *) platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

- (NSNumber*)indexForPlatform{
    NSString *platform = [self platform];
    NSInteger idx;
    
    if ([platform isEqualToString:@"iPhone5,1"]||
        [platform isEqualToString:@"iPhone5,2"])
    {
        idx = 0;
    }
    
    else if ([platform isEqualToString:@"iPhone3,1"]||
        [platform isEqualToString:@"iPhone3,3"]||
        [platform isEqualToString:@"iPhone4,1"])
    {
        idx = 1;
    }
    
    else if ([platform isEqualToString:@"iPad3,1"]||
        [platform isEqualToString:@"iPad3,2"]||
        [platform isEqualToString:@"iPad3,3"]||
        [platform isEqualToString:@"iPad3,4"]||
        [platform isEqualToString:@"iPad3,5"]||
        [platform isEqualToString:@"iPad3,6"])
    {
        idx = 2;
    }
    
    else if ([platform isEqualToString:@"iPad2,5"]||
        [platform isEqualToString:@"iPad2,6"]||
        [platform isEqualToString:@"iPad2,7"])
    {
        idx = 3;
    }
    else {
        return nil;
    }
    
    return [NSNumber numberWithInteger:idx];
    
}


@end
