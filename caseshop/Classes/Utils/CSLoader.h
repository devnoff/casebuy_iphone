//
//  CSLoader.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 9..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DACircularProgressView.h"

@interface CSLoader : NSObject<NSURLConnectionDataDelegate>{
    UIScrollView *_scrollView;
    UIImageView *_imageView;
    NSMutableData *_data;
    NSString *_url;
    float size;
    DACircularProgressView *progressView;
}

+ (CSLoader *) sharedLoader;

- (void)loadRemoteImageForView:(UIImageView *)imageView withUrl:(NSString*)url;
- (void)loadRemoteImageForZoomView:(UIScrollView*)scrollView imageView:(UIImageView*)imageView withUrl:(NSString*)url;

@end
