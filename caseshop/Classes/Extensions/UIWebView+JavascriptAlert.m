//
//  UIWebView+JavascriptAlert.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 22..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "UIWebView+JavascriptAlert.h"

@implementation UIWebView(JavascriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame

{
    
    UIAlertView* dialogue = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [dialogue show];
    
}

@end
