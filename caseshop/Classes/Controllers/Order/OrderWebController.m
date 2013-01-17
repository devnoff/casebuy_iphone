//
//  OrderWebController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 21..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "OrderWebController.h"

@interface OrderWebController ()

@end

@implementation OrderWebController

- (void)dealloc{
    _webView = nil;
}

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)req navigationType:(UIWebViewNavigationType)navigationType{
    
   
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


@end
