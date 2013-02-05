//
//  ProductDetailController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 30..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "BaseViewController.h"
#import "PhotoZoomView.h"
#import "CustomLabel.h"
#import "CartButton.h"

@interface ProductDetailController : BaseViewController<UIScrollViewDelegate>{
    IBOutlet UIView *_descBg;
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UIPageControl *_pageControl;
    IBOutlet CustomLabel *_deviceLabel;
    IBOutlet CustomLabel *_titleLabel;
    IBOutlet CustomLabel *_priceLabel;
    IBOutlet CustomLabel *_descLabel;
    IBOutlet CartButton *_cartButton;
    IBOutlet UIButton *_wallpaperBtn;
    IBOutlet UIActivityIndicatorView *_activity;
    IBOutlet UIActivityIndicatorView *_fbActivity;
    IBOutlet UIButton *_facebookBtn;
    IBOutlet UILabel *_fbCntLabel;

    NSMutableArray *_zoomViews;
    
    NSMutableArray *_images;
    
    int _currPage;
    
    BOOL _cartItem;
    
    NSMutableDictionary *_productInfo;
    
    NSMutableArray *_wallpapers;
    
    NSMutableArray *_productOptions;
    
    NSMutableArray *_movingViews;
    
    NSMutableArray *_descImages;
    
    // Flags
    BOOL _wallpaperWillOpen;
    BOOL _descShowing;
    BOOL _optionShowing;
}

@property (nonatomic) NSInteger productId;
@property (nonatomic) BOOL rightBtnHide;

@end
 