//
//  CartCell.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 6..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorButton.h"


@protocol CartCellDelegate;
@interface CartCell : UITableViewCell{
    IBOutlet UIView *_qtyBgView;
    
    UIView *_bgView;
}
@property (nonatomic,strong) IBOutlet UIImageView *fbBadge;
@property (nonatomic,strong) IBOutlet UIImageView *photoView;
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UILabel *priceLabel;
@property (nonatomic,strong) IBOutlet ColorButton *qtyButton;
@property (nonatomic,weak) id<CartCellDelegate> delegate;

- (IBAction)qtyBtnTapped:(id)sender;
- (IBAction)doneBtnTapped:(id)sender;
- (IBAction)plusQty;
- (IBAction)minusQty;

- (void)setQty:(NSString*)qty;

- (void)showQtyEdit:(BOOL)show;

- (void)shouldStartEditing;
- (void)shouldEndEditing;

- (void)applyImage:(UIImage*)image;

@end



@protocol CartCellDelegate <NSObject>

- (void)cartCellShouldUpdate:(CartCell*)cell;
- (void)cartCellDidStartEditing:(CartCell*)cell;

@end