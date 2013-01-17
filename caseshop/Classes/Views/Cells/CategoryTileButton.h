//
//  CategoryTileButton.h
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 26..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"
#import "CSImageCache.h"

@protocol CategoryTileBtnDelegate;
@interface CategoryTileButton : UIButton<LateLoadingProtocol>{
    IBOutlet CustomLabel *_titleLabel;
    
    UIView *_bgView;
    
}

@property (nonatomic) NSInteger categoryId;
@property (nonatomic, weak) id<CategoryTileBtnDelegate> delegate;


@end



@protocol CategoryTileBtnDelegate <NSObject>

- (void)categoryTileBtnDidSelected:(CategoryTileButton*)button;

@end