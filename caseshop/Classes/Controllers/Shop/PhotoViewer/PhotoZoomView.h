//
//  PhotoZoomView.h
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 30..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoZoomView : UIScrollView{

}
@property (nonatomic,strong) UIImageView *photoView;
@property (nonatomic,strong) UITapGestureRecognizer *doubleTapRecognizer;
@property (nonatomic,strong) UITapGestureRecognizer *tapRecognizer;

@end
