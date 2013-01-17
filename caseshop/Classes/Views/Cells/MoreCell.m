//
//  MoreCell.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 9..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "MoreCell.h"

@implementation MoreCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.font = [UIFont fontWithName:@"DINPro-Bold" size:17];
        self.textLabel.textColor = [UIColor colorWithWhite:0.447 alpha:1.000];
        self.textLabel.backgroundColor = [UIColor clearColor];
        


    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (selected){
        self.contentView.backgroundColor = [UIColor colorWithRed:0.431 green:0.792 blue:0.992 alpha:1.000];
        [self.textLabel setTextColor:[UIColor whiteColor]];
    } else {
        self.contentView.backgroundColor = [UIColor clearColor];
         [self.textLabel setTextColor:[UIColor colorWithWhite:0.447 alpha:1.000]];
    }
    
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
