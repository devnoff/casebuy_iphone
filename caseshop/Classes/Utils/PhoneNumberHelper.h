//
//  PhoneNumberHelper.h
//  gogofishing
//
//  Created by Park Yongnam on 12. 6. 18..
//  Copyright (c) 2012 CultStory Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneNumberHelper : NSObject

+ (NSString*)phoneNumberWithoutDash:(NSString*)number;
+ (NSString*)phoneNumberWithDash:(NSString*)number;
+ (BOOL)validateTeleMobile:(NSString*)number;

@end
