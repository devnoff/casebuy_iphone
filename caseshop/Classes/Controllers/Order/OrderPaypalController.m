//
//  OrderPaypalController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 22..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "OrderPaypalController.h"
#import "OrderController.h"
#import "API.h"
#import "AppDelegate.h"
#import "ECNetworkHandler.h"
#import "WebViewController.h"
#import "SBJson.h"


#define RETURN_URL @"http://ReturnURL"
#define CANCEL_URL @"http://CancelURL"

#define DEVICE_TOKEN_EXPIRE_PERIOD_MIN 40


@interface OrderPaypalController ()

@end

@implementation OrderPaypalController
@synthesize jsonRequestData,checkoutToken,deviceReferenceToken,deviceTokenCreated;


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
    
    self.title = @"SHIPPING INFO";
    
    handler = [[ECNetworkHandler alloc] init];
    
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
    
    if ([[comp objectAtIndex:0] isEqualToString:@"submitted"]){
        
        NSString *shiptoname = [webView stringByEvaluatingJavaScriptFromString:@"$('input[name=\"shiptoname\"]').val();"];
        NSString *shiptophonenum = [webView stringByEvaluatingJavaScriptFromString:@"$('input[name=\"shiptophonenum\"]').val();"];
        NSString *shiptostreet = [webView stringByEvaluatingJavaScriptFromString:@"$('input[name=\"shiptostreet\"]').val();"];
        NSString *shiptostreet2 = [webView stringByEvaluatingJavaScriptFromString:@"$('input[name=\"shiptostreet2\"]').val();"];
        NSString *shiptocity = [webView stringByEvaluatingJavaScriptFromString:@"$('input[name=\"shiptocity\"]').val();"];
        NSString *shiptostate = [webView stringByEvaluatingJavaScriptFromString:@"$('input[name=\"shiptostate\"]').val();"];
        NSString *shiptozip = [webView stringByEvaluatingJavaScriptFromString:@"$('input[name=\"shiptozip\"]').val();"];
        NSString *shiptocountrycode = [webView stringByEvaluatingJavaScriptFromString:@"$('input[name=\"shiptocountrycode\"]').val();"];
        
        
        NSMutableDictionary *recipient = [NSMutableDictionary dictionary];
        [recipient setObject:shiptoname forKey:kSHIPTONAME];
        [recipient setObject:shiptophonenum forKey:kSHIPTOPHOMENUM];
        [recipient setObject:shiptostreet forKey:kSHIPTOSTREET];
        [recipient setObject:shiptostreet2 forKey:kSHIPTOSTREET2];
        [recipient setObject:shiptocity forKey:kSHIPTOCITY];
        [recipient setObject:shiptostate forKey:kSHIPTOSTATE];
        [recipient setObject:shiptozip forKey:kSHIPTOZIP];
        [recipient setObject:shiptocountrycode forKey:kSHIPTOCOUNTRYCODE];
        
        [OrderController setRecipientInfo:recipient];
        
        NSLog(@"%@ ",recipient);
        
        [self checkOut];
        
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad");
    
    NSDictionary *recipient = [OrderController recipientInfo];
    if (recipient){
        NSArray *keys = recipient.allKeys;
        for (NSString *key in keys){
            NSString *code = [NSString stringWithFormat:@"$('input[name=\"%@\"]').val('%@');",key,[recipient objectForKey:key]];
            [webView stringByEvaluatingJavaScriptFromString:code];
        }
    }
    
    NSString *code = [NSString stringWithFormat:@"$('input[id=\"%@\"]').val('%@');",kSHIPTOCOUNTRYCODE,[jsonRequestData objectForKey:@"shipping_country_name"]];
    [webView stringByEvaluatingJavaScriptFromString:code];
    
    code = [NSString stringWithFormat:@"$('input[name=\"%@\"]').val('%@');",kSHIPTOCOUNTRYCODE,[jsonRequestData objectForKey:@"shipping_country"]];
    [webView stringByEvaluatingJavaScriptFromString:code];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


#pragma mark - Checkout


- (void)showPaypalWebView{
    
    handler.userAction = ECUSERACTION_COMMIT;
    WebViewController *webView = [[WebViewController alloc] initWithURL:handler.redirectURL
                                                               returnURL:RETURN_URL
                                                               cancelURL:CANCEL_URL];
    
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView
                                         animated:TRUE];
}

- (void)sendCheckout{
    
    API *apiRequest = [[API alloc] init];

    [jsonRequestData addEntriesFromDictionary:[OrderController recipientInfo]];
    
    NSString *string = [jsonRequestData JSONRepresentation];
    
    [apiRequest appendBody:string fieldName:@"order_info"];
    
    [apiRequest post:@"paypal/Set_express_checkout_demo"
        successBlock:^(NSDictionary *result){
            NSLog(@"sendCheckout result: %@", result);
            int resultCode = [[result objectForKey:@"code"] intValue];
            if (resultCode == kAPI_RESULT_OK){
                self.checkoutToken = [result objectForKey:@"result"];
                
                handler.ecToken = self.checkoutToken;
                
                [self showPaypalWebView];
            } else if (resultCode == kAPI_RESULT_FAIL){
                NSString *msg = [[[result objectForKey:@"error"] objectAtIndex:0] objectForKey:@"L_SHORTMESSAGE"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PayPal"
                                                                 message:msg
                                                                delegate:self
                                                       cancelButtonTitle:@"OKAY"
                                                       otherButtonTitles:nil];
                
                [alert show];
            }
            
            [self hideBlackLoadingMask];
            
        }
         failureBock:^(NSError *error){
             [self hideBlackLoadingMask];
             
             NSLog(@"error: %@", error);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CASEBUY"
                                                              message:@"Internet connection is bad. Please try again some minute later."
                                                             delegate:self
                                                    cancelButtonTitle:@"OKAY"
                                                    otherButtonTitles:nil];
             
             [alert show];
         }];
}

- (void)checkOut{

    NSDate *comparing = [[NSDate date] dateByAddingTimeInterval: - (60 * DEVICE_TOKEN_EXPIRE_PERIOD_MIN)];
    
    if (!self.deviceTokenCreated || [self.deviceTokenCreated compare:comparing] == NSOrderedAscending ){
        
        // 토큰 요청
        [[PayPal getPayPalInst] fetchDeviceReferenceTokenWithAppID:@"APP-2MT06421DM772643J" forEnvironment:ENV_LIVE withDelegate:self];
        
        [self showBlackLoadingMask];
        return;
    }
    
    [self sendCheckout];
    
}


#pragma mark -
#pragma mark DeviceReferenceTokenDelegate methods

- (void)receivedDeviceReferenceToken:(NSString *)token{
    NSLog(@"receivedDeviceReferenceToken: %@",token);
    
    self.deviceReferenceToken = token;
    self.deviceTokenCreated = [NSDate date];
    
    handler.deviceReferenceToken = self.deviceReferenceToken;
    
    [self checkOut];
}

- (void)couldNotFetchDeviceReferenceToken{
    NSLog(@"DEVICE REFERENCE TOKEN ERROR: %@", [PayPal getPayPalInst].errorMessage);
    [self hideBlackLoadingMask];
    
    self.deviceTokenCreated = nil;
    self.deviceReferenceToken = nil;
    
    [self checkOut];
}






@end
