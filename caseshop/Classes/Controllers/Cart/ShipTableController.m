//
//  ShipTableController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 7..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "ShipTableController.h"
#import "ShipInfoCell.h"
#import "CountryCell.h"
#import "API.h"


@interface ShipTableController ()

@end

@implementation ShipTableController
@synthesize delegate,weight;

- (void)dealloc{
    self.delegate = nil;
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

#pragma mark - Actions

- (void)cancel{
    [self dismissModalViewControllerAnimated:YES];
}



#pragma mark - Button Actions


#pragma mark - Data

- (void)loadData{
    API *apiRequest = [[API alloc] init];
    
    if (self.weight < 150) self.weight = 150;
    
    [apiRequest get:[NSString stringWithFormat:@"s/shipTable?weight=%f",self.weight]
       successBlock:^(NSDictionary *result){
           NSLog(@"result: %@", result);
           
           int resultCode = [[result objectForKey:@"code"] intValue];
           if (resultCode == kAPI_RESULT_OK){
               
               // 배송비 테이블
               NSDictionary *data = [result objectForKey:@"result"];
               [_shipTable removeAllObjects];
               [_shipTable addEntriesFromDictionary:data];
               
               // 키 추출
               NSMutableArray *keys = [NSMutableArray arrayWithArray:[_shipTable allKeys]];
               [keys sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
               [_listData removeAllObjects];
               [_listData addObjectsFromArray:keys];
               
               
               [_tableView reloadData];
           }
           
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);
        }];
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"SHIPPING COUNTRY", nil);
    
    [self setLeftButtonType:LeftButtonTypeCancel];
    
    _shipTable = [[NSMutableDictionary alloc] init];
    _listData = [[NSMutableArray alloc] init];
    _shipInfo = [[NSMutableArray alloc] init];
    
    
    
    // 통화 포맷
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:IDENTIFIED_LOCALE]];
    NSString *groupingSeparator = [[[NSLocale alloc] initWithLocaleIdentifier:IDENTIFIED_LOCALE] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _listData.count;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = CGRectMake(0, 0, 320, 50);
    CountryCell *cell = [[CountryCell alloc] initWithFrame:frame];
    cell.tag = section;
    
    NSString *key = [_listData objectAtIndex:section];
    NSDictionary *country = [_shipTable objectForKey:key];
    cell.nameLabel.text = [[country objectForKey:@"name"] uppercaseString];
    
    [cell addTarget:self action:@selector(didSelectCountry:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.userInteractionEnabled = YES;
    
    if (_selectedButton && _selectedButton.tag == section){
        cell.selected = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == _selectedButton.tag)
        return _shipInfo.count;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"MyCell";
	ShipInfoCell *cell = (ShipInfoCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[ShipInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];;

	}
    
    NSDictionary *info = [_shipInfo objectAtIndex:indexPath.row];
    
    [cell setName:[info objectForKey:@"title"]
             desc:[info objectForKey:@"desc"]
              fee:[[info objectForKey:@"fee"]description] ];
    

    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (delegate && [delegate respondsToSelector:@selector(shipTableController:selectedCountry:countryName:fee:option:)]){
        NSString *code = [_listData objectAtIndex:indexPath.section];
        ShipInfoCell *cell = (ShipInfoCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        NSString *key = [_listData objectAtIndex:indexPath.section];
        NSDictionary *country = [_shipTable objectForKey:key];
        NSString *countryName = [[country objectForKey:@"name"] uppercaseString];
        
        [delegate shipTableController:self selectedCountry:code countryName:countryName fee:[[formatter numberFromString:cell.feeStr] floatValue] option:cell.optionStr];
    }
}


#pragma mark - Country

- (void)didSelectCountry:(UIButton*)countryBtn{

    NSLog(@"didSelectCountry");
    
    if ([_selectedButton isEqual:countryBtn]){
        return;
    }
    
    [_tableView beginUpdates];
    
    
    
    if (_selectedButton){
        
        int sec = _selectedButton.tag;
        
        for (int i = 0; i<_shipInfo.count; i++){
            NSMutableArray *deleteIndexPaths = [NSMutableArray array];
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:sec];
            [deleteIndexPaths addObject:path];
            [_tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationTop];
        }

    

    }
    
    [_shipInfo removeAllObjects];
    
    
    _selectedButton.selected = NO;
    _selectedButton = countryBtn;
    [countryBtn setSelected:YES];
    
    NSInteger idx = countryBtn.tag;
    NSString *key = [_listData objectAtIndex:idx];
    NSDictionary *country = [_shipTable objectForKey:key];


    NSDictionary *option = [country objectForKey:@"options"];
    
    NSArray *okeys = [option allKeys];
    int i = 0;
    for (NSString *k in okeys){
        NSString *desc = [k isEqual:@"normal"]?@"7-15 DAYS":@"3-6 DAYS";
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                                desc,@"desc",
                                [k uppercaseString],@"title",
                                [formatter stringFromNumber:[NSNumber numberWithFloat:[[option objectForKey:k]floatValue]]],@"fee", nil];
        
        [_shipInfo addObject:info];
        
        NSMutableArray *insertIndexPaths = [NSMutableArray array];
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:idx];
        [insertIndexPaths addObject:path];
        i++;
        
        [_tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
    }   
    
    
    [_tableView endUpdates];
}

@end
