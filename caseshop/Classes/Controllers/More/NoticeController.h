//
//  NoticeController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 12. 3..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLATEST_NOTICE_ID @"latest_notice_id"

@interface NoticeController : NSObject

+ (NSInteger)latestNoticeId;
+ (void)setLatestNoticeId:(NSInteger)noticeId;

+ (void)requestNoticeWithDelegate:(id<UIAlertViewDelegate> )delegate;
@end
