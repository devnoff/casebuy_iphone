//
//  ShipInfoCell.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 7..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "ShipInfoCell.h"


@interface ShipBgView : UIView

@end
@implementation ShipBgView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context,
                                     [UIColor colorWithWhite:0.212 alpha:1.000].CGColor);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 320, 0);
    CGContextStrokePath(context);
}

@end

@implementation ShipInfoCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.251 alpha:1.000];
        
        ShipBgView *bg = [[ShipBgView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        bg.backgroundColor = [UIColor clearColor];
        [self addSubview:bg];

        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 0, 50)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont fontWithName:@"DINPro-Bold" size:17];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_nameLabel];
        
        
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 0, 50)];
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.font = [UIFont fontWithName:@"DINPro-Bold" size:17];
        _descLabel.textColor = [UIColor colorWithWhite:0.447 alpha:1.000];
        _descLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_descLabel];
        
        _feeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 310, 50)];
        _feeLabel.textAlignment = NSTextAlignmentRight;
        _feeLabel.font = [UIFont fontWithName:@"DINPro-Bold" size:17];
        _feeLabel.textColor = [UIColor whiteColor];
        _feeLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_feeLabel];
        
    }
    return self;
}

- (void)setName:(NSString*)name desc:(NSString*)desc fee:(NSString*)fee{
    
    _nameLabel.text = name;
    
    CGSize size = [name sizeWithFont:_nameLabel.font];
    CGRect nameframe = _nameLabel.frame;
    nameframe.size.width = size.width;
    _nameLabel.frame = nameframe;
    
    
    _descLabel.text = desc;
    CGSize dsize = [desc sizeWithFont:_descLabel.font];
    CGRect descframe = _descLabel.frame;
    descframe.origin.x = nameframe.origin.x + nameframe.size.width + 5;
    descframe.size.width = dsize.width;
    _descLabel.frame = descframe;
    
    
    _feeLabel.text = fee;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (selected){
        self.contentView.backgroundColor = [UIColor blackColor];
    } else {
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.251 alpha:1.000];
    }
}


- (NSString*)feeStr{
    return _feeLabel.text;
}

- (NSString*)optionStr{
    return [_nameLabel.text lowercaseString];
}

@end
