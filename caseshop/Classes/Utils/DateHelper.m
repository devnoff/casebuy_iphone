//
//  DateHelper.m
//  gogofishing
//
//  Created by Park Yongnam on 12. 6. 21..
//  Copyright (c) 2012 CultStory Inc. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

+ (NSString*)dateStringByStringAsyyyyMMdd:(NSString*)dateStr{
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:[dateStr substringToIndex:4]];
    [arr addObject:[dateStr substringWithRange:NSMakeRange(4, 2)]];
    [arr addObject:[dateStr substringFromIndex:6]];
    
    NSString *toStr = [arr componentsJoinedByString:@"."];
    return toStr;

}

@end
