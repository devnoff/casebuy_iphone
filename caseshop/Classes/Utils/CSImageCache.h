//
//  CSImageCache.h
//  gogofishing
//
//  Created by Park Yongnam on 12. 7. 12..
//  Copyright (c) 2012 CultStory Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImage/SDImageCache.h"

typedef enum {
    CellColumPositionLeft,
    CellColumPositionRight
} CellColumPosition;

@protocol LateLoadingProtocol <NSObject>
- (void)applyImage:(UIImage*)image;
@end

@protocol DoubleColoumCellProtocol <NSObject>

- (id<LateLoadingProtocol>)left;
- (id<LateLoadingProtocol>)right;

@end

@interface CSImageCache : NSObject<NSURLConnectionDataDelegate>{
    SDImageCache *imgCache;
    dispatch_queue_t queue;
}

- (SDImageCache*) cache;

+ (CSImageCache *) sharedImageCache;

@end
