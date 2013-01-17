//
//  NSDateAdditions.m
//  travelog
//
//  Created by CHO YOUNG UN on 11. 11. 22..
//  Copyright (c) 2011 cultstory.com. All rights reserved.
//
// 참고 : https://github.com/facebook/three20/blob/master/src/Three20Core/Sources/NSDateAdditions.m

#import "NSDateAdditions.h"


#define CS_MINUTE 60
#define CS_HOUR (60 * CS_MINUTE)
#define CS_DAY (24 * CS_HOUR)
#define CS_WEEK (7 * CS_DAY)
#define CS_MONTH (30.5 * CS_DAY)
#define CS_YEAR (365 * CS_DAY)


@implementation NSDate (Additions)

- (NSString *)formatTime {
    static NSDateFormatter *formatter = nil;
    if (nil == formatter) {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:IDENTIFIED_LOCALE];
        
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = NSLocalizedString(@"h:mm a", @"DATE_FORMAT");
        formatter.locale = locale;
    }
    return [formatter stringFromDate:self];
}


- (NSString *)formatDate {
    static NSDateFormatter *formatter = nil;
    if (nil == formatter) {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:IDENTIFIED_LOCALE];
        
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = NSLocalizedString(@"EEEE, MMMM d, yyyy", @"DATE_FORMAT");
        formatter.locale = locale;
    }
    return [formatter stringFromDate:self];
}


//- (NSString *)formatDateTime {
//    NSTimeInterval diff = abs([self timeIntervalSinceNow]);
//    if (diff < CS_DAY) {
//        return [self formatTime];
//    } else if (diff < CS_WEEK) {
//        static NSDateFormatter *formatter = nil;
//        if (nil == formatter) {
//            formatter = [[NSDateFormatter alloc] init];
//            formatter.dateFormat = NSLocalizedString(@"EEEE h:mm a", @"DATE_FORMAT");
//            formatter.locale = CSCL;
//        }
//        return [formatter stringFromDate:self];
//    } else if (diff < CS_YEAR) {
//        static NSDateFormatter *formatter = nil;
//        if (nil == formatter) {
//            formatter = [[NSDateFormatter alloc] init];
//            formatter.dateFormat = NSLocalizedString(@"MMMM d h:mm a", @"DATE_FORMAT");
//            formatter.locale = CSCL;
//        }
//        return [formatter stringFromDate:self];
//    } else {
//        static NSDateFormatter *formatter = nil;
//        if (nil == formatter) {
//            formatter = [[NSDateFormatter alloc] init];
//            formatter.dateFormat = NSLocalizedString(@"MMMM d, yyyy h:mm a", @"DATE_FORMAT");
//            formatter.locale = CSCL;
//        }
//        return [formatter stringFromDate:self];
//    }
//}


- (NSString *)formatDateTime {
    static NSDateFormatter *formatter = nil;
    if (nil == formatter) {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:IDENTIFIED_LOCALE];
        
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = NSLocalizedString(@"MMMM d, yyyy h:mm a", @"DATE_FORMAT");
        formatter.locale = locale;
    }
    return [formatter stringFromDate:self];
}


- (NSString *)timeago {
    NSTimeInterval elapsed = [self timeIntervalSinceNow];
    if (elapsed > 0) {
        if (elapsed <= 1) {
            return NSLocalizedString(@"in just a moment", @"DATE_FORMAT");
        } else if (elapsed < CS_MINUTE) {
            int seconds = (int)(elapsed);
            return [NSString stringWithFormat:NSLocalizedString(@"in %d seconds", @"DATE_FORMAT"), seconds];
            
        } else if (elapsed < 2 * CS_MINUTE) {
            return NSLocalizedString(@"in about a minute", @"DATE_FORMAT");
        } else if (elapsed < CS_HOUR) {
            int mins = (int)(elapsed / CS_MINUTE);
            return [NSString stringWithFormat:NSLocalizedString(@"in %d minutes", @"DATE_FORMAT"), mins];
        } else if (elapsed < CS_HOUR * 1.5) {
            return NSLocalizedString(@"in about an hour", @"DATE_FORMAT");
        } else if (elapsed < CS_DAY) {
            int hours = (int)((elapsed + CS_HOUR / 2) / CS_HOUR);
            return [NSString stringWithFormat:NSLocalizedString(@"in %d hours", @"DATE_FORMAT"), hours];
        } else if (elapsed < 2 * CS_DAY) {
            return NSLocalizedString(@"in about a day", @"DATE_FORMAT");
        } else if (elapsed < CS_MONTH) {
            int days = (int)(elapsed + CS_DAY);
            return [NSString stringWithFormat:NSLocalizedString(@"in %d days", @"DATE_FORMAT"), days];
        } else {
            return [self formatDateTime];
        }
    } else {
        elapsed = -elapsed;

        if (elapsed <= 1) {
            return NSLocalizedString(@"just a moment ago", @"DATE_FORMAT");
        } else if (elapsed < CS_MINUTE) {
            int seconds = (int)(elapsed);
            return [NSString stringWithFormat:NSLocalizedString(@"%d seconds ago", @"DATE_FORMAT"), seconds];
        } else if (elapsed < 2 * CS_MINUTE) {
            return NSLocalizedString(@"about a minute ago", @"DATE_FORMAT");
        } else if (elapsed < CS_HOUR) {
            int mins = (int)(elapsed / CS_MINUTE);
            return [NSString stringWithFormat:NSLocalizedString(@"%d minutes ago", @"DATE_FORMAT"), mins];
        } else if (elapsed < CS_HOUR * 1.5) {
            return NSLocalizedString(@"about an hour ago", @"DATE_FORMAT");
        } else if (elapsed < CS_DAY) {
            int hours = (int)((elapsed + CS_HOUR / 2) / CS_HOUR);
            return [NSString stringWithFormat:NSLocalizedString(@"%d hours ago", @"DATE_FORMAT"), hours];
        } else if (elapsed < 2 * CS_DAY) {
            return NSLocalizedString(@"about a day ago", @"DATE_FORMAT");
        } else if (elapsed < CS_MONTH) {
            int days = (int)(elapsed / CS_DAY);
            return [NSString stringWithFormat:NSLocalizedString(@"%d days ago", @"DATE_FORMAT"), days];
        } else {
            return [self formatDateTime];
        }
    }
}


- (NSDate *)dateForTimeZone:(NSTimeZone *)timeZone {
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    NSInteger secondsFromGMT = [localTimeZone secondsFromGMTForDate:self];
    
    NSInteger secondsFromTimeZone = [timeZone secondsFromGMTForDate:self];
    
    return [NSDate dateWithTimeInterval:secondsFromTimeZone - secondsFromGMT sinceDate:self];
}

@end
