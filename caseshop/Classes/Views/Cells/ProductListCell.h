//
//  ProductListCell.h
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 29..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"
#import "CSImageCache.h"


@interface ProductListCell : UITableViewCell<LateLoadingProtocol>{
    IBOutlet UIImageView *_photoView;
    IBOutlet CustomLabel *_titleLabel;
    IBOutlet CustomLabel *_priceLabel;
    
    UIView *_bgView;
    
}

@property (nonatomic,strong) UIImageView *photoView;


- (void)setTitle:(NSString*)title price:(NSString*)price photo:(UIImage*)photo;

@end
