//
//  DeviceCell.h
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 25..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceCell : UITableViewCell{
    IBOutlet UILabel *_titleLabel;
    IBOutlet UIButton *_iconImg;
    
}

@property (nonatomic,strong) IBOutlet UIImageView *checkImg;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *activity;

- (void)setTitle:(NSString*)title icon:(UIImage*)icon iconSelected:(UIImage*)iconSelected;

@end
