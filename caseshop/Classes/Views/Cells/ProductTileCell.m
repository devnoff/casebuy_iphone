//
//  ProductTileCell.m
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 29..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "ProductTileCell.h"

@implementation ProductTileCell
@synthesize rightButton,leftButton;


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

    // Configure the view for the selected state
}

- (id)left{
    return self.leftButton;
}

- (id)right{
    return self.rightButton;
}

@end
