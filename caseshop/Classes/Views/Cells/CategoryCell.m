//
//  CategoryCell.m
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 26..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell
@synthesize leftButton,rightButton;


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

- (void)showLeft{
    self.leftButton.alpha = 1.0f;
}

- (void)showRight{
    self.rightButton.alpha = 1.0f;
}


- (id)left{
    
    return self.leftButton;
}

- (id)right{
    
    return self.rightButton;
}


- (void)prepareForReuse{
    [super prepareForReuse];
    
    self.leftButton.alpha = .0f;
    self.rightButton.alpha = .0f;
}


@end
