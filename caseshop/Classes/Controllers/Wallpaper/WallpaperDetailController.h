//
//  WallpaperDetailController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 8..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WallpaperDetailController : UIViewController{
    IBOutlet UIImageView *_imageView;
    IBOutlet UIImageView *_preView;
    IBOutlet UIButton *_backBtn;
    IBOutlet UIButton *_previewBtn;
    IBOutlet UIButton *_downBtn;
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UIActivityIndicatorView *_activity;
    IBOutlet UILabel *_relateLabel;
    

    NSArray *_hidableViews;
}

@property (nonatomic,strong) NSDictionary *wallpaper;
@property (nonatomic,strong) NSArray *products;
@property (nonatomic,strong) UIImage *original;
@property (nonatomic,strong) UIImage *preview;
@property (nonatomic) NSInteger itemId;
@end
