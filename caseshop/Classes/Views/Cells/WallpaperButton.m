//
//  WallpaperButton.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 8..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "WallpaperButton.h"

@implementation WallpaperButton
@synthesize itemId;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        self.alpha = .0f;
    }
    return self;
}



- (void)applyImage:(UIImage *)image{
    [self setImage:image forState:UIControlStateNormal];
    
    
//    [UIView animateWithDuration:.3
//                     animations:^{
//                         self.alpha = 1.0f;
//                     }];
}

@end
