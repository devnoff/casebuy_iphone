//
//  ShipInfoCell.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 7..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShipInfoCell : UITableViewCell{
    UILabel *_nameLabel;
    UILabel *_descLabel;
    UILabel *_feeLabel;
}

- (void)setName:(NSString*)name desc:(NSString*)desc fee:(NSString*)fee;
- (NSString*)feeStr;
- (NSString*)optionStr;
@end
