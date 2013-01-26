//
//  CartCell.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 6..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "CartCell.h"

@implementation CartCell
@synthesize photoView,titleLabel,priceLabel,qtyButton,delegate,fbBadge;

- (void)dealloc{
    self.delegate = nil;
    _qtyBgView = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    _bgView.hidden = !selected;
}


- (void)awakeFromNib{
    [super awakeFromNib];
    
    qtyButton.colorNormal = [UIColor clearColor];
    qtyButton.colorHighlighted = [UIColor clearColor];
    
    if (_bgView==nil){
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        _bgView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView insertSubview:_bgView atIndex:0];
        _bgView.hidden = YES;
    }
    
    
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context,
                                     [UIColor colorWithWhite:0.898 alpha:1.000].CGColor);

    CGContextMoveToPoint(context, 0, 60);
    CGContextAddLineToPoint(context, 320, 60);
    CGContextStrokePath(context);
}

- (IBAction)qtyBtnTapped:(id)sender{
    
    if (_qtyBgView.hidden){
        [self showQtyView];
    } else {
        [self hideQtyView];
    }
}

- (IBAction)doneBtnTapped:(id)sender{
    [self hideQtyView];
    
    
    
}

- (void)setQty:(NSString*)qty{
    [self.qtyButton setTitle:qty forState:UIControlStateNormal];
    
    [self layoutQtyLabel];
}

- (void)showQtyView{
    _qtyBgView.hidden = NO;
    [UIView animateWithDuration:.3
                     animations:^{
                         _qtyBgView.alpha = 1.0f;
                         [qtyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                     }
                     completion:^(BOOL finished){
                         if (delegate && [delegate respondsToSelector:@selector(cartCellDidStartEditing:)])
                             [delegate cartCellDidStartEditing:self];
                     }];
}

- (void)hideQtyView{
    
    if (delegate && [delegate respondsToSelector:@selector(cartCellShouldUpdate:)])
        [delegate cartCellShouldUpdate:self];
    
    [UIView animateWithDuration:.3
                     animations:^{
                         _qtyBgView.alpha = .0f;
                         [qtyButton setTitleColor:[UIColor colorWithRed:0.306 green:0.682 blue:0.984 alpha:1.000] forState:UIControlStateNormal];
                     }
                     completion:^(BOOL finished){
                         _qtyBgView.hidden = YES;
                     }];
}

- (void)showQtyEdit:(BOOL)show{
    if (show){
        [self showQtyView];
    } else{
        [self hideQtyView];
    }
}

- (IBAction)plusQty{
    int qty = [qtyButton.titleLabel.text intValue];
    
    qty++;
    
    [qtyButton setTitle:[NSString stringWithFormat:@"%d",qty] forState:UIControlStateNormal];
    
    [self layoutQtyLabel];
}

- (IBAction)minusQty{
    int qty = [qtyButton.titleLabel.text intValue];
    
    if (qty>1)
        qty--;
    
    [qtyButton setTitle:[NSString stringWithFormat:@"%d",qty] forState:UIControlStateNormal];
    
    [self layoutQtyLabel];
}

- (void)layoutQtyLabel{
    NSString *qty = [qtyButton titleForState:UIControlStateNormal];
    
    CGSize size = [qty sizeWithFont:qtyButton.titleLabel.font];
    
    UIEdgeInsets inset = UIEdgeInsetsZero;
    inset = UIEdgeInsetsMake(0, 0, 0, size.width/2);
    
    [qtyButton setContentEdgeInsets:inset];
    
}


- (void)shouldStartEditing{
    [UIView animateWithDuration:.3
                     animations:^{
                         qtyButton.alpha = .0f;
                     }
                     completion:^(BOOL finished){
                         qtyButton.hidden = YES;
                     }];
}

- (void)shouldEndEditing{
    [UIView animateWithDuration:.3
                     animations:^{
                         qtyButton.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         qtyButton.hidden = NO;
                     }];
}


- (void)applyImage:(UIImage *)image{
    self.photoView.image = image;
}

@end
