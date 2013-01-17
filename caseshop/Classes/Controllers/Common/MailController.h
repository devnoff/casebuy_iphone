//
//  MailController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 23..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface MailController : NSObject

+ (void)mailWithTitle:(NSString*)title recipient:(NSString*)recipient memo:(NSString*)memo target:(UIViewController*)targetController;

@end
