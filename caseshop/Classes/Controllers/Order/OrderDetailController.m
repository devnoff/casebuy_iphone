//
//  OrderDetailController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 9..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "OrderDetailController.h"
#import "MailController.h"

@interface OrderDetailController ()

@end

@implementation OrderDetailController
@synthesize orderCode,popToRoot;

- (void)dealloc{
    _activity = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Actions

- (void)back{
    if (popToRoot){
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [super back];
    }
}

- (void)done{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)customAction{
    [MailController mailWithTitle:NSLocalizedString(@"[CASEBUY.ME]CONTACT FOR ORDER", nil)
                        recipient:@"casebuy@cultstory.com"
                             memo:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Order NO:", nil),orderCode]
                           target:self];
}


#pragma mark - View Life Cycle

- (void)viewShouldRefresh{
    [self done];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"ORDER DETAIL", nil);
    

    NSString *urlStr = [NSString stringWithFormat:@"%@s/mobile/orderDetailView/%@",APIURL,self.orderCode];
    NSURL *url = [NSURL URLWithString:urlStr];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    if (popToRoot){
        [self setLeftCustomButtonWithTitle:NSLocalizedString(@"DONE", nil) target:self selector:@selector(done)];
    }
    
    
    [self setRightCustomButtonWithTitle:NSLocalizedString(@"CONTACT", nil)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%@",request.URL.absoluteString);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIView animateWithDuration:.3
                     animations:^{
                         _activity.hidden = YES;
                         _webView.alpha = 1.0f;
                     }];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [controller dismissModalViewControllerAnimated:YES];

    NSLog(@"error: %@", error);
}

@end
