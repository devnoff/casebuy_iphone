//
//  UIImageView+Animation.m
//  pictoon
//
//  Created by Park Yongnam on 12. 3. 16..
//  Copyright (c) 2012 CultStory Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIImageView+Animation.h"


@implementation UIImageView(Animation)
static UIImage *newImage = nil;

- (void)animateChangeImageWithCrossFade:(UIImage*)image{
    CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
    crossFade.delegate = self;
    crossFade.duration = .3f;
    crossFade.fromValue = (id)self.image.CGImage;
    crossFade.toValue = (id)image.CGImage;
    newImage = image;
    self.image = newImage;
    [self.layer addAnimation:crossFade forKey:@"animateContents"];
    

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if (flag){
        
        newImage = nil;    
    }
    
}
@end
