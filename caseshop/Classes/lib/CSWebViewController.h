//
//  CSWebViewController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 29..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "BaseViewController.h"

@interface CSWebViewController : BaseViewController{
    IBOutlet UIWebView *_webView;
}

@property (nonatomic,strong) NSString *startUrl;

@end
