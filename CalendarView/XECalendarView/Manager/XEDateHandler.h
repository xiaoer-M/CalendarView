//
//  CPDateHandler.h
//  日历demo
//
//  Created by 小二 on 2019/6/12.
//  Copyright © 2019年 小二. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, XECalendarMonth) {
    XECalendarMonthPrevious = 0, //上个月
    XECalendarMonthCurrent = 1,  //现在的月份
    XECalendarMonthNext = 2,     //下个月
};

NS_ASSUME_NONNULL_BEGIN

@interface XEDateHandler : NSObject

/**
 获取date当前月的第一天是星期几

 @return 星期
 */
- (NSInteger)weekdayOfFirstDayInDate:(NSDate *)date;

/**
 获取date当前月的总天数

 @param date 日期
 @return 天数
 */
- (NSInteger)totalDaysInMonthOfDate:(NSDate *)date;

/**
 获取某月day的日期

 @param calendarMonth 月份
 @param day 天数·
 @return 日期
 */
- (NSDate *)dateOfMonth:(XECalendarMonth)calendarMonth withDay:(NSInteger)day withDate:(NSDate *)date;

/**
 获取date的上个月日期

 @return 日期
 */
- (NSDate *)previousMonthDate:(NSDate *)date;

/**
 获取date的下个月日期

 @return 日期
 */
- (NSDate *)nextMonthDate:(NSDate *)date;

/**
 获取date当天的农历

 @param date 新历日期
 @return 农历
 */
- (NSString *)chineseCalendarOfDate:(NSDate *)date;

/**
 月份转化为date格式

 @param monthStr 月份（2019-06）
 @return date
 */
- (NSDate *)transformMonthStrToDate:(NSString *)monthStr;

/**
 生成日历时间数据源

 @param monthArr 月份（2019-06）
 @param dayArray 日期
 @param otherDayArray 需要特殊处理的日期
 @return 回调
 */
- (NSMutableArray *)generateCalendarDataSourceWithMonthArray:(NSArray *)monthArr
                                           canChooseDayArray:(NSArray *)dayArray
                                               otherDayArray:(NSArray *)otherDayArray;

@end

NS_ASSUME_NONNULL_END
