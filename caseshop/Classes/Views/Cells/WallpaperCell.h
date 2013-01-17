//
//  WallpaperCell.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 8..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WallpaperButton.h"
#import "CSImageCache.h"

#define PRODUCT_ID_INVALID 0

@interface WallpaperCell : UITableViewCell<DoubleColoumCellProtocol>{

}

@property (nonatomic,strong) WallpaperButton<LateLoadingProtocol> *leftBtn;
@property (nonatomic,strong) WallpaperButton<LateLoadingProtocol> *rightBtn;

@end
