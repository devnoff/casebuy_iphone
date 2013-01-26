//
//  CartViewController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 24..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "CartViewController.h"
#import "API.h"
#import "AppDelegate.h"
#import "CSImageCache.h"
#import "ProductDetailController.h"
#import "Order2ViewController.h"
#import "API.h"
#import "ECNetworkHandler.h"
#import "WebViewController.h"
#import "SBJson.h"
#import "CurrencyHelper.h"
#import "OrderInfoController.h"
#import "OrderController.h"
#import "OrderPaypalController.h"
#import "Flurry.h"

#define DEVICE_TOKEN_EXPIRE_PERIOD_MIN 40

@interface CartViewController ()

@end

@implementation CartViewController
@synthesize subTotalAmount,shipAmount,totalAmount,selectedCountry,totalWeight,shipOption=_shipOption,deviceReferenceToken,deviceTokenCreated,tokenFetchAttempted,checkoutToken,selectedCountryName;

- (void)dealloc{
    _subtotalLabel = nil;
    _countryBtn = nil;
    _withoutShippingView = nil;
    _withShippingView = nil;
    _shippingLabel = nil;
    _subtotalLabel1 = nil;
    _checkoutBtn = nil;
    _totalLabel = nil;
    _editingCell = nil;
    _shipIndicator = nil;
    _checkoutIndicator = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - Button Actions


- (IBAction)countryBtnTapped:(id)sender{
    
    [self selectCountry];
}

- (IBAction)checkoutBtnTapped:(id)sender{
    
    if (_listData.count < 1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CASEBUY"
                                                         message:NSLocalizedString(@"Cart is Empty :p", nil)
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"OKAY",nil)
                                               otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    if (_shippingLabel.hidden){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CASEBUY"
                                                         message:NSLocalizedString(@"Please wait until calculating shipping cost is complete.", nil)
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"OKAY",nil)
                                               otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    [self checkOut];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    
}

#pragma mark - Actions

- (void)edit{
    
    [self setLeftCustomButtonWithTitle:NSLocalizedString(@"DONE", nil) target:self selector:@selector(done)];
    
    if (!_tableView.editing){
        [_tableView setEditing:YES animated:YES];
    }
}

- (void)done{
    [self setLeftButtonType:LeftButtonTypeEdit];
    
    if (_tableView.editing){
        [_tableView setEditing:NO animated:YES];
    }
}

- (void)customAction{
    [self selectCountry];
}

- (void)selectCountry{
    
    ShipTableController *table = [[ShipTableController alloc] initWithNibName:@"ShipTableController" bundle:nil];
    table.delegate = self;
    table.weight = self.totalWeight;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:table];
    [self presentModalViewController:nav animated:YES];
}

- (void)updateCartItem:(NSString*)itemId qty:(NSString*)qty{
    
    _checkoutBtn.enabled = NO;
    
    API *apiRequest = [[API alloc] init];
    
    [apiRequest appendBody:itemId fieldName:@"cart_item_id"];
    [apiRequest appendBody:qty fieldName:@"qty"];
    
    [apiRequest post:@"s/updateCart"
       successBlock:^(NSDictionary *result){
           NSLog(@"result: %@", result);
           
           int resultCode = [[result objectForKey:@"code"] intValue];
           if (resultCode == kAPI_RESULT_OK){
               if (!_editingCell)
                   _checkoutBtn.enabled = YES;
           }
           
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);
        }];

}


#pragma mark - Checkout

- (void)checkOut{
    
    
    // 지역설정이 한국일 경우 올더게이트 프로세스
    if (IS_LOCALE_KO) {
     
        [OrderController setOrderProducts:_listData];
        [OrderController setDeliveryFeeForOrder:(NSInteger)self.shipAmount];
        [OrderController setTotalAmountForOrderProducts:(NSInteger)self.subTotalAmount];
        
        OrderInfoController *info = [[OrderInfoController alloc] initWithNibName:@"OrderWebController" bundle:nil];
        info.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:info animated:YES];
        
        return;
    } else {
        
        // 그 외 페이팔
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:_listData forKey:@"cart_items"];
        [dic setObject:self.selectedCountry forKey:@"shipping_country"];
        [dic setObject:self.selectedCountryName forKey:@"shipping_country_name"];
        [dic setObject:self.shipOption forKey:@"shipping_option"];
        [dic setObject:[NSNumber numberWithFloat:self.shipAmount] forKey:@"shipping_amount"];
        [dic setObject:[NSNumber numberWithFloat:self.subTotalAmount] forKey:@"subtotal_amount"];
        [dic setObject:[NSNumber numberWithFloat:self.totalAmount] forKey:@"total_amount"];
        [dic setObject:[NSNumber numberWithFloat:self.totalWeight] forKey:@"total_weight"];
        
        OrderPaypalController *paypal = [[OrderPaypalController alloc] initWithNibName:@"OrderWebController" bundle:nil];
        paypal.hidesBottomBarWhenPushed = YES;
        paypal.jsonRequestData = dic;
        [self.navigationController pushViewController:paypal animated:YES];
    }
       
}


#pragma mark - UI Control

- (void)showCheckoutIndicator{
    _checkoutIndicator.hidden = NO;
    _totalLabel.hidden = YES;
    [_checkoutBtn setTitle:@"" forState:UIControlStateNormal];
}

- (void)hideCheckoutIndicator{
    _checkoutIndicator.hidden = YES;
    _totalLabel.hidden = NO;
}

#pragma mark - Data

- (void)calculatePrice{
    
    // 제품 가격 합계, 무계 합계
    float subTotal = 0;
    float weight = 0;
    for (NSMutableDictionary *productInfo in _listData){
        NSMutableDictionary *product = [productInfo objectForKey:@"product"];
        int qty = [[productInfo objectForKey:@"qty"] intValue];
        
        // 가격
        float price = [[product objectForKey:@"sales_price"] floatValue];
        float sum = price * qty;
        
        // 소계
        [productInfo setObject:[NSNumber numberWithFloat:sum] forKey:@"sum_price"];
        
        subTotal += sum;
        
        // 무게
        float w = [[product objectForKey:@"weight"] floatValue];
        float wsum = w * qty;
        weight += wsum;
    }
    
    // 총무게
    self.totalWeight = weight;
    NSLog(@"total weight : %f", weight);
    
    // 제품 가격
    self.subTotalAmount = subTotal;

    NSString *formattedString = [CurrencyHelper formattedString:[NSNumber numberWithFloat:subTotal] withIdentifier:IDENTIFIED_LOCALE];
    _subtotalLabel.text = formattedString;
    _subtotalLabel1.text = formattedString;
    
    // 배송비
    _shippingLabel.text = [CurrencyHelper formattedString:[NSNumber numberWithFloat:shipAmount] withIdentifier:IDENTIFIED_LOCALE];
    
    // 전체합계
    totalAmount = subTotal + shipAmount;
    _totalLabel.text = [NSString stringWithFormat:@"%@%@",[CurrencyHelper formattedString:[NSNumber numberWithFloat:totalAmount] withIdentifier:IDENTIFIED_LOCALE],IS_LOCALE_KO?@"":@"USD"];

}

- (void)loadData{
    
    _checkoutBtn.enabled = NO;
    
    API *apiRequest = [[API alloc] init];
    
    NSString *uuid = [[AppDelegate sharedAppdelegate] uuid];
    
    [apiRequest get:[NSString stringWithFormat:@"s/cartList?uuid=%@&date_latest=%f",uuid,latest]
       successBlock:^(NSDictionary *result){
           NSLog(@"result: %@", result);
           
           int resultCode = [[result objectForKey:@"code"] intValue];
           if (resultCode == kAPI_RESULT_OK){
               
               _editingCell = nil;
               
               // 버전
               NSString *dateStr = [result objectForKey:@"date_latest"];
               latest = [dateStr doubleValue];
               
               // 합계금액
               NSDictionary *data = [result objectForKey:@"result"];
               NSInteger totalAmt = [[data objectForKey:@"total_amount"] integerValue];
               self.subTotalAmount = totalAmt;
               
               // 상품 목록
               NSArray *products = [data objectForKey:@"carts"];
               [_listData removeAllObjects];
               [_listData addObjectsFromArray:products];
               [_tableView reloadData];
               
               // 배송비 : 좋아요 상품이 있을 경우 무료
               shipAmount = [self existLikedProduct]?0:2500;
               
               [self calculatePrice];
               
           }
           
           if (resultCode == kAPI_RESULT_LATEST || resultCode == kAPI_RESULT_OK){
               _checkoutBtn.enabled = _listData.count > 0;
           }
           
           if (!IS_LOCALE_KO &&(resultCode != kAPI_RESULT_LATEST || resultCode == kAPI_RESULT_OK)){
               [self loadShipFee];
           }
           
           self.navigationItem.leftBarButtonItem.enabled = _listData.count > 0;
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);
        }];

}

- (void)loadShipFee{
    
    if (_withShippingView.hidden){
        return;
    }
    
    _checkoutBtn.enabled = NO;
    
    _shippingLabel.hidden = YES;
    _shipIndicator.hidden = NO;
    
    API *apiRequest = [[API alloc] init];
    
    NSString *code = self.selectedCountry;
    NSString *option = self.shipOption;
    
    [apiRequest get:[NSString stringWithFormat:@"s/shipFeeByWeight?code=%@&option=%@&weight=%f",code,option,self.totalWeight]
       successBlock:^(NSDictionary *result){
           NSLog(@"result: %@", result);
           
           int resultCode = [[result objectForKey:@"code"] intValue];
           if (resultCode == kAPI_RESULT_OK){
               
               self.shipAmount = [[result objectForKey:@"result"]floatValue];

               [self calculatePrice];
               
               _shippingLabel.hidden = NO;
               _shipIndicator.hidden = YES;
               
               if (!_editingCell)
                   _checkoutBtn.enabled = YES;
           }
           
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);
        }];

}

- (void)removeItem:(NSString*)itemId{
    API *apiRequest = [[API alloc] init];
    
    [apiRequest appendBody:itemId fieldName:@"cart_item_id"];
    
    [apiRequest post:@"s/removeCartItem"
        successBlock:^(NSDictionary *result){
            NSLog(@"result: %@", result);
            
            int resultCode = [[result objectForKey:@"code"] intValue];
            if (resultCode == kAPI_RESULT_OK){
                NSNumber *cnt = [NSNumber numberWithInt:_listData.count];
                [[NSNotificationCenter defaultCenter] postNotificationName:kCART_COUNT_UPDATE_NOTIFICATION object:cnt];
            }
            
        }
         failureBock:^(NSError *error){
             NSLog(@"error: %@", error);
         }];

}



#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 채크아웃 버튼 인셋
    [_checkoutBtn setLabelInset:CGSizeMake(0, -8)];
    
    // 편집버튼
    [self setLeftButtonType:LeftButtonTypeEdit];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    // 리스트
    _listData = [[NSMutableArray alloc] init];
    
    // 통화 포맷
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:IDENTIFIED_LOCALE]];
    NSString *groupingSeparator = [[[NSLocale alloc] initWithLocaleIdentifier:IDENTIFIED_LOCALE] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];

    
    
    // 배송비 라벨 제스쳐
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCountry)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    _shippingLabel.userInteractionEnabled = YES;
    [_shippingLabel addGestureRecognizer:tap];
    
    
    // 배송 옵션 적용
    [self applyShippingOption];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}




- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self localizationCheckout];
    
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self done];
    
    if (_editingCell){
        [_editingCell doneBtnTapped:nil];
    }
}

- (void)viewShouldRefresh{
    [super viewShouldRefresh];
    
    [self localizationShipping];
    [self localizationCheckout];
    
    [self loadData];
}

#pragma mark - Like Checking

- (BOOL)existLikedProduct{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSArray *liked = [def arrayForKey:kLIKED_ITEMS];
    
    for (NSNumber *itemId in liked){
        for (NSDictionary *productInfo in _listData){
            NSDictionary *product = [productInfo objectForKey:@"product"];
            NSNumber *pId = [product objectForKey:@"id"];
            if (itemId.integerValue == pId.integerValue){
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)isLikedItem:(NSInteger)productId{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSArray *liked = [def arrayForKey:kLIKED_ITEMS];
    
    for (NSNumber *itemId in liked){
        if (productId == itemId.integerValue){
            return YES;
        }
    }
    return NO;
}

#pragma mark - Shipping control

- (void)localizationCheckout{
    UIImage *img;
    
    if (IS_LOCALE_KO){
        // 체크아웃버튼 초기화
        img = [UIImage imageNamed:@"Checkout"];
        
        // 뷰 조정
        _withoutShippingView.hidden = YES;
        _withShippingView.hidden = NO;
        
        // 배송비 : 좋아요 상품이 있을 경우 무료
        shipAmount = [self existLikedProduct]?0:2500;
        
        // 테이블 뷰 사이즈 조정
        CGRect frame = _tableView.frame;
        frame.size.height = self.view.frame.size.height - _withShippingView.frame.size.height;
        _tableView.frame = frame;
        
        
        // 국가선택
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    } else {
        // 체크아웃 버튼 페이팔
        img = [UIImage imageNamed:@"Checkout_Paypal"];
    }
    
    [_checkoutBtn setBackgroundImage:img forState:UIControlStateNormal];

    [self calculatePrice];
}

- (void)localizationShipping{
    
    if (!IS_LOCALE_KO){
        // 배송비 계산 초기화
        [self resetShipping];
    }
    
    // 계산
    [self calculatePrice];
}


- (void)resetShipping{
    shipAmount = 0;
    self.selectedCountry = nil;
    
    // 뷰 조정
    _withoutShippingView.hidden = NO;
    _withShippingView.hidden = YES;
    self.shipOption = nil;
    
    self.navigationItem.rightBarButtonItem = nil;
}






#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [self tableView:nil heightForHeaderInSection:section])];
    
    UIImage *bg = [UIImage imageNamed:@"CategoryBar"];
    UIImageView *bar = [[UIImageView alloc] initWithImage:bg];;
    bar.frame = CGRectMake(0, 0, bg.size.width, bg.size.height);
    
    [view addSubview:bar];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28.0f;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MyCell";
	CartCell *cell = (CartCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"CartCell" owner:nil options:nil];
		cell = [arr objectAtIndex:0];
        cell.delegate = self;
	}
    
    NSDictionary *productInfo = [_listData objectAtIndex:indexPath.row];
    NSDictionary *product = [productInfo objectForKey:@"product"];
    
    cell.titleLabel.text = [[NSString stringWithFormat:@"%@ %@",[product objectForKey:@"title"],[productInfo objectForKey:@"option_name"]] uppercaseString];
    cell.priceLabel.text = [CurrencyHelper formattedString:[NSNumber numberWithFloat:[[product objectForKey:@"sales_price"] floatValue]] withIdentifier:IDENTIFIED_LOCALE];
    [cell setQty:[productInfo objectForKey:@"qty"]];
    
    cell.fbBadge.hidden = ![self isLikedItem:[[product objectForKey:@"id"]integerValue]];

    
    [cell.photoView setImageWithURL:[NSURL URLWithString:[product objectForKey:@"thumb"]]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"canEditRowAtIndexPath");
    CartCell *cell = (CartCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (tableView.editing){
        [cell shouldStartEditing];
    } else {
        [cell shouldEndEditing];
    }
    
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        id cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if ([cell isEqual:_editingCell]){
            _editingCell = nil;
        }
        
        NSDictionary *cartItem = [_listData objectAtIndex:indexPath.row];
        NSString *itemId = [cartItem objectForKey:@"id"];
        [self removeItem:itemId];
        
        [_listData removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (_listData.count < 1){
            [self done];
        }
        
        [self calculatePrice];
        
        [cell endEditing:YES];
        
        [_tableView reloadData];
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *productInfo = [_listData objectAtIndex:indexPath.row];
    NSDictionary *p = [productInfo objectForKey:@"product"];
    
    ProductDetailController *product = [[ProductDetailController alloc] initWithNibName:@"ProductDetailController" bundle:nil];
    product.hidesBottomBarWhenPushed = YES;
    product.productId = [[p objectForKey:@"id"] integerValue];
    [self.navigationController pushViewController:product animated:YES];
    
}

#pragma mark - CartCellDelegate

- (void)cartCellShouldUpdate:(CartCell *)cell{
    NSIndexPath *indexpath = [_tableView indexPathForCell:cell];
    NSMutableDictionary *productInfo = [_listData objectAtIndex:indexpath.row];
    [productInfo setObject:cell.qtyButton.titleLabel.text forKey:@"qty"];
    
    [self calculatePrice];
    
    [self updateCartItem:[productInfo objectForKey:@"id"] qty:cell.qtyButton.titleLabel.text];
    
    if (!IS_LOCALE_KO)
        [self loadShipFee];
    
    if ([cell isEqual:_editingCell]){
        _editingCell = nil;
        _checkoutBtn.enabled = YES;
    }
}

- (void)cartCellDidStartEditing:(CartCell *)cell{
    if ([cell isEqual:_editingCell]){
        return;
    }
    
    CartCell *oldCell = _editingCell;
    _editingCell = cell;
    
    if (oldCell){
        [oldCell doneBtnTapped:nil];
    }
    
    
    
    _checkoutBtn.enabled =  NO;
    
}



#pragma mark - ShipTableControllerDelegate

- (void)shipTableController:(ShipTableController *)controller selectedCountry:(NSString *)countryCode countryName:(NSString *)country fee:(float)fee option:(NSString *)option {
    
    [controller dismissModalViewControllerAnimated:YES];
    
    // 테이블 뷰 사이즈 조정
    CGRect frame = _tableView.frame;
    frame.size.height = self.view.frame.size.height - _withShippingView.frame.size.height;
    _tableView.frame = frame;
    
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:[NSNumber numberWithFloat:fee] forKey:kSHIPPINGOPTION_FEE];
    [options setObject:countryCode forKey:kSHIPPINGOPTION_COUNTRY_CODE];
    [options setObject:country forKey:kSHIPPINGOPTION_COUNTRY_NAME];
    [options setObject:option forKey:kSHIPPINGOPTION_TYPE];
    [OrderController setShippingOption:options];
    
    
    [self applyShippingOption];
    
    
}


#pragma mark - Shipping Ooption

- (void)applyShippingOption{
    NSDictionary *options = [OrderController shippingOption];
    
    if (options){
        shipAmount = [[options objectForKey:kSHIPPINGOPTION_FEE] floatValue];
        
        // 계산
        [self calculatePrice];
        
        // 뷰 조정
        _withoutShippingView.hidden = YES;
        _withShippingView.hidden = NO;
        
        // 배송 옵션
        self.shipOption = [options objectForKey:kSHIPPINGOPTION_TYPE];
        
        self.selectedCountry = [options objectForKey:kSHIPPINGOPTION_COUNTRY_CODE];
        self.selectedCountryName = [options objectForKey:kSHIPPINGOPTION_COUNTRY_NAME];
        [self setRightCustomButtonWithTitle:[NSString stringWithFormat:@"%@ %@",self.selectedCountry,self.shipOption.uppercaseString]];
        
        
    }
}




@end
