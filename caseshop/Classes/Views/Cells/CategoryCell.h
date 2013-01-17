//
//  CategoryCell.h
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 26..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryTileButton.h"
#import "CSImageCache.h"

@interface CategoryCell : UITableViewCell<DoubleColoumCellProtocol>

@property (nonatomic, strong) IBOutlet CategoryTileButton<LateLoadingProtocol> *leftButton;
@property (nonatomic, strong) IBOutlet CategoryTileButton<LateLoadingProtocol> *rightButton;

- (void)showLeft;
- (void)showRight;

@end
