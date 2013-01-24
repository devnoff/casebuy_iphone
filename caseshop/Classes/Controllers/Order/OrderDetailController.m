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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)req navigationType:(UIWebViewNavigationType)navigationType{

    NSMutableURLRequest *request = (NSMutableURLRequest *)req;
    
    NSString *url = [[request URL] absoluteString];
    NSLog(@"url : %@",url);
    NSArray *comp = [url componentsSeparatedByString:@"#"];
    if (comp.count < 2)
        return YES;
    
    if ([[comp objectAtIndex:1] isEqualToString:@"cancelRequestDone"]){
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    
    else if ([[comp objectAtIndex:1] isEqualToString:@"openInSafari"]){
        NSString *url = [comp objectAtIndex:0];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return NO;
    }

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
    
    NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"appVersion=%@;",versionString]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [controller dismissModalViewControllerAnimated:YES];

    NSLog(@"error: %@", error);
}

@end
