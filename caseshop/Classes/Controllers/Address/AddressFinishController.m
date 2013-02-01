//
//  AddressFinishController.m
//  scomdcom
//
//  Created by Yongnam Park on 12. 9. 13..
//  Copyright (c) 2012년 Yongnam Park. All rights reserved.
//

#import "AddressFinishController.h"

@interface AddressFinishController ()

@end

@implementation AddressFinishController
@synthesize result, delegate,originData;

- (void)dealloc{
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"상세주소입력";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor colorWithRed:0.675 green:0.686 blue:0.714 alpha:1.000];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.separatorColor = [UIColor colorWithWhite:0.859 alpha:1.000];
    [self.view addSubview:_tableView];
    
    
    
    _resultCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"resultCell"];
    _resultCell.backgroundColor = [UIColor colorWithRed:0.882 green:0.890 blue:0.910 alpha:1.000];
    _resultCell.textLabel.text = self.result;
    _resultCell.textLabel.minimumScaleFactor = .5;
    _resultCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _resultCell.textLabel.font = [UIFont systemFontOfSize:15];
    _resultCell.textLabel.textColor = [UIColor colorWithWhite:0.447 alpha:1.000];
    _resultCell.textLabel.minimumScaleFactor = .5;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0){
        cell = _resultCell;
    } else {
        static NSString *identifier = @"MyCell";
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            UITextField * _searchField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, cell.frame.size.width - 30, 23)];
            _searchField.textColor = [UIColor colorWithRed:0.380 green:0.412 blue:0.471 alpha:1.000];
            _searchField.font = [UIFont systemFontOfSize:15];
            _searchField.placeholder = @"상세 주소를 입력하세요";
            _searchField.returnKeyType = UIReturnKeyDone;
            _searchField.clearButtonMode = UITextFieldViewModeAlways;
            _searchField.delegate = self;
            [_searchField becomeFirstResponder];
            [cell addSubview:_searchField];
        }
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length < 1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                         message:@"상세 주소를 입력하세요"
                                                        delegate:nil
                                               cancelButtonTitle:@"확인"
                                               otherButtonTitles:nil];
        [alert show];
        
        return YES;
    }
    
    NSInteger fee = [[originData objectForKey:@"delivery_fee"] integerValue];
    
    NSString *resultStr = [NSString stringWithFormat:@"%@%@", self.result, textField.text];
    
    if (delegate && [delegate respondsToSelector:@selector(addressController:finishWithResult:deliveryFee:)]){
        [delegate addressController:self finishWithResult:resultStr deliveryFee:fee];
    }
    
    
    [self.navigationController popToViewController:self.delegate animated:YES];
    
    return YES;
}

@end
