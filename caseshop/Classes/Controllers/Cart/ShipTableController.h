//
//  ShipTableController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 7..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "BaseViewController.h"


@protocol ShipTableControllerDelegate;
@interface ShipTableController : BaseViewController<UITableViewDataSource, UITableViewDelegate>{
    
    IBOutlet UITableView *_tableView;
    
    NSMutableArray *_listData;
    NSMutableDictionary *_shipTable;
    
    NSMutableArray *_shipInfo;
    
    UIButton *_selectedButton;
    
    NSNumberFormatter *formatter;
}

@property (nonatomic,weak) id<ShipTableControllerDelegate>delegate;
@property (nonatomic) float weight;

@end


@protocol ShipTableControllerDelegate <NSObject>

- (void)shipTableController:(ShipTableController*)controller selectedCountry:(NSString*)countryCode countryName:(NSString*)country fee:(float)fee option:(NSString*)option;

@end