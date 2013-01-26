//
//  ProductDetailController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 30..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/SDImageCache.h>
#import <QuartzCore/QuartzCore.h>
#import "ProductDetailController.h"
#import "API.h"
#import "CSImageCache.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "CurrencyHelper.h"
#import "WallpaperController.h"
#import "WallpaperDetailController.h"
#import "Flurry.h"
#import "CSLoader.h"
#import "ZoomGuideController.h"
#import "ColorButton.h"
#import "FBNativeDialogs.h"
#import "FacebookSDK.h"


#define PRODUCT_DONT_HAVE_OPTION -1

@interface ProductDetailController ()

@end

@implementation ProductDetailController
@synthesize productId,rightBtnHide;

- (void)dealloc{
    _scrollView = nil;
    _pageControl = nil;
    _wallpaperBtn = nil;
    _activity = nil;
    _descLabel = nil;
    _productOptions = nil;
    _movingViews = nil;
    _fbActivity = nil;
    _facebookBtn = nil;
    _fbCntLabel = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


#pragma mark - Facebook Like

- (void)updateLikeCount{
    
    API *apiRequest = [[API alloc] init];
    
    [apiRequest appendBody:[NSString stringWithFormat:@"%d",self.productId] fieldName:@"products_id"];
    
    [apiRequest post:@"s/likeUp"
        successBlock:^(NSDictionary* result){
            NSLog(@"%@", result);
            int resultCode = [[result objectForKey:@"code"] intValue];
            if (resultCode == kAPI_RESULT_OK){
                NSNumber *data = [result objectForKey:@"result"];
                [self setLikeCount:data.integerValue];
            }
        }
         failureBock:^(NSError *error){

         }];

}

- (BOOL)isLikedItem{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSArray *items = [def arrayForKey:kLIKED_ITEMS];
    
    for (NSNumber *itemId in items){
        if (itemId.integerValue == productId){
            return YES;
        }
    }
    
    return NO;
}

- (void)setLikeCount:(NSInteger)count{
    
    
    NSString *cnt = [NSString stringWithFormat:@"%d",count];
    
    CGSize size = [cnt sizeWithFont:_fbCntLabel.font];
    size.width += 12;
    
    CGRect boxRect = _fbCntLabel.frame;
    boxRect.size.width = size.width;
    boxRect.origin.x = _facebookBtn.frame.origin.x - boxRect.size.width + 3;
    
    _fbCntLabel.text = cnt;
    
    [UIView animateWithDuration:.3
                     animations:^{
                         _fbCntLabel.frame = boxRect;
                         _fbCntLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:.3
                                          animations:^{
                                              _fbCntLabel.transform = CGAffineTransformMakeScale(1, 1);
                                          }
                                          completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    
    
    
}

static bool _fbReqesting = false;

- (void)publishStory
{
    
    NSString *msg = [NSString stringWithFormat:@"%@ %@ %@ %@",_titleLabel.text, _deviceLabel.text, _priceLabel.text, NSLocalizedString(@"I like it!", nil)];
    
    NSString *linkUrl = [NSString stringWithFormat:IS_LOCALE_KO?@"http://casebuy.me/ko/index.php/shop/product?id=%d":@"http://casebuy.me/en/index.php/shop/product?id=%d",self.productId];
    NSString *thumbUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,[[_images objectAtIndex:_currPage] objectForKey:@"file_path"]];
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       linkUrl, @"link",
                                       thumbUrl, @"picture",
                                       msg,@"message",
                                       nil];
    
    
    
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
             
             // Show the result in an alert
             [[[UIAlertView alloc] initWithTitle:@"Result"
                                         message:alertText
                                        delegate:self
                               cancelButtonTitle:@"OK!"
                               otherButtonTitles:nil]
              show];
             
         } else {
             alertText = @"Posted successfully.";
             
             NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
             NSMutableArray *items = [NSMutableArray arrayWithArray:[def arrayForKey:kLIKED_ITEMS]];
             [items addObject:[NSNumber numberWithInteger:productId]];
             [def setObject:items forKey:kLIKED_ITEMS];
             [def synchronize];
             _facebookBtn.enabled = NO;
             
             [self updateLikeCount];
             
         }
         
         [_fbActivity stopAnimating];
         
         _fbReqesting = false;
     }];
}

#pragma mark - Button Actions

- (IBAction)facebookBtnTapped:(id)sender{
    
    if (_fbReqesting)
        return;
    
    _fbReqesting = true;
    
    [_fbActivity startAnimating];
    _fbActivity.hidden = NO;
    
    NSArray *permission =
    [NSArray arrayWithObjects:@"email", nil];
    
    [FBSession openActiveSessionWithReadPermissions:permission
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      
                                      if (status == FBSessionStateOpen){
                                          /* handle success + failure in block */
                                          // can include any of the "publish" or "manage" permissions
                                          NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions", nil];
                                          
                                          [session reauthorizeWithPublishPermissions:permissions
                                                                     defaultAudience:FBSessionDefaultAudienceFriends
                                                                   completionHandler:^(FBSession *session, NSError *error) {
                                                                       /* handle success + failure in block */
                                                                       if (!error) {
                                                                           // If permissions granted, publish the story
                                                                           [self publishStory];
                                                                       } else {
                                                                           [[[UIAlertView alloc] initWithTitle:@"Result"
                                                                                                       message:error.debugDescription
                                                                                                      delegate:self
                                                                                             cancelButtonTitle:@"OK!"
                                                                                             otherButtonTitles:nil]
                                                                            show];
                                                                       }
                                                                   }];
                                      }
                                     
                                  
                                  }];
    
    
    


    return;
    
    NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:IS_LOCALE_KO?@"http://casebuy.me/ko/index.php/shop/product?id=%d":@"http://casebuy.me/en/index.php/shop/product?id=%d",self.productId]]];
    
    NSString *url = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];

    UIImage *photo = [(PhotoZoomView*)[_zoomViews objectAtIndex:_currPage] photoView].image;
    
    NSString *msg = [NSString stringWithFormat:@"%@ %@ %@ %@",_titleLabel.text, _deviceLabel.text, _priceLabel.text, NSLocalizedString(@"I like it!", nil)];
    
    BOOL displayedNativeDialog =
    [FBNativeDialogs
     presentShareDialogModallyFrom:self
     initialText:msg
     image:nil
     url:[NSURL URLWithString:[NSString stringWithFormat:IS_LOCALE_KO?@"http://casebuy.me/ko/index.php/shop/product?id=%d":@"http://casebuy.me/en/index.php/shop/product?id=%d",self.productId]]
     handler:^(FBNativeDialogResult result, NSError *error) {
         if (error) {
             /* handle failure */
         } else {
             if (result == FBNativeDialogResultSucceeded) {
                 /* handle success */
             } else {
                 /* handle user cancel */
             }
         }
     }];
    if (!displayedNativeDialog) {
        /*
         Fallback to web-based Feed Dialog:
         https://developers.facebook.com/docs/howtos/feed-dialog-using-ios-sdk/
         */
    }
}

- (IBAction)backBtnTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)wallpaperBtnTapped:(id)sender{
    
//    if(_wallpapers.count > 0){
//        _wallpaperWillOpen = YES;
//        
//        WallpaperDetailController *wallpaper = [[WallpaperDetailController alloc] initWithNibName:@"WallpaperDetailController" bundle:nil];
//        wallpaper.itemId = [[[_wallpapers objectAtIndex:0] objectForKey:@"id"] integerValue];
//        [self.navigationController pushViewController:wallpaper animated:YES];
//        [wallpaper release];
//        
//    } else {
//        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"CASEBUY"
//                                                         message:NSLocalizedString(@"No related wallpaper exist. :(", nil)
//                                                        delegate:self
//                                               cancelButtonTitle:NSLocalizedString(@"OKAY",nil)
//                                               otherButtonTitles:nil] autorelease];
//        
//        [alert show];
//    }
    
    if(_wallpapers.count > 0){
        WallpaperController *wall = [[WallpaperController alloc] initWithNibName:@"WallpaperController" bundle:nil];
        wall.relatedCaseId = self.productId;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:wall];
        nav.hidesBottomBarWhenPushed = YES;
        nav.modalTransitionStyle = UIModalTransitionStylePartialCurl;
        
        
        [self presentViewController:nav animated:YES completion:nil];

        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CASEBUY"
                                                         message:NSLocalizedString(@"No related wallpaper exist. :(", nil)
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"OKAY",nil)
                                               otherButtonTitles:nil];
        
        [alert show];
    }
    
    
    /*
     * Flurry Analytics
     */
    [Flurry logEvent:@"Product_WallpaperBtn_Tapped"];
    
}

- (IBAction)cartBtnTapped:(id)sender{
    
    if (![[_productInfo objectForKey:@"sales_state"] isEqualToString:@"SALE"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CASEBUY"
                                                         message:NSLocalizedString(@"Temporarily out of stock", nil)
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"OKAY",nil)
                                               otherButtonTitles:nil];
        
        [alert show];
        
        return;
    }
    
    if (_cartButton.buttonFor == CartButtonForAddToCart){
        [self addToCartWithOption:PRODUCT_DONT_HAVE_OPTION];
    } else {
        
        if (_descLabel.hidden)
            [self showProductOptions];
        else{
            [self layoutDescHiding];
            [self performSelector:@selector(showProductOptions) withObject:nil afterDelay:.3];
        }
            
    
    }

    
    
}



#pragma mark - Product Options
#define OPTION_BUTTON_HEIGHT 50

- (void)optionButtonTapped:(UIButton*)sender{
    int idx = sender.tag;
    [self addToCartWithOption:idx];
}

- (void)initProductOption{
    
    int i = 0;
    int originY = self.view.frame.size.height;
    for (NSDictionary *option in _productOptions){
        ColorButton *optionBtn = [[ColorButton alloc] initWithFrame:CGRectMake(0, originY+(i*OPTION_BUTTON_HEIGHT), 320, OPTION_BUTTON_HEIGHT)
                                                    backgroundColor:[UIColor colorWithWhite:(0+(i*0.1)) alpha:.8]
                                                   highlightedColor:[UIColor colorWithWhite:(0+(i*0.1)) alpha:1]];
        [optionBtn setTitle:[[option objectForKey:@"option_name"] uppercaseString] forState:UIControlStateNormal];
        optionBtn.tag = i; // 인덱스
        [optionBtn addTarget:self action:@selector(optionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:optionBtn];
        [_movingViews addObject:optionBtn];
        
        i++;
    }
}

- (void)showProductOptions{
    
    if (_optionShowing)
        return;
    _optionShowing = YES;
    
    
    
    int movingHeight = _productOptions.count * OPTION_BUTTON_HEIGHT;
    [UIView animateWithDuration:.3
                     animations:^{
                     
                         for (UIView *v in _movingViews){
                             CGRect r = v.frame;
                             r.origin.y -= movingHeight;
                             v.frame = r;
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         [_cartButton removeTarget:self action:@selector(cartBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
                         [_cartButton addTarget:self action:@selector(hideProductOptions) forControlEvents:UIControlEventTouchUpInside];
                         
                     }];
}

- (void)hideProductOptions{
    
    if (!_optionShowing)
        return;
    _optionShowing = NO;
    
    int movingHeight = _productOptions.count * OPTION_BUTTON_HEIGHT;
    [UIView animateWithDuration:.3
                     animations:^{
                         
                         for (UIView *v in _movingViews){
                             CGRect r = v.frame;
                             r.origin.y += movingHeight;
                             v.frame = r;
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         [_cartButton removeTarget:self action:@selector(hideProductOptions) forControlEvents:UIControlEventTouchUpInside];
                         [_cartButton addTarget:self action:@selector(cartBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
                     }];
}

#pragma mark - Actions



- (void)addToCartWithOption:(NSInteger)optionIdx{
    
    
    [self showBlackLoadingMask];
    
    NSString *uuid = [[AppDelegate sharedAppdelegate] uuid];
    
    API *apiRequest = [[API alloc] init];
    
    [apiRequest appendBody:uuid fieldName:@"uuid"];
    [apiRequest appendBody:[NSString stringWithFormat:@"%d",productId] fieldName:@"products_id"];
    
    if (optionIdx != PRODUCT_DONT_HAVE_OPTION){
        NSString *option = [[_productOptions objectAtIndex:optionIdx] objectForKey:@"option_name"];
        [apiRequest appendBody:option fieldName:@"option_name"];
    }
    
    [apiRequest post:@"s/addToCart"
        successBlock:^(NSDictionary* result){
            NSLog(@"%@", result);
            int resultCode = [[result objectForKey:@"code"] intValue];
            if (resultCode == kAPI_RESULT_OK){
//                _cartItem = YES;
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CASEBUY",nil)
                                                                 message:NSLocalizedString(@"Successfully added to cart. Do you want to go cart?",nil)
                                                                delegate:self
                                                       cancelButtonTitle:NSLocalizedString(@"No, Thanks",nil)
                                                       otherButtonTitles:NSLocalizedString(@"GO TO CART", nil),nil];
                
                [alert show];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kCART_COUNT_UPDATE_NOTIFICATION object:nil];
            }
            [self hideBlackLoadingMask];
            
        }
         failureBock:^(NSError *error){
             [self hideBlackLoadingMask];
         }];
    
    
    /*
     * Flurry Analytics
     */
    [Flurry logEvent:@"Product_CartBtn_Tapped"];
}

#pragma mark - Layout

- (void)resizeLayout{
    
}

#pragma mark - Data

- (void)loadProductImages{
    
    if (!_images || _images.count < 1) return;
    
    CGRect frame = _scrollView.frame;
    frame.origin.y = 0;
    frame.size.height = _scrollView.frame.size.height - 49;
    
    int idx = 0;
    for (NSDictionary *img in _images){
        NSString *imgPath = [NSString stringWithFormat:@"%@%@",BASE_URL,[img objectForKey:@"file_path"]];
        
        
       
        frame.origin.x = idx * frame.size.width;
        
        PhotoZoomView *scrollView = [[PhotoZoomView alloc] initWithFrame:frame];

        scrollView.scrollEnabled = YES;
        scrollView.delegate = self;
        scrollView.bounces = NO;
        scrollView.alwaysBounceVertical = NO;
		scrollView.alwaysBounceHorizontal = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        scrollView.clipsToBounds = NO;
        scrollView.scrollsToTop = NO;
        scrollView.maximumZoomScale = 2;
        scrollView.minimumZoomScale = 1;
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

        
        [_scrollView addSubview:scrollView];
        [_zoomViews addObject:scrollView];

        [[CSLoader sharedLoader] loadRemoteImageForView:scrollView.photoView withUrl:imgPath];
//        [[SDImageCache sharedImageCache] queryDiskCacheForKey:imgPath done:^(UIImage *image, SDImageCacheType cacheType) {
//            if (image){
//                scrollView.photoView.image = image;
//                [UIView animateWithDuration:.3
//                                 animations:^{
//                                     scrollView.photoView.alpha = 1.0f;
//                                 }];
//
//            } else {
//                DACircularProgressView *progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//                progressView.roundedCorners = YES;
//                progressView.progressTintColor = [UIColor colorWithRed:0.431 green:0.792 blue:0.992 alpha:1.000];
//                progressView.trackTintColor = [UIColor lightGrayColor];
//                progressView.center = scrollView.center;
//                [scrollView addSubview:progressView];
//                
//                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imgPath] options:SDWebImageDownloaderProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
//                    
//                    float pr = ((float) receivedSize / (float) expectedSize);
//                    
//                    progressView.progress = pr;
//                    
//                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//                    
//                    if (finished){
//                        [[SDImageCache sharedImageCache] storeImage:image forKey:imgPath toDisk:YES];
//                        scrollView.photoView.image = image;
//                        [UIView animateWithDuration:.3
//                                         animations:^{
//                                             scrollView.photoView.alpha = 1.0f;
//                                             progressView.alpha = .0f;
//                                         }
//                                         completion:^(BOOL finished){
//                                             [progressView removeFromSuperview];
//                                         }];
//                    }
//                    
//                }];
//
//            }
//        }];
        
                
        
        idx++;
    }
    
    CGSize size = CGSizeMake(self.view.bounds.size.width * _images.count, frame.size.height - 20);
    _scrollView.contentSize = size;
    
    _pageControl.numberOfPages = _images.count;
    
    
    [UIView animateWithDuration:.4
                     animations:^{
                         _scrollView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)loadData{
    API *apiRequest = [[API alloc] init];
    
    NSString *uuid = [[AppDelegate sharedAppdelegate] uuid];
    
    [apiRequest get:[NSString stringWithFormat:@"s/product?products_id=%d&uuid=%@",productId,uuid]
       successBlock:^(NSDictionary *result){
           NSLog(@"result: %@", result);
           
           int resultCode = [[result objectForKey:@"code"] intValue];
           if (resultCode == kAPI_RESULT_OK){
               NSDictionary *product = [[result objectForKey:@"result"] objectForKey:@"product"];
               
               NSNumber *likes = [product objectForKey:@"likes"];
               [self setLikeCount:likes.integerValue];
               
               [_productInfo removeAllObjects];
               [_productInfo addEntriesFromDictionary:product];
               
               NSArray *images = [product objectForKey:@"product_images"];
               [_images removeAllObjects];
               if ([NSNull null] != (NSNull*)images && images.count > 0)
                   [_images addObjectsFromArray:images];
               
               
               _descLabel.text = [[product objectForKey:@"app_description"] uppercaseString];
               if ( _descLabel.text.length > 0)
                   [self layoutDescShowing];
               
               _deviceLabel.text = [[product objectForKey:@"sub_title"] uppercaseString];
               _titleLabel.text = [[product objectForKey:@"title"] uppercaseString];
               _priceLabel.text = [CurrencyHelper formattedString:[NSNumber numberWithFloat:[[product objectForKey:@"sales_price"] floatValue]]
                                                   withIdentifier:IDENTIFIED_LOCALE];
               
               [_wallpapers removeAllObjects];
               NSArray *ws = [[result objectForKey:@"result"] objectForKey:@"wallpapers"];
               if (ws)
                   [_wallpapers addObjectsFromArray:ws];
               
               
               NSString *state = [product objectForKey:@"sales_state"];
               if ([state isEqualToString:@"TEMP_OUT"]){
                   _cartButton.enabled = NO;
               }
               
               _cartItem = [[[result objectForKey:@"result"] objectForKey:@"is_cartItem"] boolValue];
               
               [self loadProductImages];
               
               _activity.hidden = YES;
               
               /* Zoom Guide */
               NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
               if (![def boolForKey:@"zoom_guide_shown"]){
                   [ZoomGuideController showGuideForView:self.navigationController.view];
                   [def setBool:YES forKey:@"zoom_guide_shown"];
               }
               
               
               // 상품 옵션
               NSArray *options = [[result objectForKey:@"result"] objectForKey:@"product_options"];
               [_productOptions removeAllObjects];
               [_productOptions addObjectsFromArray:options];
               
               if (_productOptions.count > 0){
                   [self initProductOption];
                   [_cartButton setButtonFor:CartButtonForChooseOPtion];
                   
               } else {
                   [_cartButton setButtonFor:CartButtonForAddToCart];
               }
               
               /*
                * Flurry Analytics
                */
               NSDictionary *params =
               [NSDictionary dictionaryWithObjectsAndKeys:
                _titleLabel.text, @"Product_Name", // Capture author info
                nil];
               
               [Flurry logEvent:@"Product_Detail_Viewed" withParameters:params];
           }
           
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);
        }];
}



#pragma mark - View Life Cycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    _wallpaperWillOpen = NO;
}

- (void)viewShouldRefresh{
    [super viewShouldRefresh];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (rightBtnHide){
        _wallpaperBtn.hidden = YES;
    }
    
    _zoomViews = [[NSMutableArray alloc] init];
    _images = [[NSMutableArray alloc] init];
    _productInfo = [[NSMutableDictionary alloc] init];
    _wallpapers = [[NSMutableArray alloc] init];
    _productOptions = [[NSMutableArray alloc] init];
    _movingViews = [[NSMutableArray alloc] init];
    
    
    CGRect frame = self.navigationController.view.bounds;
    frame.origin = CGPointMake(0, 0);
    self.view.frame = frame;
    
    [self loadData];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(layoutDescShowing)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    _titleLabel.userInteractionEnabled = YES;
    [_titleLabel addGestureRecognizer:tap];
    
    
    // 옵션 선택 시 움직이는 뷰
    [_movingViews addObject:_deviceLabel];
    [_movingViews addObject:_titleLabel];
    [_movingViews addObject:_priceLabel];
    [_movingViews addObject:_cartButton];
    
    
    // 라이크 한 상품일 경우 버튼 비활성화
    if ([self isLikedItem]){
        _facebookBtn.enabled = NO;
    }
    

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (!_wallpaperWillOpen)
        [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger) currPage{
    return (_scrollView.contentOffset.x/_scrollView.contentSize.width)*([_images count]);
}


#pragma mark - Descriptions

- (void)layoutDescShowing{
    
    if (_descShowing) return;
    
    _descShowing = YES;
    
    NSString *desc = _descLabel.text;
    CGSize descSize = [desc sizeWithFont: _descLabel.font constrainedToSize:CGSizeMake(320-30, 999)];
    descSize.height += 15;
    CGRect descRect = _descLabel.frame;
    descRect.size = descSize;
    descRect.origin.x = 15;
    descRect.origin.y = self.view.frame.size.height - 49 - 15 - descRect.size.height;
    _descLabel.frame = descRect;
    
    
    _descLabel.hidden = NO;
    [UIView animateWithDuration:.3
                     animations:^{
                         CGRect deviceRect = _deviceLabel.frame;
                         deviceRect.origin.y -= descRect.size.height;
                         _deviceLabel.frame = deviceRect;
                         
                         CGRect titleRect = _titleLabel.frame;
                         titleRect.origin.y -= descRect.size.height;
                         _titleLabel.frame = titleRect;
                         
                         CGRect priceRect = _priceLabel.frame;
                         priceRect.origin.y -= descRect.size.height;
                         _priceLabel.frame = priceRect;
                         
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:.2
                                          animations:^{
                                              
                                              _descLabel.alpha = 1.0f;
                                          }
                                          completion:^(BOOL finished){
                                              
                                          }];
                     }];
}

- (void)layoutDescHiding{
    
    if (!_descShowing) return;
    
    _descShowing = NO;
    
    NSString *desc = _descLabel.text;
    CGSize descSize = [desc sizeWithFont: _descLabel.font constrainedToSize:CGSizeMake(320-30, 999)];
    descSize.height += 15;
    CGRect descRect = _descLabel.frame;
    descRect.size = descSize;
    descRect.origin.x = 15;
    descRect.origin.y = self.view.frame.size.height - 49 - 15 - descRect.size.height;
    
    [UIView animateWithDuration:.2
                     animations:^{
                         _descLabel.alpha = .0f;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:.3
                                          animations:^{
                                              CGRect deviceRect = _deviceLabel.frame;
                                              deviceRect.origin.y += descRect.size.height;
                                              _deviceLabel.frame = deviceRect;
                                              
                                              CGRect titleRect = _titleLabel.frame;
                                              titleRect.origin.y += descRect.size.height;
                                              _titleLabel.frame = titleRect;
                                              
                                              CGRect priceRect = _priceLabel.frame;
                                              priceRect.origin.y += descRect.size.height;
                                              _priceLabel.frame = priceRect;
                                              
                                          }
                                          completion:^(BOOL finished){
                                              _descLabel.hidden = YES;
                                          }];
                     }];
}

#pragma mark - UIScrollViewDelegate

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if (![_scrollView isEqual:scrollView]){
        UIView *view = [scrollView.subviews objectAtIndex:0];
        return view;
    }
    return nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int currPage = [self currPage];
    
    if (currPage != _currPage){
        [[_zoomViews objectAtIndex:_currPage] setZoomScale:1 animated:YES];
        _currPage = currPage;
        _pageControl.currentPage = _currPage;
        
    }
    
    if (_descLabel.alpha == 1.0){
        [self layoutDescHiding];
    }
    
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *answer = [alertView buttonTitleAtIndex:buttonIndex];
    if ([answer isEqualToString:NSLocalizedString(@"ADD ONE MORE", nil)]){
        [self addToCartWithOption:PRODUCT_DONT_HAVE_OPTION];
    }
    
    else if ([answer isEqualToString:NSLocalizedString(@"GO TO CART", nil)]){
//        [self.navigationController popToRootViewControllerAnimated:YES];
        [(MainViewController*)[[[AppDelegate sharedAppdelegate] window]rootViewController] showCart];
    }
}





@end
