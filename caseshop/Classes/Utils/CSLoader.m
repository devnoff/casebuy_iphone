//
//  CSLoader.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 9..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "CSLoader.h"
#import "CSImageCache.h"

static CSLoader *instance;

@implementation CSLoader

- (void)dealloc{
    _imageView = nil;
    _url = nil;
//    [progressView release];
}

- (id)init{
    self = [super init];
    if (self){
        _data = [[NSMutableData alloc] init];
    }
    return self;
}


+ (CSLoader *) sharedLoader{
    return [[CSLoader alloc] init];
}



#pragma mark - NSURLConnectionDelegate

- (void)connection: (NSURLConnection*) connection didReceiveResponse: (NSHTTPURLResponse*) response
{
    if ([response statusCode] == 200) {
        size = [response expectedContentLength];
    }
}

- (void) connection: (NSURLConnection*) connection didReceiveData: (NSData*) data
{
    [_data appendData: data];
    
    float pr = ((float) [_data length] / (float) size);
    
    progressView.progress = pr;
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    UIImage *image = [UIImage imageWithData:_data];
    _imageView.image = image;
    
    [UIView animateWithDuration:.3 animations:^{
        _imageView.alpha = 1.0f;
    }];
    
    if (_scrollView){
        float ratio = image.size.width / image.size.height;
        float w = 320;
        float h = (w / ratio) + 100;
        _scrollView.contentSize = CGSizeMake(w, h);
        
        CGRect rect = _imageView.frame;
        rect.size = _scrollView.contentSize;
        rect.size.height -= 100;
//        rect.origin.y += 100;
        _imageView.frame = rect;

    }
    
    
    [[SDImageCache sharedImageCache] storeImage:image forKey:_url toDisk:YES];
    
    [progressView removeFromSuperview];
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error: %@",error);
    
}



#pragma mark - 

- (void)loadRemoteImageForView:(UIImageView*)imageView withUrl:(NSString*)url{
    _imageView = imageView;
    
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:url done:^(UIImage *image, SDImageCacheType cacheType) {
        if (image){
            _imageView.image = image;
            [UIView animateWithDuration:.3 animations:^{
                _imageView.alpha = 1.0f;
            }];
        } else {
            _imageView.alpha = .0f;
            
            progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            progressView.roundedCorners = YES;
            progressView.progressTintColor = [UIColor colorWithRed:0.431 green:0.792 blue:0.992 alpha:1.000];
            progressView.trackTintColor = [UIColor lightGrayColor];
            progressView.center = imageView.superview.center;
            [imageView.superview addSubview:progressView];
            
            _url = url;
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
            [NSURLConnection connectionWithRequest:request delegate:self];

        }
    }];
    
}

- (void)loadRemoteImageForZoomView:(UIScrollView*)scrollView imageView:(UIImageView*)imageView withUrl:(NSString*)url{
    _imageView = imageView;
    _scrollView = scrollView;
    
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:url done:^(UIImage *image, SDImageCacheType cacheType) {
        if (image){
            
            if (_scrollView){
                float ratio = image.size.width / image.size.height;
                float w = 320;
                float h = (w / ratio) + 100;
                _scrollView.contentSize = CGSizeMake(w, h);
                
                CGRect rect = _imageView.frame;
                rect.size = _scrollView.contentSize;
                rect.size.height -= 100;
//                rect.origin.y += 100;
                _imageView.frame = rect;
                

                
            }
            
            _imageView.image = image;
            [UIView animateWithDuration:.3 animations:^{
                _imageView.alpha = 1.0f;
            }];
        } else {
            _imageView.alpha = .0f;
            
            progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            progressView.roundedCorners = YES;
            progressView.progressTintColor = [UIColor colorWithRed:0.431 green:0.792 blue:0.992 alpha:1.000];
            progressView.trackTintColor = [UIColor lightGrayColor];
            progressView.center = imageView.superview.center;
            [imageView.superview addSubview:progressView];
            
            _url = url;
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
            [NSURLConnection connectionWithRequest:request delegate:self];
            
        }
    }];
}



@end
