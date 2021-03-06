//
//  WebViewController.m
//  ExpressCheckout
//
//  This view controller handles displaying the PayPal login and review screens.
//

#import "WebViewController.h"
#import "PayPal.h"
#import "GetExpressCheckoutDetailsResponseDetails.h"
#import "DoExpressCheckoutPaymentRequestDetails.h"
#import "DoExpressCheckoutPaymentResponseDetails.h"
#import "API.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "OrderDetailController.h"

@implementation WebViewController

@synthesize startURL, returnURL, cancelURL, step;
@dynamic loadingView;

- (id)initWithURL:(NSString *)theURL returnURL:(NSString *)theReturnURL cancelURL:(NSString *)theCancelURL {
    if (self = [super init]) {
		self.startURL = theURL;
		self.returnURL = theReturnURL;
		self.cancelURL = theCancelURL;
    }
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
	webView.delegate = self;
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:startURL]]];
	self.view = webView;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.hidesBackButton = TRUE;
}

#define LOADING_TAG 6543
-(UIActivityIndicatorView *)loadingView {
	UIActivityIndicatorView *lv = (UIActivityIndicatorView *)[self.view viewWithTag:LOADING_TAG];
	if (lv == nil) {
		lv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[lv setHidesWhenStopped:TRUE];
		CGRect frame = lv.frame;
		frame.origin.x = round((self.view.frame.size.width - frame.size.width) / 2.);
		frame.origin.y = round((self.view.frame.size.height - frame.size.height) / 2.);
		lv.frame = frame;
		lv.tag = LOADING_TAG;
		[self.view addSubview:lv];
	}
	return lv;
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self loadingView];
	[self.navigationController setNavigationBarHidden:TRUE animated:TRUE];
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:FALSE animated:TRUE];
}


- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    

}

- (void)viewDidUnload {
    [super viewDidUnload];

}


- (void)dealloc {
	((UIWebView *)self.view).delegate = nil;
}


#pragma mark -
#pragma mark payment result handling methods

-(void)paymentSuccess:(NSString *)transactionID {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCART_COUNT_UPDATE_NOTIFICATION object:[NSNumber numberWithInt:0]];
    
	OrderDetailController *detail = [[OrderDetailController alloc] initWithNibName:@"OrderDetailController" bundle:nil];
    detail.orderCode = transactionID;
    detail.popToRoot = YES;
//    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController pushViewController:detail animated:YES];
}

-(void)paymentCanceled {
	[self.navigationController popViewControllerAnimated:TRUE];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Order canceled" 
													message:@"You canceled your order. Touch \"Pay with PayPal\" to try again." 
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

-(void)paymentFailed {
	[self.navigationController popViewControllerAnimated:TRUE];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Order failed" 
													message:@"Your order failed. Touch \"Pay with PayPal\" to try again." 
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

#pragma mark UIWebViewDelegate methods

//In webView:shouldStartLoadWithRequest:navigationType: we intercept attempts to redirect to the return or cancel URL
//and instead transition to our own success screen or return to shopping cart screen.
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
	NSString *urlString = [[request.URL absoluteString] lowercaseString];
    
    NSLog(@"webview shouldStartLoadWithRequest :  %@",urlString);
    
	if (urlString.length > 0) {
		//80 is the default HTTP port.
		//The PayPal server may add the default port to the URL.
		//This will break our string comparisons.
		if ([request.URL.port intValue] == 80) {
			urlString = [urlString stringByReplacingOccurrencesOfString:@":80" withString:@""];
		}
		
		if ([urlString rangeOfString:@"_flow"].location != NSNotFound) {
			step++;
		}
		if ([urlString rangeOfString:[cancelURL lowercaseString]].location != NSNotFound) {
			[self paymentCanceled];
			return FALSE;
		}
		if ([urlString rangeOfString:[returnURL lowercaseString]].location != NSNotFound) {
			//In this example, we are doing the Express Checkout calls completely in the client.  This is discouraged
			//because it exposes the merchant API credentials within the iPhone application.
			//If we get this far, it means the user successfully logged in on PayPal's site and authorized payment.
			//Now we call getExpressCheckoutDetails and handle the response below in expressCheckoutResponseReceived:
//			[[ECNetworkHandler sharedInstance] getExpressCheckoutDetailsWithToken:nil withDelegate:self]; //pass nil to use cached token
            [self getCheckoutDetail];
			return FALSE;
		}
	}
	return TRUE;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	self.title = @"Connecting to PayPal...";
	[self.loadingView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	self.title = [NSString stringWithFormat:@"Step %d", step];
	[self.loadingView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	self.title = @"Connection failed";
	[self.loadingView stopAnimating];
}


#pragma mark - Getting Checkout

- (void)getCheckoutDetail{
    API *apiRequest = [[API alloc] init];
    
    [apiRequest get:[NSString stringWithFormat:@"paypal/Get_express_checkout_details/%@",[ECNetworkHandler sharedInstance].ecToken]
       successBlock:^(NSDictionary *result){
           NSLog(@"getCheckoutDetail result: %@", result);
           int resultCode = [[result objectForKey:@"code"] intValue];
           if (resultCode == kAPI_RESULT_OK){
               NSDictionary *resultDic = [result objectForKey:@"result"];
               NSString *json = [resultDic JSONRepresentation];
               [self doPayments:json];
               
           } else {
               [self paymentFailed];
           }
           
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);
        }];
}

- (void)doPayments:(NSString*)data{
    API *apiRequest = [[API alloc] init];
    
    NSString *uuid = [[AppDelegate sharedAppdelegate] uuid];
    
    [apiRequest appendBody:uuid fieldName:@"uuid"];
    [apiRequest appendBody:data fieldName:@"json"];
    
    [apiRequest post:@"paypal/Do_express_checkout_payment_demo"
       successBlock:^(NSDictionary *result){
           NSLog(@"Do_express_checkout_payment_demo result: %@", result);
           
           int resultCode = [[result objectForKey:@"code"] intValue];
           if (resultCode == kAPI_RESULT_OK){
               NSDictionary *resultDic = [result objectForKey:@"result"];
               NSString *transactionId = [resultDic objectForKey:@"TRANSACTIONID"];
               [self paymentSuccess:transactionId];
           } else {
               [self paymentFailed];
           }
           
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);
            [self paymentFailed];
        }];
}

#pragma mark -
#pragma mark ExpressCheckoutResponseHandler methods

//In this example, we do the Express Checkout calls completely on the device.  This is not recommended because
//it requires the merchant API credentials to be stored in the app on the device, and this is a security risk.
- (void)expressCheckoutResponseReceived:(NSObject *)response {
	
//    if ([response isKindOfClass:[NSError class]]) {
//		//If we get back an error, display an alert.
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment failed" 
//														message:[(NSError *)response localizedDescription]
//													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[alert show];
//		[alert release];
//	} else if ([response isKindOfClass:[GetExpressCheckoutDetailsResponseDetails class]]) {
//		//If we get back a GetExpressCheckoutDetailsResponseDetails object, create a
//		//DoExpressCheckoutPaymentRequestDetails object and call doExpressCheckout, handling
//		//the response below.
//		GetExpressCheckoutDetailsResponseDetails *gres = (GetExpressCheckoutDetailsResponseDetails *)response;
//		
//		if (gres.PayerInfo.PayerID.length > 0) {
//			DoExpressCheckoutPaymentRequestDetails *dreq = [[[DoExpressCheckoutPaymentRequestDetails alloc] init] autorelease];
//			dreq.PayerID = gres.PayerInfo.PayerID;
//			dreq.PaymentAction = PAYMENT_ACTION_SALE;
//			for (PaymentDetails *paymentDetails in gres.PaymentDetails) {
//				[dreq addPaymentDetails:paymentDetails];
//			}
//			[[ECNetworkHandler sharedInstance] doExpressCheckoutWithRequest:dreq withDelegate:self];
//		} else {
//			[self paymentFailed];
//		}
//	} else if ([response isKindOfClass:[DoExpressCheckoutPaymentResponseDetails class]]) {
//		//If we get back a DoExpressCheckoutPaymentResponseDetails object, check for success
//		//or failure and transition to the appropriate screen.
//		DoExpressCheckoutPaymentResponseDetails *dres = (DoExpressCheckoutPaymentResponseDetails *)response;
//		
//		if (dres.PaymentInfo.count > 0 && ((PaymentInfo *)[dres.PaymentInfo objectAtIndex:0]).TransactionID.length > 0) {
//			[self paymentSuccess:((PaymentInfo *)[dres.PaymentInfo objectAtIndex:0]).TransactionID];
//		} else {
//			[self paymentFailed];
//		}
//	}
}

@end
