//
//  CurrencyHelper.h
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 20..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencyHelper : NSObject

+ (NSString*)formattedString:(NSNumber*)number withIdentifier:(NSString*)identifier;

@end
