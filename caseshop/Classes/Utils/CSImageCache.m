//
//  CSImageCache.m
//  gogofishing
//
//  Created by Park Yongnam on 12. 7. 12..
//  Copyright (c) 2012 CultStory Inc. All rights reserved.
//

#import "CSImageCache.h"
#import "DACircularProgressView.h"
#import "CSLoader.h"

#define URL_IMAGE_HOST @""



@implementation CSImageCache
static CSImageCache *instance;

- (void)dealloc{
    imgCache = nil;
    dispatch_release(queue);
}

- (id)init{
    self = [super init];
    if (self){
        imgCache = [SDImageCache sharedImageCache];
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}

- (SDImageCache*) cache{
    if (!imgCache){
        imgCache = [SDImageCache sharedImageCache];
    }
    
    return imgCache;
}

+ (CSImageCache *) sharedImageCache{
    if (!instance){
        
        CSImageCache *cache = [[CSImageCache alloc] init];
        instance = cache;
    }
    
    return instance;
}





@end
