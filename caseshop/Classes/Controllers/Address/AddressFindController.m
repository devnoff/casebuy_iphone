//
//  AddressFindController.m
//  scomdcom
//
//  Created by Yongnam Park on 12. 9. 13..
//  Copyright (c) 2012년 Yongnam Park. All rights reserved.
//

#import "AddressFindController.h"
#import "AddressFinishController.h"
#import "API.h"

@interface AddressFindController ()

@end

@implementation AddressFindController
@synthesize delegate;

- (void)dealloc{
    _tableView = nil;
    _emptyView = nil;
    self.delegate = nil;
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

- (void)find{
    
    if (_searchField.text.length < 1){
        return;
    }
    
    API *apiRequest = [[API alloc] init];
    [apiRequest get:[[NSString stringWithFormat:@"s/addressSearch?keyword=%@",_searchField.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
        successBlock:^(NSDictionary* result){
            NSLog(@"%@", result);
            
            [_resultArray removeAllObjects];
            int resultCode = [[result objectForKey:@"code"] intValue];
            if (resultCode == kAPI_RESULT_OK){
                
                NSArray * addr = [result objectForKey:@"result"];
                [_resultArray addObjectsFromArray:addr];
                
                _tableView.tableFooterView = nil;
            } else {
                _tableView.tableFooterView = _emptyView;
            }
            
            [_tableView reloadData];
        }
         failureBock:^(NSError *error){
            
         }];
    
}


#pragma mark - Button Actions

- (void)findButtonTapped{
    [self find];
    [_searchField resignFirstResponder];
    
}


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"주소검색";
    
    _resultArray = [[NSMutableArray alloc] init];
    
    
    // 테이블 뷰 스타일
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
    // 검색 셀 초기화
    _findCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"findCell"];
    _findCell.frame = CGRectMake(0, 0, 320, 42);
    _findCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, _findCell.frame.size.width - 30, 23)];
    _searchField.textColor = [UIColor colorWithRed:0.380 green:0.412 blue:0.471 alpha:1.000];
    _searchField.font = [UIFont systemFontOfSize:15];
    _searchField.placeholder = @"읍・면・동으로 검색하세요";
    _searchField.returnKeyType = UIReturnKeySearch;
    _searchField.clearButtonMode = UITextFieldViewModeAlways;
    _searchField.delegate = self;

    
    [_findCell addSubview:_searchField];
    
    
    [_searchField becomeFirstResponder];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return 1;
    
    else
        return _resultArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 + (_resultArray.count>0?1:0);
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 38)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 320-20, 15)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:0.404 green:0.788 blue:0.992 alpha:1.000];
    label.shadowOffset = CGSizeMake(0, 0);
    label.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:label];
    
    if (section == 0){
        label.text = @"주소 검색";
    } else {
        label.text = @"주소를 선택해주세요";
    }

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        return _findCell;
    }
    
    static NSString *identifier = @"MyCell";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.447 alpha:1.000];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.minimumFontSize = 10;
        cell.backgroundColor = [UIColor whiteColor];
	}
    
    NSDictionary *addr = [_resultArray objectAtIndex:indexPath.row];
    NSString *fullAddr = [NSString stringWithFormat:@"[%@] %@",[addr objectForKey:@"zipcode"],[addr objectForKey:@"addr_full"]];
    
    cell.textLabel.text = fullAddr;
    
    return cell;
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) return;
    
    
    NSDictionary *addr = [_resultArray objectAtIndex:indexPath.row];
    NSString *fullAddr = [NSString stringWithFormat:@"[%@]\n%@",[addr objectForKey:@"zipcode"],[addr objectForKey:@"addr_base"]];
    
    AddressFinishController *finish = [[AddressFinishController alloc] init];
    finish.result = fullAddr;
    finish.originData = addr;
    finish.delegate = self.delegate;
    [self.navigationController pushViewController:finish animated:YES];
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_searchField resignFirstResponder];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self find];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [_searchField resignFirstResponder];
    return YES;
}


@end
