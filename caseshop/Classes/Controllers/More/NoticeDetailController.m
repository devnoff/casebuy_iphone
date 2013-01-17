//
//  NoticeDetailController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 29..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "NoticeDetailController.h"
#import "AppDelegate.h"

@interface NoticeDetailController ()

@end

@implementation NoticeDetailController
@synthesize itemId,hasLeftCancelBtn;


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

- (void)close{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (hasLeftCancelBtn){
        [self setLeftCustomButtonWithTitle:NSLocalizedString(@"CLOSE", nil) target:self selector:@selector(close)];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@s/mobile/noticeDetailView/%d?uuid=%@",APIURL,self.itemId,[[AppDelegate sharedAppdelegate] uuid]];
    NSURL *url = [NSURL URLWithString:urlStr];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
