//
//  CartButton.h
//  caseshop
//
//  Created by Yongnam Park on 13. 1. 10..
//  Copyright (c) 2013년 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CartButtonForAddToCart,
    CartButtonForChooseOPtion,
    CartButtonForSelectOption
} CartButtonFor;

@interface CartButton : UIButton{
    
    UIImageView *cartIcon;
    
    CartButtonFor _buttonFor;
}

@property (nonatomic) CartButtonFor buttonFor;

@end
