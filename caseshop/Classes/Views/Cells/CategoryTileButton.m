//
//  CategoryTileButton.m
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 26..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "CategoryTileButton.h"

@implementation CategoryTileButton
@synthesize delegate,categoryId;

- (void)dealloc{
    self.delegate = nil;
    _titleLabel = nil;
}


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
    
    if (!_bgView){
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _bgView.backgroundColor = [UIColor colorWithRed:0.431 green:0.792 blue:0.992 alpha:0.5];
        [self insertSubview:_bgView belowSubview:_titleLabel];
        
        _bgView.hidden = YES;
    }
    
    [self addTarget:self action:@selector(tileButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state{
    
    [super setBackgroundImage:image forState:state];
    
//    [UIView animateWithDuration:.3
//                     animations:^{
//                         self.alpha = 1.0f;
//                     }];
}


- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    
    CGSize size = [title sizeWithFont:_titleLabel.font];
    size.width += 24;
    size.height += 6;
    
    CGRect frame = self.frame;
    frame.origin.x = (frame.size.width - size.width) / 2.0;
    frame.origin.y = (frame.size.height - size.height) / 2.0;
    frame.size = size;
    
    _titleLabel.frame = frame;
    _titleLabel.text = title;

}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
//    if (highlighted)
//        _titleLabel.backgroundColor = [UIColor colorWithRed:0.431 green:0.792 blue:0.992 alpha:1.000];
//    else
//        _titleLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:.75];
    _bgView.hidden = !highlighted;
    
}

- (void)tileButtonTapped:(id)sender{
    if (delegate && [delegate respondsToSelector:@selector(categoryTileBtnDidSelected:)]){
        [delegate categoryTileBtnDidSelected:self];
    }
}


- (void)applyImage:(UIImage *)image{
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [UIView animateWithDuration:.3
                     animations:^{
                         self.alpha = 1.0f;
                     }];
}


@end
