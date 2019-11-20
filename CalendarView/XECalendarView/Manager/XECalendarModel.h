//
//  CPCalendarModel.h
//  日历demo
//
//  Created by 小二 on 2019/6/5.
//  Copyright © 2019年 小二. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XECalendarCellStyle) {
    XECalendarCellStyleGeneral,  //普通
    XECalendarCellStyleChoice,   //可选
    XECalendarCellStyleSelected  //选中
};

@interface XECalendarModel : NSObject

@property (nonatomic, strong) NSString *dayStr;
@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, assign) XECalendarCellStyle style;
@property (nonatomic, assign) BOOL isLeaved;

@end

NS_ASSUME_NONNULL_END
