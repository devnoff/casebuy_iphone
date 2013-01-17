//
//  WallpaperCell.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 8..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "WallpaperCell.h"


@implementation WallpaperCell
@synthesize leftBtn,rightBtn;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        leftBtn = [[WallpaperButton alloc] initWithFrame:CGRectMake(15, 0, 137, 113)];
        leftBtn.backgroundColor = [UIColor colorWithWhite:0.953 alpha:1.000];
        leftBtn.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:leftBtn];
        
        rightBtn = [[WallpaperButton alloc] initWithFrame:CGRectMake(15 + 137 + 15, 0, 137, 113)];
        rightBtn.backgroundColor = [UIColor colorWithWhite:0.953 alpha:1.000];
        rightBtn.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:rightBtn];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [self.leftBtn setImage:nil forState:UIControlStateNormal];
    [self.rightBtn setImage:nil forState:UIControlStateNormal];
    
    leftBtn.itemId = PRODUCT_ID_INVALID;
    rightBtn.itemId = PRODUCT_ID_INVALID;

}


- (id)left{
    return self.leftBtn;
}

- (id)right{
    return self.rightBtn;
}

@end
