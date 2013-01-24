//
//  ShopMainController.m
//  caseshop
//
//  Created by Yongnam Park on 13. 1. 24..
//  Copyright (c) 2013년 CultStory Inc. All rights reserved.
//

#import "ShopMainController.h"
#import "DeviceSelectController.h"
#import "API.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ShopViewController.h"

@interface ShopMainController ()

@end

@implementation ShopMainController
@synthesize categoryId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)device{
    DeviceSelectController *device = [[DeviceSelectController alloc] initWithNibName:@"DeviceSelectController" bundle:nil];
    device.currDeviceIdx = 1;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:device];
    [self presentModalViewController:nav animated:YES];
}

- (void)loadData{
    API *apiRequest = [[API alloc] init];
    
    [self clearThumbnails];
    
    [apiRequest get:[NSString stringWithFormat:@"s/mainContentCategory?categories_id=%d",categoryId]
       successBlock:^(NSDictionary *result){
           NSLog(@"mainContentCategory: %@", result);
           
           int resultCode = [[result objectForKey:@"code"] intValue];
           if (resultCode == kAPI_RESULT_OK){
                
               NSDictionary *data = [result objectForKey:@"result"];
               [self setContentThumbnailsForData:data];
           }
           
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);

        }];

}

- (void)clearThumbnails{
    for (UIImageView *v in _pops){
        v.image = nil;
    }
    for (UIImageView *v in _news){
        v.image = nil;
    }
    for (UIImageView *v in _bests){
        v.image = nil;
    }
}

- (void)setContentThumbnailsForData:(NSDictionary*)data{
    
    NSArray *pop = [data objectForKey:@"populars"];
    NSArray *new = [data objectForKey:@"new_arrivals"];
    NSArray *best = [data objectForKey:@"best_sellers"];
    
    int i = 0;
    for (NSDictionary *p in pop){
        
        if (i > _pops.count)
            return;
        
        NSString *thumbUrl = [p objectForKey:@"thumb"];
        UIImageView *c = [_pops objectAtIndex:i];
        [c setImageWithURL:[NSURL URLWithString:thumbUrl]];
        
        i++;
    }
    
    i = 0;
    for (NSDictionary *p in new){
        
        if (i > _news.count)
            return;
        
        NSString *thumbUrl = [p objectForKey:@"thumb"];
        UIImageView *c = [_news objectAtIndex:i];
        [c setImageWithURL:[NSURL URLWithString:thumbUrl]];
        
        i++;
    }
    
    i = 0;
    for (NSDictionary *p in best){
        
        if (i > _bests.count)
            return;
        
        NSString *thumbUrl = [p objectForKey:@"thumb"];
        UIImageView *c = [_bests objectAtIndex:i];
        [c setImageWithURL:[NSURL URLWithString:thumbUrl]];
        
        i++;
    }
    
}

- (IBAction)allProductTapped:(id)sender{
    ShopViewController *shop = [[ShopViewController alloc] initWithNibName:@"ShopViewController" bundle:nil];
    shop.categoryId = self.categoryId;
    shop.shopType = ShopTypeList;
    shop.dispType = ShopDispTypeCategoryProductsList;
//    [shop locateNavigationButtons];
    [self.navigationController pushViewController:shop animated:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = nil;
    [self setLeftButtonType:LeftButtonTypeDevice];
    
    [[[self.view subviews] objectAtIndex:0] setContentSize:CGSizeMake(320, 465)];
    
    _pops = @[pop1,pop2,pop3,pop4];
    _news = @[new1,new2,new3,new4,new5,new6];
    _bests = @[best1,best2,best3,best4];
    
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
