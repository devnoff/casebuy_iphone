//
//  AddressFindController.h
//  scomdcom
//
//  Created by Yongnam Park on 12. 9. 13..
//  Copyright (c) 2012년 Yongnam Park. All rights reserved.
//

#import "BaseViewController.h"

@interface AddressFindController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    
    IBOutlet UITableView *_tableView;
    IBOutlet UIView *_emptyView;
    
    UITableViewCell *_findCell;
    UITextField *_searchField;
    
    NSMutableArray *_resultArray;
}

@property (nonatomic,weak) id delegate;

@end
