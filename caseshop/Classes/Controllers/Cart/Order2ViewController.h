//
//  Order2ViewController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 12..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "BaseViewController.h"
#import "PayPal.h"

@interface Order2ViewController : BaseViewController<DeviceReferenceTokenDelegate>{
    IBOutlet UIWebView *_webView;
}

@end
