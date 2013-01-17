//
//  NSDateAdditions.h
//  travelog
//
//  Created by CHO YOUNG UN on 11. 11. 22..
//  Copyright (c) 2011 cultstory.com. All rights reserved.
//

@interface NSDate (Additions)

- (NSString *)formatTime;
- (NSString *)formatDate;
- (NSString *)formatDateTime;

- (NSString *)timeago;

- (NSDate *)dateForTimeZone:(NSTimeZone *)timeZone;

@end