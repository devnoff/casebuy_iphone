//
//  PaymentController.m
//  scomdcom
//
//  Created by Yongnam Park on 12. 10. 4..
//  Copyright (c) 2012년 Yongnam Park. All rights reserved.
//

#import "PaymentController.h"
#import "OrderController.h"
#import "API.h"
#import "AppDelegate.h"

@interface PaymentController ()

@end

@implementation PaymentController
@synthesize delegate,method,orderId,virInfo;

- (void)dealloc{
    _webView = nil;
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Actions

- (void)cancel{
    [self removeOrder];
    
    if (delegate && [delegate respondsToSelector:@selector(paymentControllerCancelPayment:)])
        [delegate paymentControllerCancelPayment:self];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)inputScript:(id)sender{
    NSString *script = _textField.text;
    NSLog(@"%@",[_webView stringByEvaluatingJavaScriptFromString:script]);
    
}

#pragma mark - Payment

- (void)requestPayment{
    
    NSURL *url = [NSURL URLWithString:@"http://casebuy.me/ko/paygate/ready.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    
}


- (void)successPayment{
    
    if (delegate && [delegate respondsToSelector:@selector(paymentControllerSuccessPaid:)])
        [delegate paymentControllerSuccessPaid:self];
}

- (void)failedPayment{
    
    if (delegate && [delegate respondsToSelector:@selector(paymentControllerFailedPaid:)])
        [delegate paymentControllerFailedPaid:self];
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"결제하기";
    
    virInfo = [[NSMutableDictionary alloc] init];
    
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    [self requestPayment];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Actions

- (void)back{
    
    [self removeOrder];
    
    [super back];
}

#pragma mark - Order

- (void)removeOrder{
    
    API *apiRequest = [[API alloc] init];
    [apiRequest appendBody:[NSString stringWithFormat:@"%d",orderId] fieldName:@"orders_id"];
    [apiRequest post:@"s/removeOrder"
        successBlock:^(NSDictionary* result){
            NSLog(@"removeOrder %@", result);
            int resultCode = [[result objectForKey:@"code"] intValue];
            if (resultCode == kAPI_RESULT_OK){
            }
        }
         failureBock:^(NSError *error){
             
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
    
    if ([[comp objectAtIndex:0] isEqualToString:@"scomdcom"]){
        if ([[comp objectAtIndex:1] isEqualToString:@"success"]){
            
            if ([[comp objectAtIndex:3] isEqualToString:@"virtual"]){
                [virInfo removeAllObjects];
                NSString *str = [comp objectAtIndex:4];
                [virInfo setObject:[str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"agency"];
                [virInfo setObject:[comp objectAtIndex:5] forKey:@"acc_no"];
            }
            [self successPayment];
            
        } else if ([[comp objectAtIndex:1] isEqualToString:@"cancel"]) {
            [self cancel];
        } else {
            [self failedPayment];
        }
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *url = webView.request.URL.absoluteString;
    if([url isEqualToString:@"http://casebuy.me/ko/paygate/ready.php"]){
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:paymentReady('%d','%@')",self.orderId,self.method]];
        
    }
    
    else if ([url isEqualToString:@"http://casebuy.me/ko/paygate/"]){
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSDictionary *orderer = [def dictionaryForKey:kORDERER_INFO];
        NSString *carrier = [orderer objectForKey:kORDERER_CARRIER];
        
        NSString *uuid = [[AppDelegate sharedAppdelegate] uuid];
        
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"$('[name=\"carrier\"]').val('%@');",carrier]];
        
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"$('[name=\"uuid\"]').val('%@');",uuid]];
        
    }
    
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CASEBUY"
                                                     message:@"서버와의 통신이 원할하지 않습니다. 다시 시도해주세요"
                                                    delegate:self
                                           cancelButtonTitle:@"확인"
                                           otherButtonTitles:nil];
    
    [alert show];
//    [self dismissModalViewControllerAnimated:YES];
}

@end
