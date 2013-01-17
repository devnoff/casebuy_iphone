//
//  CSWebViewController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 29..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "CSWebViewController.h"

@interface CSWebViewController ()

@end

@implementation CSWebViewController
@synthesize startUrl;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (self.startUrl){
        NSURL *url = [NSURL URLWithString:self.startUrl];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
