//
//  NoticeController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 12. 3..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "NoticeController.h"
#import "API.h"
#import "AppDelegate.h"
#import "NoticeDetailController.h"

#define NOTICE_ID_FOR_WAIT_PAYMENT -1
@implementation NoticeController

+ (NSInteger)latestNoticeId{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def integerForKey:kLATEST_NOTICE_ID];
}

+ (void)setLatestNoticeId:(NSInteger)noticeId{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setInteger:noticeId forKey:kLATEST_NOTICE_ID];
    [def synchronize];
}


+ (void)requestNoticeWithDelegate:(id<UIAlertViewDelegate> )delegate{
    API *apiRequest = [[API alloc] init];
    
    NSInteger latestNoticeId = [NoticeController latestNoticeId];
    
    [apiRequest get:[NSString stringWithFormat:@"s/newNotice/%d?uuid=%@",latestNoticeId,[[AppDelegate sharedAppdelegate] uuid]]
       successBlock:^(NSDictionary *result){
           NSLog(@"result: %@", result);
           
           int resultCode = [[result objectForKey:@"code"] intValue];
           if (resultCode == kAPI_RESULT_OK){
               NSDictionary *noticeData = [result objectForKey:@"result"];
               NSInteger noticeId = [[noticeData objectForKey:@"id"] integerValue];
               [NoticeController setLatestNoticeId:noticeId];
               NoticeDetailController *notice = [[NoticeDetailController alloc] initWithNibName:@"NoticeDetailController" bundle:nil];
               notice.itemId = noticeId;
               notice.hasLeftCancelBtn = YES;
               notice.title = NSLocalizedString(@"NOTICE",nil);
               UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:notice];
               [[AppDelegate sharedAppdelegate].window.rootViewController presentViewController:nav animated:YES completion:nil];

           }
           
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);
        }];

}
@end
