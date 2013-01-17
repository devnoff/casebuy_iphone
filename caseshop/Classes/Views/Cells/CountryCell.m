//
//  CountryCell.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 7..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "CountryCell.h"

@implementation CountryCell
@synthesize nameLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        CGRect rect = frame;
        rect.origin.x += 15;
        rect.size.width -= 15;
        nameLabel = [[UILabel alloc] initWithFrame:rect];
        nameLabel.textAlignment = UITextAlignmentLeft;
        nameLabel.font = [UIFont fontWithName:@"DINPro-Bold" size:17];
        nameLabel.textColor = [UIColor colorWithWhite:0.447 alpha:1.000];
        nameLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:nameLabel];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected){
        self.backgroundColor = [UIColor colorWithRed:0.431 green:0.792 blue:0.992 alpha:1.000];
        [self.nameLabel setTextColor:[UIColor whiteColor]];
    } else {
        self.backgroundColor = [UIColor whiteColor];
        [self.nameLabel setTextColor:[UIColor colorWithWhite:0.447 alpha:1.000]];
    }
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
//    if (highlighted){
//        self.backgroundColor = [UIColor colorWithRed:0.431 green:0.792 blue:0.992 alpha:1.000];
//        [self.nameLabel setTextColor:[UIColor whiteColor]];
//    } else {
//        self.backgroundColor = [UIColor whiteColor];
//        [self.nameLabel setTextColor:[UIColor colorWithWhite:0.447 alpha:1.000]];
//    }
    
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context,
                                     [UIColor colorWithWhite:0.898 alpha:1.000].CGColor);
    
    CGContextMoveToPoint(context, 0, 50);
    CGContextAddLineToPoint(context, 320, 50);
    CGContextStrokePath(context);
}


@end
