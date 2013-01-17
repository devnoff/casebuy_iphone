//
//  OrderInfoController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 21..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "OrderInfoController.h"
#import "AddressFindController.h"
#import "OrderController.h"
#import "OrderPaymentController.h"

@interface OrderInfoController ()

@end

@implementation OrderInfoController
@synthesize targetName;


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
    
    self.title = @"배송지정보입력";

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APIURL,@"s/mobile/orderInfoView"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [_webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)req navigationType:(UIWebViewNavigationType)navigationType{
    
    NSMutableURLRequest *request = (NSMutableURLRequest *)req;
    
    NSString *url = [[request URL] absoluteString];
    NSLog(@"url : %@",url);
    NSArray *comp = [url componentsSeparatedByString:@":"];
    if (comp.count <= 1)
        return YES;
    
    if ([[comp objectAtIndex:0] isEqualToString:@"findaddressfor"]){
        self.targetName = [comp objectAtIndex:1];
        
        AddressFindController *find = [[AddressFindController alloc] initWithNibName:@"AddressFindController" bundle:nil];
        find.delegate = self;
        [self.navigationController pushViewController:find animated:YES];
        
        
        return NO;
    }
    
    else if ([[comp objectAtIndex:0] isEqualToString:@"submitted"]){
        self.targetName = [comp objectAtIndex:1];
        
        NSString *ordererName = [webView stringByEvaluatingJavaScriptFromString:@"$('input[name=\"orderer_name\"]').val();"];
        NSString *ordererMobile = [webView stringByEvaluatingJavaScriptFromString:@"$('input[name=\"orderer_mobile\"]').val();"];
        NSString *ordererCarrier = [webView stringByEvaluatingJavaScriptFromString:@"$('[name=\"orderer_carrier\"]').val();"];
        NSString *ordererEmail = [webView stringByEvaluatingJavaScriptFromString:@"$('input[name=\"orderer_email\"]').val();"];
        NSString *ordererAddress = [webView stringByEvaluatingJavaScriptFromString:@"$('input[name=\"orderer_address\"]').val();"];
        
        NSMutableDictionary *orderer = [NSMutableDictionary dictionary];
        [orderer setObject:ordererName forKey:kORDERER_NAME];
        [orderer setObject:ordererMobile forKey:kORDERER_MOBILE];
        [orderer setObject:ordererCarrier forKey:kORDERER_CARRIER];
        [orderer setObject:ordererEmail forKey:kORDERER_EMAIL];
        [orderer setObject:ordererAddress forKey:kORDERER_ADDRESS];
        
        [OrderController setOrdererInfo:orderer];
        
        NSString *recipientName = [webView stringByEvaluatingJavaScriptFromString:@"$('input[name=\"recipient_name\"]').val();"];
        NSString *recipientMobile = [webView stringByEvaluatingJavaScriptFromString:@"$('input[name=\"recipient_mobile\"]').val();"];
        NSString *recipientMsg = [webView stringByEvaluatingJavaScriptFromString:@"$('input[name=\"recipient_msg\"]').val();"];
        NSString *recipientAddress = [webView stringByEvaluatingJavaScriptFromString:@"$('input[name=\"recipient_address\"]').val();"];
        
        NSMutableDictionary *recipient = [NSMutableDictionary dictionary];
        [recipient setObject:recipientName forKey:kRECIPIENT_NAME];
        [recipient setObject:recipientMobile forKey:kRECIPIENT_MOBILE];
        [recipient setObject:recipientMsg forKey:kRECIPIENT_MSG];
        [recipient setObject:recipientAddress forKey:kRECIPIENT_ADDRESS];
        
        [OrderController setRecipientInfo:recipient];
        
        NSLog(@"%@ \n %@",orderer,recipient);
        
        
        OrderPaymentController *payment = [[OrderPaymentController alloc] initWithNibName:@"OrderWebController" bundle:nil];
        [self.navigationController pushViewController:payment animated:YES];
        
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad");
    
    NSDictionary *orderer = [OrderController ordererInfo];
    if (orderer){
        NSArray *keys = orderer.allKeys;
        for (NSString *key in keys){
            NSString *code = [NSString stringWithFormat:@"$('[name=\"%@\"]').val('%@');",key,[orderer objectForKey:key]];
            [webView stringByEvaluatingJavaScriptFromString:code];
        }
    }
    
    NSDictionary *recipient = [OrderController recipientInfo];
    if (recipient){
        NSArray *keys = recipient.allKeys;
        for (NSString *key in keys){
            NSString *code = [NSString stringWithFormat:@"$('input[name=\"%@\"]').val('%@');",key,[recipient objectForKey:key]];
            [webView stringByEvaluatingJavaScriptFromString:code];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


#pragma mark - AddressFinishController Delegate

- (void)addressController:(AddressFinishController*)controller finishWithResult:(NSString*)result deliveryFee:(NSInteger)fee{

    NSString *str = [NSString stringWithFormat:@"setAddress('%@','%@')",self.targetName,result];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "]; // \n 이 포함될 경우 자바스크립트 오류
    
    [_webView stringByEvaluatingJavaScriptFromString:str];
    

}

@end
