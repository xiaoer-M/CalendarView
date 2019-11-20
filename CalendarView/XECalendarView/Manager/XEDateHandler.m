//
//  CPDateHandler.m
//  日历demo
//
//  Created by 小二 on 2019/6/12.
//  Copyright © 2019年 小二. All rights reserved.
//

#import "XEDateHandler.h"
#import "XECalendarModel.h"

#define ChineseMonths @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",@"九月", @"十月", @"冬月", @"腊月"]
#define ChineseDays @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"]

@interface XEDateHandler()
///时间格式类
@property (nonatomic, strong) NSDateFormatter *dateFormattor;
///月份格式类
@property (nonatomic, strong) NSDateFormatter *monthDateFormattor;
///阳历对应的节日
@property (nonatomic, strong) NSDictionary *dateFestivalDic;

@end

@implementation XEDateHandler

/// 获取date当前月的第一天是星期几
- (NSInteger)weekdayOfFirstDayInDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [components setDay:1];
    NSDate *firstDate = [calendar dateFromComponents:components];
    NSDateComponents *firstComponents = [calendar components:NSCalendarUnitWeekday fromDate:firstDate];
    return firstComponents.weekday - 1;
}

/// 获取date当前月的总天数
- (NSInteger)totalDaysInMonthOfDate:(NSDate *)date {
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

/// 获取某月day的日期
- (NSDate *)dateOfMonth:(XECalendarMonth)calendarMonth withDay:(NSInteger)day withDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *presentDate;
    
    switch (calendarMonth) {
        case XECalendarMonthPrevious:
            presentDate = [self previousMonthDate:date];
            break;
            
        case XECalendarMonthCurrent:
            presentDate = date;
            break;
            
        case XECalendarMonthNext:
            presentDate = [self nextMonthDate:date];
            break;
        default:
            break;
    }
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:presentDate];
    [components setDay:day];
    NSDate *dateOfDay = [calendar dateFromComponents:components];
    return dateOfDay;
}


/// 获取date的上个月日期
- (NSDate *)previousMonthDate:(NSDate *)date {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -1;
    NSDate *previousMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:NSCalendarMatchStrictly];
    return previousMonthDate;
}


/// 获取date的下个月日期
- (NSDate *)nextMonthDate:(NSDate *)date {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 1;
    NSDate *nextMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:NSCalendarMatchStrictly];
    return nextMonthDate;
}


/// 获取date当天的农历
- (NSString *)chineseCalendarOfDate:(NSDate *)date {
    //阳历节日
    self.dateFestivalDic = [NSDictionary dictionaryWithObjectsAndKeys:@"元旦节",@"01月01日",@"妇女节",@"03月08日",@"植树节",@"03月12日",@"劳动节",@"05月01日",@"青年节",@"05月04日",@"儿童节",@"06月01日",@"建党节",@"07月01日",@"建军节",@"08月01日",@"教师节",@"09月10日",@"国庆节",@"10月01日", nil];
    
    NSString *day;
    NSCalendar *chineseCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *components = [chineseCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    if (components.day == 1) {
        day = ChineseMonths[components.month - 1];
    } else {
        day = ChineseDays[components.day - 1];
    }
    NSString * dateStr = [self transformMMdd:date];
    for (int i = 0; i<self.self.dateFestivalDic.allKeys.count; i++) {
        if ([self.dateFestivalDic.allKeys[i] isEqualToString:dateStr]) {
            day = self.dateFestivalDic.allValues[i];
            break;
        }
    }
    return day;
}

///时间格式转化
- (NSString *)transformMMdd:(NSDate *)date {
    if (!_dateFormattor) {
        _dateFormattor = [[NSDateFormatter alloc] init];
        [_dateFormattor setDateFormat:@"MM月dd日"];
    }
    return [_dateFormattor stringFromDate:date];
}

///月份转化为date格式
- (NSDate *)transformMonthStrToDate:(NSString *)monthStr {
    if (!_monthDateFormattor) {
        _monthDateFormattor = [[NSDateFormatter alloc] init];
        [_monthDateFormattor setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSString *timeStr = [NSString stringWithFormat:@"%@-01 00:00:00",monthStr];
    NSDate *date = [_monthDateFormattor dateFromString:timeStr];
    return date;
}

- (NSMutableArray *)generateCalendarDataSourceWithMonthArray:(NSArray *)monthArr
                                           canChooseDayArray:(NSArray *)dayArray
                                               otherDayArray:(NSArray *)otherDayArray {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < monthArr.count; i++) {
        NSString *monthStr = monthArr[i];
        
        NSInteger firstWeekday = [self weekdayOfFirstDayInDate:[self transformMonthStrToDate:monthArr[i]]];
        NSInteger totalDaysOfMonth = [self totalDaysInMonthOfDate:[self transformMonthStrToDate:monthArr[i]]];
        NSInteger totalDaysOfLastMonth = [self totalDaysInMonthOfDate:[self previousMonthDate:[self transformMonthStrToDate:monthArr[i]]]];
        
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        for (NSInteger j = 0; j < 42; j++) {
            //需要配置的model参数
            XECalendarCellStyle style = XECalendarCellStyleGeneral;
            BOOL isLeaved = NO;
            NSString *dateStr = @"";
            NSInteger day = 0;
            
            //日历时间判断
            if (j < firstWeekday) {
                // 小于这个月的第一天
                day = totalDaysOfLastMonth - firstWeekday + j + 1;
            } else if (j >= totalDaysOfMonth + firstWeekday) {
                // 大于这个月的最后一天
                day = j - totalDaysOfMonth - firstWeekday + 1;
            } else {
                // 属于这个月
                day = j - firstWeekday + 1;
                if (day < 10) {
                    dateStr = [NSString stringWithFormat:@"%@-0%ld",monthStr,(long)day];
                } else {
                    dateStr = [NSString stringWithFormat:@"%@-%ld",monthStr,(long)day];
                }
                
                //可选和已选判断
                if ([dayArray containsObject:dateStr]) {
                    style = XECalendarCellStyleChoice;
                    if ([otherDayArray containsObject:dateStr]) {
                        style = XECalendarCellStyleSelected;
                        isLeaved = YES;
                    }
                }
                
                // 如果日期和当期日期同年同月不同天, 注：第一个判断中的方法是iOS8的新API, 会比较传入单元以及比传入单元大得单元上数据是否相等，亲测同时传入Year和Month结果错误
                if ([[NSCalendar currentCalendar] isDate:[NSDate date] equalToDate:[self transformMonthStrToDate:monthArr[i]] toUnitGranularity:NSCalendarUnitMonth]) {
                    // 将当前日期的那天高亮显示
                    if (day == [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:[NSDate date]]) {
                    }
                }
            }
            
            XECalendarModel *calendarModel = [[XECalendarModel alloc] init];
            calendarModel.dayStr = [NSString stringWithFormat:@"%ld",(long)day];
            calendarModel.dateStr = dateStr;
            calendarModel.style = style;
            calendarModel.isLeaved = isLeaved;
            [sectionArr addObject:calendarModel];
        }
        [dataArray addObject:sectionArr];
    }
    return dataArray;
}

@end
