//
//  NoticeDetailController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 29..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "BaseViewController.h"

@interface NoticeDetailController : BaseViewController<UIWebViewDelegate>{
    IBOutlet UIWebView *_webView;
}

@property (nonatomic) NSInteger itemId;
@property (nonatomic) BOOL hasLeftCancelBtn;

@end
