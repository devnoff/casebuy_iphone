//
//  WallpaperButton.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 8..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSImageCache.h"


@interface WallpaperButton : UIButton<LateLoadingProtocol>

@property (nonatomic) NSInteger itemId;

@end

