//
//  PhoneNumberHelper.m
//  gogofishing
//
//  Created by Park Yongnam on 12. 6. 18..
//  Copyright (c) 2012 CultStory Inc. All rights reserved.
//

#import "PhoneNumberHelper.h"

@implementation PhoneNumberHelper


+ (NSString*)phoneNumberWithoutDash:(NSString*)number{
    NSArray *arr = [number componentsSeparatedByString:@"-"];
    return [arr componentsJoinedByString:@""];
}

+ (NSString*)phoneNumberWithDash:(NSString*)number{
    if (!number){
        return nil;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:[number substringToIndex:3]];
    
    int fromIdx;
    if (number.length < 11){
        fromIdx = 6;
        [arr addObject:[number substringWithRange:NSMakeRange(3, 3)]];
    }
    else {
        fromIdx = 7;
        [arr addObject:[number substringWithRange:NSMakeRange(3, 4)]];
    }
    
    [arr addObject:[number substringFromIndex:fromIdx]];
    
    NSString *toStr = [arr componentsJoinedByString:@"-"];
    return toStr;
}

+ (BOOL)validateTeleMobile:(NSString*)number{
    NSString *str = number;
    
    if (str.length > 11 || str.length < 9)
        return NO;
    
    NSString *ptn = @"(010|011|016|017|018|019|02|031|032|033|041|042|043|051|052|053|054|055|061|062|063|064)([0-9]{3,4})([0-9]{4})";
    NSRange range = [str rangeOfString:ptn options:NSRegularExpressionSearch];
    
    
    NSLog(@"valied %d", range.length); // 0, 12 출력
    
    if (range.length > 0){
        return YES;
    }
    
    return NO;
}

@end
