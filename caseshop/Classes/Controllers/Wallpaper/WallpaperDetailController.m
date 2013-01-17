//
//  WallpaperDetailController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 8..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/SDImageCache.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "WallpaperDetailController.h"
#import "API.h"
#import "CSImageCache.h"
#import "AppDelegate.h"
#import "ProductDetailController.h"
#import "UIImageView+Animation.h"
#import "ToastController.h"
#import "Flurry.h"
#import "CSLoader.h"
#import "DACircularProgressView.h"


@interface WallpaperDetailController ()

@end

@implementation WallpaperDetailController
@synthesize itemId,wallpaper,original,preview;

- (void)dealloc{
    _imageView = nil;
    _preView = nil;
    _backBtn = nil;
    _previewBtn = nil;
    _downBtn = nil;
    _scrollView = nil;
    _activity = nil;
    _relateLabel = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - Button Actions

- (IBAction)backBtnTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)previewBtnTapped:(id)sender{
    [self showPreview];
}

- (void)productBtnTapped:(id)sender{
    NSInteger productId = [(UIView*)sender tag];
    
    ProductDetailController *product = [[ProductDetailController alloc] initWithNibName:@"ProductDetailController" bundle:nil];
    product.productId = productId;
    product.rightBtnHide = YES;
    [self.navigationController pushViewController:product animated:YES];
    
}

- (IBAction)saveBtnTapped:(id)sender{
    UIImage *layerImage = _imageView.image;
    
    // Save image to photo library
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library writeImageToSavedPhotosAlbum:[layerImage CGImage]
                              orientation:(ALAssetOrientation)[layerImage imageOrientation]
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              if (error) {
                                  NSLog(@"%@",error);
                                  
                              } else{
                                  NSLog(@"saved image");
                                  [ToastController showToastImage:[UIImage imageNamed:@"ToastWallpaper"]];
                                  
                                  /*
                                   * Flurry Analytics
                                   */
                                  NSDictionary *params =
                                  [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInteger:itemId], @"Wallpaper_ID", // Capture author info
                                   nil];
                                  
                                  [Flurry logEvent:@"Wallpaper_Downloaded" withParameters:params];
                              }
                              
                          }];
}

#pragma mark - Data

- (void)loadData{
    
    id this = self;
    
    
    API *apiRequest = [[API alloc] init];
    
    BOOL is_iphone5 = [[AppDelegate sharedAppdelegate] isIphone5];
    
    [apiRequest get:[NSString stringWithFormat:@"s/wallpaper?id=%d",itemId]
       successBlock:^(NSDictionary *result){
           NSLog(@"result: %@", result);
           
           _activity.hidden = YES;
           
           int resultCode = [[result objectForKey:@"code"] intValue];
           if (resultCode == kAPI_RESULT_OK){
               self.wallpaper = [result objectForKey:@"result"];
               self.products = [wallpaper objectForKey:@"related_products"];
               
               NSString *previewName = is_iphone5?@"HomeScreen_5":@"HomeScreen_4";
               self.preview = [UIImage imageNamed:previewName];
               _preView.image = self.preview;
               
               NSString *resourceDir = [wallpaper objectForKey:@"resource_dir_path"];
               NSString *originKey = is_iphone5?@"original_5_filename":@"original_4_filename";
               NSString *urlString = [NSString stringWithFormat:@"%@%@",resourceDir,[wallpaper objectForKey:originKey]];
               NSLog(@"url String: %@", urlString);
               
               [[CSLoader sharedLoader] loadRemoteImageForView:_imageView withUrl:urlString];
//               [[SDImageCache sharedImageCache] queryDiskCacheForKey:urlString done:^(UIImage *image, SDImageCacheType cacheType) {
//                   
//                   if (image){
//                       _imageView.image = image;
//                       [UIView animateWithDuration:.3
//                                        animations:^{
//                                            _imageView.alpha = 1.0f;
//                                        }];
//                   } else {
//                       DACircularProgressView *progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//                       progressView.roundedCorners = YES;
//                       progressView.progressTintColor = [UIColor colorWithRed:0.431 green:0.792 blue:0.992 alpha:1.000];
//                       progressView.trackTintColor = [UIColor lightGrayColor];
//                       progressView.center = self.view.center;
//                       [self.view addSubview:progressView];
//                       
//                       [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageDownloaderProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
//                           
//                           float pr = ((float) receivedSize / (float) expectedSize);
//                           
//                           progressView.progress = pr;
//                           
//                       } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//                           
//                           if (finished){
//                               [[SDImageCache sharedImageCache] storeImage:image forKey:urlString toDisk:YES];
//                               _imageView.image = image;
//                               [UIView animateWithDuration:.3
//                                                animations:^{
//                                                    _imageView.alpha = 1.0f;
//                                                    progressView.alpha = .0f;
//                                                }
//                                                completion:^(BOOL finished){
//                                                    [progressView removeFromSuperview];
//                                                }];
//                           }
//                           
//                       }];
//
//                   }
//               }];
               
               
               [this loadRelatedProducts];
               
               
                              
           }
           
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);
        }];
}

#define BTN_SIZE 80
#define BTN_PADDING 0
#define SCROLLVIEW_MARGIN_LEFT 10

- (void)loadRelatedProducts{
    
    int i = 0;
    for (NSDictionary *product in self.products){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((i*(BTN_SIZE+BTN_PADDING)) + SCROLLVIEW_MARGIN_LEFT , 20, BTN_SIZE, BTN_SIZE)];
        
        btn.alpha = 0.0f;
        [btn setImageWithURL:[NSURL URLWithString:[product objectForKey:@"thumb"]] forState:UIControlStateNormal];
        [btn setImageWithURL:[NSURL URLWithString:[product objectForKey:@"thumb"]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [UIView animateWithDuration:.3
                             animations:^{
                                 btn.alpha = 1.0f;
                             }];
        }];
        
        
        btn.tag = [[product objectForKey:@"products_id"] integerValue];
        [_scrollView addSubview:btn];
        
        btn.contentMode = UIViewContentModeScaleToFill;
        [btn addTarget:self action:@selector(productBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        i++;
    }
    
    CGSize size = _scrollView.contentSize;
    size.width =( self.products.count * (BTN_SIZE+BTN_PADDING)) + SCROLLVIEW_MARGIN_LEFT;
    _scrollView.contentSize = size;
    
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    _relateLabel.text = NSLocalizedString(@"RELATED CASES", nil);
    
    _hidableViews = [[NSArray alloc] initWithObjects:_backBtn,_previewBtn,_downBtn,_scrollView,_relateLabel, nil];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePreview)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_preView addGestureRecognizer:tap];

    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapped)];
    tap1.numberOfTapsRequired = 1;
    tap1.numberOfTouchesRequired = 1;
    [_imageView addGestureRecognizer:tap1];

    
    
    [self loadData];
    
    
    /*
     * Flurry Analytics
     */
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSNumber numberWithInteger:itemId], @"Wallpaper_ID", // Capture author info
     nil];
    
    [Flurry logEvent:@"Wallpaper_Detail_Viewd" withParameters:params];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
}

#pragma mark - Preview

- (void)showPreview{
    
    [UIView animateWithDuration:.3
                     animations:^{
                         _preView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [self hideControls];
}

- (void)hidePreview{
    
    [UIView animateWithDuration:.3
                     animations:^{
                         _preView.alpha = .0f;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [self showControls];
}

- (void)hideControls{
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    _scrollView.layer.shouldRasterize = YES;
    for (UIView *v in _scrollView.subviews){
        [v.layer setShouldRasterize:NO];
    }

    [UIView animateWithDuration:.3
                     animations:^{
                         for (UIView *v in _hidableViews){
                             v.alpha = .0f;
                         }

                     }
                     completion:^(BOOL finished){
                         

                     }];
}

- (void)showControls{
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    _scrollView.layer.shouldRasterize = YES;
    for (UIView *v in _scrollView.subviews){
        [v.layer setShouldRasterize:NO];
    }

    [UIView animateWithDuration:.5
                     animations:^{
                         for (UIView *v in _hidableViews){
                             v.alpha = 1.0f;
                         }
                         
//                         [_imageView animateChangeImageWithCrossFade:self.original];
                     }
                     completion:^(BOOL finished){
                         _scrollView.layer.shouldRasterize = NO;
                         
                     }];
}

- (void)imageViewTapped{
    if ([[_hidableViews objectAtIndex:0] alpha] == 0.0f){
        [self showControls];
    } else {
        [self hideControls];
    }
}

@end
