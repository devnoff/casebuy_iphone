//
//  OrderPaymentController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 21..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "OrderPaymentController.h"
#import "API.h"
#import "OrderController.h"
#import "OrderDetailController.h"
#import "CurrencyHelper.h"

@interface OrderPaymentController ()

@end

@implementation OrderPaymentController
@synthesize orderId,selectedMethod,orderCode;


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

    self.title = @"결제";
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APIURL,@"s/mobile/orderPaymentView"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



- (void)showPaymentViewWithOrderId:(NSInteger)ordersId{
    PaymentController *payment = [[PaymentController alloc] initWithNibName:@"PaymentController" bundle:nil];
    payment.orderId = ordersId;
    payment.method = self.selectedMethod;
    payment.delegate = self;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payment];
//    [self presentModalViewController:nav animated:YES];
    [self.navigationController pushViewController:payment animated:YES];
    
//    [nav release];
}

- (void)inputOrder{
    [self showBlackLoadingMask];
    
    
    NSDictionary *data = [OrderController serializedData];
    NSArray *keys = [data allKeys];
    
    API *apiRequest = [[API alloc] init];
    
    for (NSString *key in keys){
        id object = [data objectForKey:key];
        
        if ([object isKindOfClass:[NSArray class]]){
            int i = 0;
            for (NSString *val in (NSArray*)object){
                [apiRequest appendBody:val fieldName:[NSString stringWithFormat:@"%@[%d]",key,i++]];
            }
        } else {
            [apiRequest appendBody:object fieldName:key];
        }
    }
    
    [apiRequest post:@"s/inputOrder"
        successBlock:^(NSDictionary* result){
            NSLog(@"%@", result);
            int resultCode = [[result objectForKey:@"code"] intValue];
            if (resultCode == kAPI_RESULT_OK){
                
                self.orderId = [[result objectForKey:@"orders_id"] integerValue];
                self.orderCode = [result objectForKey:@"order_code"];
                
                NSLog(@"orderCode %@", orderCode);
                [self showPaymentViewWithOrderId:self.orderId];
                [OrderController setOrderId:self.orderId];
            } else {
                NSString *reason = [result objectForKey:@"reason"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CASEBUY"
                                                                 message:reason
                                                                delegate:self
                                                       cancelButtonTitle:@"확인"
                                                       otherButtonTitles:nil];
                
                [alert show];
            }
            
            [self hideBlackLoadingMask];
            
        }
         failureBock:^(NSError *error){
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CASEBUY"
                                                              message:@"서버와의 통신이 원할하지 않습니다. 다시 시도해 주세요."
                                                             delegate:self
                                                    cancelButtonTitle:@"확인"
                                                    otherButtonTitles:nil];
             
             [alert show];
             
             [self hideBlackLoadingMask];
         }];
    
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)req navigationType:(UIWebViewNavigationType)navigationType{
    
    NSMutableURLRequest *request = (NSMutableURLRequest *)req;
    
    NSString *url = [[request URL] absoluteString];
    NSLog(@"url : %@",url);
    NSArray *comp = [url componentsSeparatedByString:@":"];
    if (comp.count <= 1)
        return YES;
    
    if ([[comp objectAtIndex:0] isEqualToString:@"paywithmethod"]){
        if ([[comp objectAtIndex:1] isEqualToString:@"card"]){
            // 카드결제
            self.selectedMethod = @"card";
        }
        
        else if ([[comp objectAtIndex:1] isEqualToString:@"virtual"]){
            // 가상계좌 결제
            self.selectedMethod = @"virtual";
        }
        
        [self inputOrder];
        
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *url = webView.request.URL.absoluteString;
    if([url isEqualToString:[NSString stringWithFormat:@"%@%@",APIURL,@"s/mobile/orderPaymentView"]]){
       
        NSInteger payable = [OrderController totalAmountForOrderProducts] + [OrderController deliveryFeeForOrder];
        NSString *amt = [CurrencyHelper formattedString:[NSNumber numberWithInteger:payable] withIdentifier:IDENTIFIED_LOCALE];
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"$('[name=\"payable_amount\"]').val('%@');", amt]];
        
    }
    
    
}


#pragma mark - PaymentControllerDelegate

- (void)paymentControllerSuccessPaid:(PaymentController*)controller{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCART_COUNT_UPDATE_NOTIFICATION object:[NSNumber numberWithInt:0]];
    
    OrderDetailController *detail = [[OrderDetailController alloc] initWithNibName:@"OrderDetailController" bundle:nil];
    detail.orderCode = self.orderCode;
    detail.popToRoot = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)paymentControllerFailedPaid:(PaymentController*)controller{
    
}

- (void)paymentControllerCancelPayment:(PaymentController*)controller{
    
}
@end
