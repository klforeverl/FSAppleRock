//
//  NSDate+Utility.h
//  QuickSale
//
//  Created by zhanglan on 15/8/6.
//  Copyright (c) 2015年 fangstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utility)

- (NSString *)getYear;
- (NSString *)getMonth;
- (NSString *)getDay;
- (NSString *)getHour;
- (NSString *)getMinute;

- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;

//- (NSMutableArray *)getDateArrayOfBeforeAndAfter:(NSInteger)interval;
- (NSString *)getWeekString;
- (NSDate *)dateWithYMD;
+ (NSDate *)date:(NSString *)datestr WithFormat:(NSString *)format;
- (NSString *)stringWithFormat:(NSString *)format;

+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

@end
