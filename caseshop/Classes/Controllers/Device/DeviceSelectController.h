//
//  DeviceSelectController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 26..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "BaseViewController.h"


typedef enum {
    ProductDispTypeProducts,
    ProductDispTypeTags
} ProductDispType;

//typedef enum {
//    DeviceTypeIphone5,
//    DeviceTypeIphone4,
//    DeviceTypeIpad,
//    DeviceTypeIpadMini
//} DeviceType;


@interface DeviceSelectController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *_tableView;
    
    NSMutableArray *_listData;
    
    NSString *_currDeviceName;
}
@property (nonatomic) NSInteger currDeviceIdx;
@property (nonatomic) BOOL leftBtnHide;


@end
