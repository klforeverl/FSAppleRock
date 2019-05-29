//
//  NSDate+FSUtility.h
//  FSAppleRock
//
//  Created by ZhangLan_PC on 16/7/11.
//  Copyright © 2016年 fangstar.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Utility.h"

@interface NSDate (FSUtility)

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, readonly) NSInteger year; ///< Year component
@property (nonatomic, readonly) NSInteger month; ///< Month component (1~12)
@property (nonatomic, readonly) NSInteger day; ///< Day component (1~31)
@property (nonatomic, readonly) NSInteger hour; ///< Hour component (0~23)
@property (nonatomic, readonly) NSInteger minute; ///< Minute component (0~59)
@property (nonatomic, readonly) NSInteger second; ///< Second component (0~59)
@property (nonatomic, readonly) NSInteger weekday; ///< Weekday component (1~7, first day is based on user setting)

@property (nonatomic, readonly) NSInteger weekOfMonth; ///< WeekOfMonth component (1~5)

- (NSMutableArray *)getDateArrayOfBeforeAndAfter:(NSInteger)interval;

+ (NSString *)getDateStringByTimeInteval:(NSInteger)timeInteval formatString:(NSString *)formatString;

- (nullable NSString *)stringWithFormat:(NSString *)format;

- (NSString *)stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale;

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale;

+ (NSString *)timeIntervalSince1970:(NSTimeInterval)secs Format:(NSString*)formatestr;
NS_ASSUME_NONNULL_END

// 根据类型 获取起点时间
+ (NSNumber *_Nullable)getMinTimeByType:(NSString *_Nullable)timeType;
// 根据类型 获取结束时间
+ (NSNumber *_Nullable)getEndTimeByType:(NSString *_Nullable)timeType;

#pragma mark - 获取给定日期的 23：59：59
// 获取某个日期终点
- (NSTimeInterval)getCurDateEndTime;
#pragma mark - 获取给定日期的 0点
// 获取某个日期起点
- (NSTimeInterval)getCurDateStartTime;

// 预约 获取本周的结束时间
+ (NSNumber *_Nullable)getAppointmentEndTimeByType;
@end
