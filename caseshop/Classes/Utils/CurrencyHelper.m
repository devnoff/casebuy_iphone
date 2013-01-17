//
//  CurrencyHelper.m
//  caseshop
//
//  Created by Yongnam Park on 12. 11. 20..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "CurrencyHelper.h"

@implementation CurrencyHelper

+ (NSString*)formattedString:(NSNumber*)number withIdentifier:(NSString*)identifier{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:identifier]];
    NSString *groupingSeparator = [[[NSLocale alloc] initWithLocaleIdentifier:identifier] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    
    return [formatter stringFromNumber:number];
}

@end
