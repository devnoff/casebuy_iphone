//
//  ProductListCell.m
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 29..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "ProductListCell.h"

#define RIGHT_MARGIN 10
#define LABEL_PADDING_HR 6
#define LABEL_PADDING_VR 0
#define LABEL_ORIGIN_Y 122
@implementation ProductListCell
@synthesize photoView=_photoView;

- (void)dealloc{
    _photoView = nil;
    _titleLabel = nil;
    _priceLabel = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
//    self.alpha = .0f;
    
    if (!_bgView){
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _bgView.backgroundColor = [UIColor colorWithRed:0.431 green:0.792 blue:0.992 alpha:0.5];
        [self.contentView insertSubview:_bgView aboveSubview:_photoView];
        
        _bgView.hidden = YES;
    

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];


}

- (void)setTitle:(NSString*)title price:(NSString*)price photo:(UIImage*)photo{
    // 타이틀 위치 조정
    UIFont * font = [_titleLabel font];
    CGSize tsize = [title.uppercaseString sizeWithFont:font];
    tsize.width += (LABEL_PADDING_HR*2);
    tsize.height += (LABEL_PADDING_VR*2);
    
    CGRect tframe = _titleLabel.frame;
    tframe.origin = CGPointMake(320 - RIGHT_MARGIN - tsize.width, LABEL_ORIGIN_Y);
    tframe.size = tsize;
    
    _titleLabel.frame = tframe;
    _titleLabel.text = title.uppercaseString;
    
    // 가격 위치 조정
    CGSize psize = [price sizeWithFont:font];
    psize.width += (LABEL_PADDING_HR*2);
    psize.height += (LABEL_PADDING_VR*2);
    
    CGRect pframe = _priceLabel.frame;
    pframe.origin = CGPointMake(320 - RIGHT_MARGIN - psize.width, LABEL_ORIGIN_Y + tframe.size.height);
    pframe.size = psize;
    
    _priceLabel.frame = pframe;
    _priceLabel.text = price;
    
    //    // 사진
    //    _photoView.image = photo;
}


- (void)applyImage:(UIImage *)image{
    _photoView.image = image;
    _photoView.alpha = 1.0f;
    //    [UIView animateWithDuration:.3
    //                     animations:^{
    //                         _photoView.alpha = 1.0f;
    //                     }];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    _bgView.hidden = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    _bgView.hidden = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    _bgView.hidden = YES;
}
@end
