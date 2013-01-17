//
//  ProductTileCell.h
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 29..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductTileButton.h"
#import "CSImageCache.h"

@interface ProductTileCell : UITableViewCell<DoubleColoumCellProtocol>


@property (nonatomic,strong) IBOutlet ProductTileButton *leftButton;
@property (nonatomic,strong) IBOutlet ProductTileButton *rightButton;

@end
