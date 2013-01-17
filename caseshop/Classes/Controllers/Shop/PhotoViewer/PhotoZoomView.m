//
//  PhotoZoomView.m
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 30..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "PhotoZoomView.h"

@implementation PhotoZoomView
@synthesize photoView,doubleTapRecognizer,tapRecognizer;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        photoView = [[UIImageView alloc] initWithFrame:frame];
        photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        photoView.contentMode = UIViewContentModeScaleAspectFit;

        [self addSubview:photoView];
        
        
        [self setupGestureRecognisers:self];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    

    // center the zoom view as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = photoView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    photoView.frame = frameToCenter;
}



#pragma mark - Double Tap Zooming

- (void)setupGestureRecognisers:(UIView *)viewToAttach {
    
    UITapGestureRecognizer *dblRecognizer;
    dblRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(handleDoubleTapFrom:)];
    [dblRecognizer setNumberOfTapsRequired:2];
    
    [viewToAttach addGestureRecognizer:dblRecognizer];
    self.doubleTapRecognizer = dblRecognizer;
    
    UITapGestureRecognizer *recognizer;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                         action:@selector(handleTapFrom:)];
    [recognizer requireGestureRecognizerToFail:dblRecognizer];
    
    [viewToAttach addGestureRecognizer:recognizer];
    self.tapRecognizer = recognizer;
}

- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer {
    
    // do your single tap
}


- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = [self.photoView frame].size.height / scale;
    zoomRect.size.width  = [self.photoView frame].size.width  / scale;
    
    center = [self.photoView convertPoint:center fromView:self];
    
    zoomRect.origin.x    = center.x - ((zoomRect.size.width / 2.0));
    zoomRect.origin.y    = center.y - ((zoomRect.size.height / 2.0));
    
    return zoomRect;
}

- (void)handleDoubleTapFrom:(UITapGestureRecognizer *)recognizer {
    
    float newScale = [self zoomScale] * 4.0;
    
    if (self.zoomScale > self.minimumZoomScale)
    {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
    else
    {
        CGRect zoomRect = [self zoomRectForScale:newScale
                                      withCenter:[recognizer locationInView:recognizer.view]];
        [self zoomToRect:zoomRect animated:YES];
    }
}
@end
