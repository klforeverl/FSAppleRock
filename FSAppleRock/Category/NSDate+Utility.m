//
//  NSDate+Utility.m
//  QuickSale
//
//  Created by zhanglan on 15/8/6.
//  Copyright (c) 2015年 fangstar. All rights reserved.
//

#import "NSDate+Utility.h"

@implementation NSDate (Utility)

- (NSString *)getYear {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
                          NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];

    return [NSString stringWithFormat:@"%ld", (long)comps.year];
}

- (NSString *)getMonth {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
                          NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];

    return [NSString stringWithFormat:@"%ld", (long)comps.month];
}

- (NSString *)getDay {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
                          NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];

    return [NSString stringWithFormat:@"%ld", (long)comps.day];
}

- (NSString *)getHour {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
                          NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];

    return [NSString stringWithFormat:@"%ld", (long)comps.hour];
}

- (NSString *)getMinute {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
                          NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];

    return [NSString stringWithFormat:@"%ld", (long)comps.minute];
}

- (NSInteger)year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int uintFlags = NSCalendarUnitYear;
    NSDateComponents *dateComponents = [calendar components:uintFlags fromDate:self];
    return [dateComponents year];
}

- (NSInteger)month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int uintFlags = NSCalendarUnitMonth;
    NSDateComponents *dateComponents = [calendar components:uintFlags fromDate:self];
    return [dateComponents month];
}

- (NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int uintFlags = NSCalendarUnitDay;
    NSDateComponents *dateComponents = [calendar components:uintFlags fromDate:self];
    return [dateComponents day];
}

- (NSInteger)hour {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int uintFlags = NSCalendarUnitHour;
    NSDateComponents *dateComponents = [calendar components:uintFlags fromDate:self];
    return [dateComponents hour];
}

- (NSInteger)minute {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int uintFlags = NSCalendarUnitMinute;
    NSDateComponents *dateComponents = [calendar components:uintFlags fromDate:self];
    return [dateComponents minute];
}

// 获取当前日期，前后
- (NSMutableArray *)getDateArrayOfBeforeAndAfter:(NSInteger)interval {
    NSMutableArray *dateArray = [[NSMutableArray alloc] init];

    // 之前
    for (NSInteger i = interval; i > 0; i--) {
        NSTimeInterval oneDayInterval = 24 * 60 * 60 * i; //1天的长度

        //        NSDate *beforeDate = [self initWithTimeIntervalSinceNow:-oneDayInterval];
        NSDate *beforeDate = [NSDate dateWithTimeInterval:-oneDayInterval sinceDate:self];

        [dateArray addObject:beforeDate];
    }

    // 添加当前时间
    [dateArray addObject:self];

    // 之后
    for (NSInteger i = 1; i < interval + 1; i++) {
        NSTimeInterval oneDayInterval = 24 * 60 * 60 * i; //1天的长度

        NSDate *afterDate = [NSDate dateWithTimeInterval:+oneDayInterval sinceDate:self];
        //        [self dateWithTimeInterval:+oneDayInterval];

        [dateArray addObject:afterDate];
    }

    return dateArray;
}

- (NSString *)getWeekString {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
                          NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    NSInteger week = comps.weekday;
    NSString *weekStr;
    if (week == 1) {
        weekStr = @"周日";
    } else if (week == 2) {
        weekStr = @"周一";
    } else if (week == 3) {
        weekStr = @"周二";
    } else if (week == 4) {
        weekStr = @"周三";
    } else if (week == 5) {
        weekStr = @"周四";
    } else if (week == 6) {
        weekStr = @"周五";
    } else if (week == 7) {
        weekStr = @"周六";
    }
    return weekStr;
}

- (NSDate *)dateWithYMD {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

+ (NSDate *)date:(NSString *)datestr WithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:datestr];
    return date;
}

/**
 *  时间转字符串
 *
 *  @param format 时间格式
 *
 *  @return 时间字符串
 */
- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate:self];
    return dateString;
}
/**
 * @method
 *
 * @brief 获取两个日期之间的天数
 * @param fromDate       起始日期
 * @param toDate         终止日期
 * @return    总天数
 */
+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents    * comp = [calendar components:NSCalendarUnitDay
                                             fromDate:fromDate
                                               toDate:toDate
                                              options:NSCalendarWrapComponents];
    NSLog(@" -- >>  comp : %@  << --",comp);
    return comp.day;
}
@end
