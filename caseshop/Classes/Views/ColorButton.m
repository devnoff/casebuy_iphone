//
//  ColorButton.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 6..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "ColorButton.h"

@implementation ColorButton
@synthesize colorNormal,colorHighlighted;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.titleLabel setFont:[UIFont fontWithName:@"DINPro-Bold" size:self.titleLabel.font.pointSize]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor*)bgColor highlightedColor:(UIColor*)hColor{
    self = [self initWithFrame:frame];
    if (self){
        self.colorNormal = bgColor;
        self.colorHighlighted= hColor;
        self.backgroundColor = bgColor;
    }
    
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    
    if (!colorNormal){
        colorNormal = [[UIColor alloc]initWithCGColor:[UIColor colorWithRed:0.431 green:0.792 blue:0.992 alpha:1.000].CGColor];
    }
    
    if (!colorHighlighted){
        colorHighlighted = [[UIColor alloc]initWithCGColor:[UIColor colorWithRed:0.251 green:0.718 blue:0.988 alpha:1.000].CGColor];
    }
    
    self.backgroundColor = colorNormal;
    
    [self.titleLabel setFont:[UIFont fontWithName:@"DINPro-Bold" size:self.titleLabel.font.pointSize]];
    
    
    _inset = CGSizeZero;
}


- (void)setLabelInset:(CGSize)inset{
    _inset = inset;
    
    CGRect frame = self.titleLabel.frame;
    frame.origin.y += inset.height;
    self.titleLabel.frame = frame;
    
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    
    if (!(_inset.height == 0 && _inset.width == 0)){
        [self setLabelInset:_inset];
    }
    
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    if (!(_inset.height == 0 && _inset.width == 0)){
        [self setLabelInset:_inset];
    }
    
    if (highlighted){
        self.backgroundColor = colorHighlighted;
    } else {
        self.backgroundColor = colorNormal;
    }
    
    
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    
    if (!(_inset.height == 0 && _inset.width == 0)){
        [self setLabelInset:_inset];
    }
    
}

@end
