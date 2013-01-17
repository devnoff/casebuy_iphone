//
//  UIView+Bounce.m
//  pictoon
//
//  Created by Park Yongnam on 12. 2. 21..
//  Copyright (c) 2012 CultStory Inc. All rights reserved.
//

#import "UIView+Bounce.h"


@implementation UIView (Bounce)

- (void)prepareToBounce {
    self.transform = CGAffineTransformMakeScale(0.001, 0.001);
}


- (void)animateBouncing {
    [UIView animateWithDuration:0.2f 
                     animations:^(void) {
                         self.transform = CGAffineTransformMakeScale(1.12f, 1.12f);
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [UIView animateWithDuration:0.15f 
                                              animations:^(void) {
                                                  self.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
                                              }
                                              completion:^(BOOL finished) {
                                                  [UIView animateWithDuration:0.2f 
                                                                   animations:^(void) {
                                                                       self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                                                                   }];
                                              }];
                         }
                     }]; 
}

@end
