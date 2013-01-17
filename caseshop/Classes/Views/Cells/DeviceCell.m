//
//  DeviceCell.m
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 25..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "DeviceCell.h"

@implementation DeviceCell
@synthesize checkImg,activity;

- (void)dealloc{
    _titleLabel = nil;
    _iconImg = nil;
    
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

    if (selected){
        [self setBackgroundColor:[UIColor blackColor]];
    } else {
        [self setBackgroundColor:[UIColor colorWithRed:0.431 green:0.792 blue:0.992 alpha:1.000]];
    }
    
    checkImg.hidden = !selected;
    _iconImg.selected = selected;

}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context,
                                     [UIColor colorWithRed:0.545 green:0.835 blue:0.992 alpha:1.000].CGColor);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 320, 0);
    CGContextStrokePath(context);
}

- (void)setTitle:(NSString*)title icon:(UIImage*)icon iconSelected:(UIImage*)iconSelected{
    _titleLabel.text = title;
    [_iconImg setImage:icon forState:UIControlStateNormal];
    [_iconImg setImage:iconSelected forState:UIControlStateSelected];
    
    
    
    
}

@end
