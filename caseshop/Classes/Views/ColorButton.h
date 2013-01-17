//
//  ColorButton.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 6..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorButton : UIButton{
    CGSize _inset;
}

@property (nonatomic,strong) UIColor *colorNormal;
@property (nonatomic,strong) UIColor *colorHighlighted;


- (void)setLabelInset:(CGSize)inset;

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor*)bgColor highlightedColor:(UIColor*)hColor;

@end
