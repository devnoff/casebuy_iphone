//
//  CustomLabel.m
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 26..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"DINPro-Bold" size:self.font.pointSize];
}



@end
