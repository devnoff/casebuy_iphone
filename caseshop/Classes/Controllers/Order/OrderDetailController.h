//
//  OrderDetailController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 9..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "BaseViewController.h"


@interface OrderDetailController : BaseViewController<UIWebViewDelegate,MFMailComposeViewControllerDelegate>{
    IBOutlet UIWebView *_webView;
    IBOutlet UIActivityIndicatorView *_activity;

}
@property (nonatomic,strong) NSString *orderCode;
@property (nonatomic) BOOL popToRoot;

@end
