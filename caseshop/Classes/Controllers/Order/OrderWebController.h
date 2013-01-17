//
//  OrderWebController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 21..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderWebController : BaseViewController<UIWebViewDelegate>{
    IBOutlet UIWebView *_webView;
}

@end
