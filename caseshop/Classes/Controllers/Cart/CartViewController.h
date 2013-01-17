//
//  CartViewController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 24..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "BaseViewController.h"
#import "ColorButton.h"
#import "CartCell.h"
#import "ShipTableController.h"
#import "PayPal.h"

@interface CartViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CartCellDelegate,ShipTableControllerDelegate>{
    IBOutlet UITableView *_tableView;
    IBOutlet UILabel *_subtotalLabel;
    IBOutlet UILabel *_subtotalLabel1;
    IBOutlet UILabel *_shippingLabel;
    IBOutlet UILabel *_totalLabel;
    IBOutlet ColorButton *_countryBtn;
    IBOutlet ColorButton *_checkoutBtn;
    
    IBOutlet UIView *_withShippingView;
    IBOutlet UIView *_withoutShippingView;
    IBOutlet UIActivityIndicatorView *_shipIndicator;
    IBOutlet UIActivityIndicatorView *_checkoutIndicator;
    
    NSMutableArray *_listData;
    
    NSNumberFormatter *formatter;
    
    CartCell *_editingCell;
    
    double latest;
    
    NSString *_shipOption;
    
    BOOL tokenFetchAttempted;
}

@property (nonatomic,strong) NSString *shipOption;
@property (nonatomic) float subTotalAmount;
@property (nonatomic) float totalWeight;
@property (nonatomic) float shipAmount;
@property (nonatomic) float totalAmount;
@property (nonatomic,strong) NSString *selectedCountry;
@property (nonatomic,strong) NSString *selectedCountryName;

@property (nonatomic,strong) NSString *deviceReferenceToken;
@property (nonatomic,strong) NSDate *deviceTokenCreated;
@property (nonatomic, assign) BOOL tokenFetchAttempted;

@property (nonatomic,strong) NSString *checkoutToken;


@end
