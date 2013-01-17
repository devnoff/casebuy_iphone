//
//  AddressFinishController.h
//  scomdcom
//
//  Created by Yongnam Park on 12. 9. 13..
//  Copyright (c) 2012년 Yongnam Park. All rights reserved.
//

#import "BaseViewController.h"


@protocol AddressFinishControllerDelegate;
@interface AddressFinishController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    
    UITableView *_tableView;
    UITableViewCell *_resultCell;
    
}
@property (nonatomic,weak) id delegate;
@property (nonatomic,strong) NSString *result;
@property (nonatomic,strong) NSDictionary *originData;

@end



@protocol AddressFinishControllerDelegate <NSObject>

- (void)addressController:(AddressFinishController*)controller finishWithResult:(NSString*)result deliveryFee:(NSInteger)fee;

@end