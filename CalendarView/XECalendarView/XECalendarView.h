//
//  CPCalendarView.h
//  日历demo
//
//  Created by 小二 on 2019/6/5.
//  Copyright © 2019年 小二. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XECalendarModel;
@class XECalendarView;

@protocol XECalendarViewDelegate <NSObject>
///点击日期
- (void)xeCalendarView:(XECalendarView *)calendarView didSelectLeaveDate:(NSString *)dateStr;

@end

@interface XECalendarView : UIView
///时间类
@property (nonatomic, strong) NSDate *date;
///标题
@property (nonatomic, strong) NSString *title;
///协议
@property (nonatomic, weak) id<XECalendarViewDelegate>delegate;

/**
 刷新日历视图
 
 @param monthArray 月份（2019-06）
 @param dayArray 日期
 @param otherDateArray 需要特殊处理的日期
 */
- (void)reloadCalendarViewWithMonthArray:(NSArray *)monthArray
                                dayArray:(NSArray *)dayArray
                          otherDateArray:(NSArray *)otherDateArray;

@end

NS_ASSUME_NONNULL_END
