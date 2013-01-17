//
//  ProductTileButton.m
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 29..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "ProductTileButton.h"


@implementation ProductTileButton



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
//    self.alpha = .0f;
}

- (void)applyImage:(UIImage *)image{
    [self setImage:image forState:UIControlStateNormal];
    
//    [UIView animateWithDuration:.3
//                     animations:^{
//                         self.alpha = 1.0f;
//                     }];
}

@end
