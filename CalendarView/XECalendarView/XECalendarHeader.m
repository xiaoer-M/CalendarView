//
//  CPCalendarHeader.m
//  日历demo
//
//  Created by 小二 on 2019/6/11.
//  Copyright © 2019年 小二. All rights reserved.
//

#import "XECalendarHeader.h"

#define Weekdays @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"]
#define TitleHeight 40

@interface XECalendarHeader()
@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation XECalendarHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.titleLb];
    
    NSInteger count = [Weekdays count];
    CGFloat offsetX = 10;
    for (int i = 0; i < count; i++) {
        UILabel *weekDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, TitleHeight, (self.frame.size.width - 20)/ count, self.frame.size.height - TitleHeight)];
        weekDayLabel.textAlignment = NSTextAlignmentCenter;
        weekDayLabel.text = Weekdays[i];
        weekDayLabel.textColor = [UIColor yellowColor];
        weekDayLabel.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:weekDayLabel];
        offsetX += weekDayLabel.frame.size.width;
    }
}

- (void)headerWithTitle:(NSString *)title {
    self.titleLb.text = title;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.frame = CGRectMake(0, 0, self.frame.size.width, TitleHeight);
        _titleLb.font = [UIFont systemFontOfSize:16];
        _titleLb.textColor = [UIColor blackColor];
        _titleLb.backgroundColor = [UIColor orangeColor];
        _titleLb.layer.masksToBounds = YES;
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}

@end
