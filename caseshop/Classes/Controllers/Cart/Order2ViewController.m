//
//  Order2ViewController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 12..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "Order2ViewController.h"

@interface Order2ViewController ()

@end

@implementation Order2ViewController

- (void)dealloc{
    _webView = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - Acitons
- (void)cancel{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"CHECKING OUT", nil);
    
    [self setLeftButtonType:LeftButtonTypeCancel];
    
    // 토큰 요청
    [[PayPal getPayPalInst] fetchDeviceReferenceTokenWithAppID:@"APP-80W284485P519543T" forEnvironment:ENV_SANDBOX withDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark -
#pragma mark DeviceReferenceTokenDelegate methods

- (void)receivedDeviceReferenceToken:(NSString *)token{
    NSLog(@"receivedDeviceReferenceToken: %@",token);


}

- (void)couldNotFetchDeviceReferenceToken{
    NSLog(@"DEVICE REFERENCE TOKEN ERROR: %@", [PayPal getPayPalInst].errorMessage);
    

}





@end
