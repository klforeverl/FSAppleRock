//
//  NSDate+FSUtility.m
//  FSAppleRock
//
//  Created by ZhangLan_PC on 16/7/11.
//  Copyright © 2016年 fangstar.net. All rights reserved.
//

#import "NSDate+FSUtility.h"

@implementation NSDate (FSUtility)

- (NSInteger)year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)minute {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)second {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)weekday {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSInteger)weekOfMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}

- (NSString *)stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter dateFromString:dateString];
}

//NSDate 2013-5-8 19:09 45 => yyyy-MM-dd
+ (NSString *)timeSinceDate:(NSDate *)date format:(NSString*)formatestr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatestr];
    NSString *ret = [formatter stringFromDate:date];
    return ret;
}

//1233444s => "YYYY/MM/dd(formatestr)"
+ (NSString *)timeIntervalSince1970:(NSTimeInterval)secs Format:(NSString*)formatestr
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    return [self timeSinceDate:date format:formatestr];
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

+ (NSString *)getDateStringByTimeInteval:(NSInteger)timeInteval formatString:(NSString *)formatString
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatString];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeInteval];
    NSString *timeString = [formatter stringFromDate:confromTimesp];
    
    return timeString;
}

#pragma mark - 获取给定日期的 0点
// 获取某个日期起点
- (NSTimeInterval)getCurDateStartTime
{
    NSTimeInterval minTime=0;
    
    NSInteger year = [self year];
    NSInteger month = [self month];
    NSInteger day = [self day];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat  = @"yyyy/MM/dd HH:mm:ss";
    NSDate *date = [df dateFromString:[NSString stringWithFormat:@"%ld/%ld/%ld 00:00:00", (long)year, (long)month, (long)day]]; //给定3月1日零点日期
    minTime = [date timeIntervalSince1970];
    
    return minTime;
}
#pragma mark - 获取给定日期的 23：59：59
// 获取某个日期终点
- (NSTimeInterval)getCurDateEndTime
{
    NSTimeInterval minTime=0;
    
    NSInteger year = [self year];
    NSInteger month = [self month];
    NSInteger day = [self day];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat  = @"yyyy/MM/dd HH:mm:ss";
    NSDate *date = [df dateFromString:[NSString stringWithFormat:@"%ld/%ld/%ld 23:59:59", (long)year, (long)month, (long)day]]; //给定3月1日零点日期
    minTime = [date timeIntervalSince1970];
    
    return minTime;
}

#pragma mark - 获取给定日期的 周一
// 给定日期的周一
+ (NSDate *)getCurweekOne:(NSDate *)date
{
    NSDate *weekOneDate;
    
    NSString *curWeek = [date getWeekString];
    
    if ([curWeek isEqualToString:@"周日"]) {
        // -6 是周一
        NSTimeInterval dayInterval = 24 * 60 * 60 * 6;
        weekOneDate = [NSDate dateWithTimeInterval:-dayInterval sinceDate:[NSDate date]];
    }
    else if ([curWeek isEqualToString:@"周一"]) {
        // -0 是周一
        NSTimeInterval dayInterval = 24 * 60 * 60 * 0;
        weekOneDate = [NSDate dateWithTimeInterval:-dayInterval sinceDate:[NSDate date]];
    }
    else if ([curWeek isEqualToString:@"周二"]) {
        // -1 是周一
        NSTimeInterval dayInterval = 24 * 60 * 60 * 1;
        weekOneDate = [NSDate dateWithTimeInterval:-dayInterval sinceDate:[NSDate date]];
    }
    else if ([curWeek isEqualToString:@"周三"]) {
        // -2 是周一
        NSTimeInterval dayInterval = 24 * 60 * 60 * 2;
        weekOneDate = [NSDate dateWithTimeInterval:-dayInterval sinceDate:[NSDate date]];
    }
    else if ([curWeek isEqualToString:@"周四"]) {
        // -3 是周一
        NSTimeInterval dayInterval = 24 * 60 * 60 * 3;
        weekOneDate = [NSDate dateWithTimeInterval:-dayInterval sinceDate:[NSDate date]];
    }
    else if ([curWeek isEqualToString:@"周五"]) {
        // -4 是周一
        NSTimeInterval dayInterval = 24 * 60 * 60 * 4;
        weekOneDate = [NSDate dateWithTimeInterval:-dayInterval sinceDate:[NSDate date]];
    }
    
    return weekOneDate;
}

#pragma mark - 获取给定日期的 上周一、周末
// 给定日期的上周一
+ (NSDate *)getLastWeekOne:(NSDate *)date
{
    NSDate *weekEndDate = [NSDate getLastWeekEnd:date];
    
    NSTimeInterval dayInterval = 24 * 60 * 60 * 6;
    NSDate *weekOneDate = [NSDate dateWithTimeInterval:-dayInterval sinceDate:weekEndDate];
    
    return weekOneDate;
}

// 给定日期的上周末
+ (NSDate *)getLastWeekEnd:(NSDate *)date
{
    NSDate *weekOneDate;
    
    NSString *curWeek = [date getWeekString];
    
    if ([curWeek isEqualToString:@"周日"]) {
        // -7 是周天
        NSTimeInterval dayInterval = 24 * 60 * 60 * 7;
        weekOneDate = [NSDate dateWithTimeInterval:-dayInterval sinceDate:[NSDate date]];
    }
    else if ([curWeek isEqualToString:@"周一"]) {
        // -1 是周天
        NSTimeInterval dayInterval = 24 * 60 * 60 * 1;
        weekOneDate = [NSDate dateWithTimeInterval:-dayInterval sinceDate:[NSDate date]];
    }
    else if ([curWeek isEqualToString:@"周二"]) {
        // -2 是周天
        NSTimeInterval dayInterval = 24 * 60 * 60 * 2;
        weekOneDate = [NSDate dateWithTimeInterval:-dayInterval sinceDate:[NSDate date]];
    }
    else if ([curWeek isEqualToString:@"周三"]) {
        // -3 是周天
        NSTimeInterval dayInterval = 24 * 60 * 60 * 3;
        weekOneDate = [NSDate dateWithTimeInterval:-dayInterval sinceDate:[NSDate date]];
    }
    else if ([curWeek isEqualToString:@"周四"]) {
        // -4 是周天
        NSTimeInterval dayInterval = 24 * 60 * 60 * 4;
        weekOneDate = [NSDate dateWithTimeInterval:-dayInterval sinceDate:[NSDate date]];
    }
    else if ([curWeek isEqualToString:@"周五"]) {
        // -5 是周天
        NSTimeInterval dayInterval = 24 * 60 * 60 * 5;
        weekOneDate = [NSDate dateWithTimeInterval:-dayInterval sinceDate:[NSDate date]];
    }
    
    return weekOneDate;
}

#pragma mark - 跟进所给类型，获取时间的起点和终点（今天、明天、本周、上周、本月、上月）
// 根据类型 获取起点时间
+ (NSNumber *)getMinTimeByType:(NSString *)timeType
{
    NSTimeInterval minTime=0;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat  = @"yyyy/MM/dd HH:mm:ss";
    
    if ([timeType isEqualToString:@"今天"]) {
        minTime = [[NSDate date] getCurDateStartTime];
    }
    else if ([timeType isEqualToString:@"昨天"]) {
        NSTimeInterval oneDayInterval = 24 * 60 * 60 * 1; //1天的长度
        NSDate *afterDate = [NSDate dateWithTimeInterval:-oneDayInterval sinceDate:[NSDate date]];
        minTime = [afterDate getCurDateStartTime];
    }
    else if ([timeType isEqualToString:@"明天"]) {
        NSTimeInterval oneDayInterval = 24 * 60 * 60 * 1; //1天的长度
        NSDate *afterDate = [NSDate dateWithTimeInterval:+oneDayInterval sinceDate:[NSDate date]];
        
        minTime = [afterDate getCurDateStartTime];
    }
    else if ([timeType isEqualToString:@"本周"]) {
        minTime = [[NSDate getCurweekOne:[NSDate date]] getCurDateStartTime];
    }
    else if ([timeType isEqualToString:@"上周"]) {
        minTime = [[NSDate getLastWeekOne:[NSDate date]] getCurDateStartTime];
    }
    else if ([timeType isEqualToString:@"本月"]) {
        // 取月初
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat  = @"yyyy/MM/dd HH:mm:ss";
        NSDate *date = [df dateFromString:[NSString stringWithFormat:@"%ld/%ld/%d 00:00:00", (long)[[NSDate date] year], (long)[[NSDate date] month], 1]];
        
        minTime = [date getCurDateStartTime];
    }
    else if ([timeType isEqualToString:@"上月"]) {
        minTime = [[NSDate getLastMonthBegin:[NSDate date]] getCurDateStartTime];
    }
    
    return @(minTime);
}
// 根据类型 获取结束时间
+ (NSNumber *)getEndTimeByType:(NSString *)timeType
{
    NSTimeInterval minTime=0;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat  = @"yyyy/MM/dd HH:mm:ss";
    
    if ([timeType isEqualToString:@"今天"]) {
        minTime = [[NSDate date] getCurDateEndTime];
    }
    else if ([timeType isEqualToString:@"昨天"]) {
        NSTimeInterval oneDayInterval = 24 * 60 * 60 * 1; //1天的长度
        NSDate *afterDate = [NSDate dateWithTimeInterval:-oneDayInterval sinceDate:[NSDate date]];
        minTime = [afterDate getCurDateEndTime];
    }
    else if ([timeType isEqualToString:@"明天"]) {
        NSTimeInterval oneDayInterval = 24 * 60 * 60 * 1; //1天的长度
        NSDate *afterDate = [NSDate dateWithTimeInterval:+oneDayInterval sinceDate:[NSDate date]];
        
        minTime = [afterDate getCurDateEndTime];
    }
    else if ([timeType isEqualToString:@"本周"]) {
        minTime = [[NSDate date] getCurDateEndTime];
    }
    else if ([timeType isEqualToString:@"上周"]) {
        minTime = [[NSDate getLastWeekEnd:[NSDate date]] getCurDateEndTime];
    }
    else if ([timeType isEqualToString:@"本月"]) {
        minTime = [[NSDate date] getCurDateEndTime];
    }
    else if ([timeType isEqualToString:@"上月"]) {
        minTime = [[NSDate getLastMonthEnd:[NSDate date]] getCurDateEndTime];
    }
    
    return @(minTime);
}

// 预约 获取本周的结束时间
+ (NSNumber *_Nullable)getAppointmentEndTimeByType;
{
    NSTimeInterval minTime=0;
    
    NSDate *weekOneDate;
    
    NSString *curWeek = [[NSDate date] getWeekString];
    
    if ([curWeek isEqualToString:@"周日"]) {
        minTime = [[NSDate date] getCurDateEndTime];
    }
    else if ([curWeek isEqualToString:@"周一"]) {
        // -1 是周天
        NSTimeInterval dayInterval = 24 * 60 * 60 * 6;
        weekOneDate = [NSDate dateWithTimeInterval:+dayInterval sinceDate:[NSDate date]];
        minTime = [weekOneDate getCurDateEndTime];
    }
    else if ([curWeek isEqualToString:@"周二"]) {
        // -2 是周天
        NSTimeInterval dayInterval = 24 * 60 * 60 * 5;
        weekOneDate = [NSDate dateWithTimeInterval:+dayInterval sinceDate:[NSDate date]];
        minTime = [weekOneDate getCurDateEndTime];
    }
    else if ([curWeek isEqualToString:@"周三"]) {
        // -3 是周天
        NSTimeInterval dayInterval = 24 * 60 * 60 * 4;
        weekOneDate = [NSDate dateWithTimeInterval:+dayInterval sinceDate:[NSDate date]];
        minTime = [weekOneDate getCurDateEndTime];
    }
    else if ([curWeek isEqualToString:@"周四"]) {
        // -4 是周天
        NSTimeInterval dayInterval = 24 * 60 * 60 * 3;
        weekOneDate = [NSDate dateWithTimeInterval:+dayInterval sinceDate:[NSDate date]];
        minTime = [weekOneDate getCurDateEndTime];
    }
    else if ([curWeek isEqualToString:@"周五"]) {
        // -5 是周天
        NSTimeInterval dayInterval = 24 * 60 * 60 * 2;
        weekOneDate = [NSDate dateWithTimeInterval:+dayInterval sinceDate:[NSDate date]];
        minTime = [weekOneDate getCurDateEndTime];
    }
    else if ([curWeek isEqualToString:@"周六"]) {
        // -5 是周天
        NSTimeInterval dayInterval = 24 * 60 * 60 * 1;
        weekOneDate = [NSDate dateWithTimeInterval:+dayInterval sinceDate:[NSDate date]];
        minTime = [weekOneDate getCurDateEndTime];
    }
    return @(minTime);

}
#pragma mark - 获取上个月 月初、月末
// 根据所给日期，获取上个月月初
+ (NSDate *)getLastMonthBegin:(NSDate *)date
{
    NSInteger year = [date year];
    NSInteger month = [date month];
    NSInteger day = 1;
    
    if (month!=1) {
        month--;
    }
    else {
        year--;
        month = 12;
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat  = @"yyyy/MM/dd HH:mm:ss";
    
    NSDate *beginDate = [df dateFromString:[NSString stringWithFormat:@"%ld/%ld/%ld 9:14:15", (long)year, month, (long)day]];
    return beginDate;
}

// 根据所给日期，获取上个月月末
+ (NSDate *)getLastMonthEnd:(NSDate *)date
{
    NSInteger year = [date year];
    NSInteger month = [date month];
    NSInteger day = 31;
    
    if (month!=1) {
        // 处理上个月份为2月的特殊情况，
        if (month!=3) {
            // 如果上个月的月份为 4  6  9  11 月份，他们月末是30号
            if (month == 5 || month==7 || month ==10 || month ==12) {
                day = 30;
            }
            else {
                day = 31;
            }
        }
        // 如果本月是3月份，上个月为为2月份，闰年2月月末29天，非闰年28天
        else {
            if ((year%4==0 && year%100!=0) || year%400==0) {
                day = 29;
            }
            else {
                day = 28;
            }
        }
        
        month--;
    }
    else {
        year--;
        month = 12;
        day = 31;
    }
    
    // day
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat  = @"yyyy/MM/dd HH:mm:ss";
    NSDate *beginDate = [df dateFromString:[NSString stringWithFormat:@"%ld/%ld/%ld 9:59:59", year, month, (long)day]];
    return beginDate;
}

@end
