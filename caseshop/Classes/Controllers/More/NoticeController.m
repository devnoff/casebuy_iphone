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
               NSDictionary *notice = [result objectForKey:@"result"];
               
               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[notice objectForKey:@"title"]
                                                                message:NSLocalizedString(@"There is something you should know. Would you like to check it out?", nil)
                                                               delegate:delegate
                                                      cancelButtonTitle:NSLocalizedString(@"No, Thanks",nil)
                                                      otherButtonTitles:NSLocalizedString(@"Check it out",nil), nil];
               alert.tag = [[notice objectForKey:@"id"] integerValue];
               
               [NoticeController setLatestNoticeId:alert.tag];
               
               [alert show];
           }
           
       }
        failureBock:^(NSError *error){
            NSLog(@"error: %@", error);
        }];

}
@end
