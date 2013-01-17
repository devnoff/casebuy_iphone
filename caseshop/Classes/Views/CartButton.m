//
//  CartButton.m
//  caseshop
//
//  Created by Yongnam Park on 13. 1. 10..
//  Copyright (c) 2013년 CultStory Inc. All rights reserved.
//

#import "CartButton.h"

#define CART_ICON_PADDING_RIGHT 5

@implementation CartButton
@synthesize buttonFor=_buttonFor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initStyle];
    }
    return self;
}



- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self initStyle];
    
    [self setButtonFor:_buttonFor];
}

- (void)initStyle{
    // 장바구니 아이콘
    UIImage *cart = [UIImage imageNamed:@"Cart_Icon"];
    if (!cartIcon){
        cartIcon = [[UIImageView alloc] initWithFrame:CGRectMake(((self.frame.size.width - cart.size.width)/2)-CART_ICON_PADDING_RIGHT , (self.frame.size.height - cart.size.height)/2, cart.size.width, cart.size.height)];
        cartIcon.image = cart;
        [self addSubview:cartIcon];
    }
    
    // 글꼴
    self.titleLabel.font = [UIFont fontWithName:@"DINPro-Bold" size:16];
    
    // 색상
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}



- (void)setButtonFor:(CartButtonFor)buttonFor_{
    
    _buttonFor = buttonFor_;
    
    if (buttonFor_ == CartButtonForAddToCart){
        [self setTitle:NSLocalizedString(@"ADD TO CART", nil) forState:UIControlStateNormal];
    } else {
        [self setTitle:NSLocalizedString(@"ADD TO CART WITH OPTION", nil) forState:UIControlStateNormal];
    }
    
    CGSize size = [[self titleForState:UIControlStateNormal] sizeWithFont:self.titleLabel.font];
    
    CGRect iconRect = cartIcon.frame;
    iconRect.origin.x = ((self.frame.size.width - size.width)/2) - iconRect.size.width - CART_ICON_PADDING_RIGHT;
    cartIcon.frame = iconRect;
    

}



//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    // Drawing code
//    
//    UIImage *cart = [UIImage imageNamed:@"Cart_Icon"];
////    [cart drawInRect:CGRectMake((self.frame.size.width - cart.size.width)/2, (self.frame.size.height - cart.size.height)/2, cart.size.width, cart.size.height)];
//    [cart drawInRect:rect];
//}


@end
