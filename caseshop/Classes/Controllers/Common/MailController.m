//
//  MailController.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 23..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "MailController.h"

@implementation MailController

+ (void)mailWithTitle:(NSString*)title
            recipient:(NSString*)recipient
                 memo:(NSString*)memo
               target:(UIViewController<MFMailComposeViewControllerDelegate>*)targetController{
    
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    
    [mail setSubject:title];
    [mail setToRecipients:[NSArray arrayWithObject:recipient]];
    [mail setMessageBody:[NSString stringWithFormat:@"<br/><br/>%@",memo] isHTML:YES];
    
    mail.mailComposeDelegate = targetController;
    
    [targetController presentModalViewController:mail animated:YES];

}

@end
