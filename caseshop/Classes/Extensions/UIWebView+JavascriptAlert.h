//
//  UIWebView+JavascriptAlert.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 22..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView(JavascriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame;

@end
