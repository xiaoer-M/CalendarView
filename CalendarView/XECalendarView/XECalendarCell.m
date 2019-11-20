//
//  CPCalendarCell.m
//  日历demo
//
//  Created by 小二 on 2019/6/5.
//  Copyright © 2019年 小二. All rights reserved.
//

#import "XECalendarCell.h"

@interface XECalendarCell()
///新历时间
@property (nonatomic, strong) UILabel *dayLabel;
///有出行状态图片
@property (nonatomic, strong) UIImageView *hbbImageView;

@end

@implementation XECalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.dayLabel];
}

- (void)reloadCellWithModel:(XECalendarModel *)model {
    self.dayLabel.text = model.dayStr;
    
    if (model.isLeaved) {
        self.dayLabel.textColor = [UIColor yellowColor];
        self.hbbImageView.hidden = NO;
        self.userInteractionEnabled = YES;
        return;
    }
    
    if (model.style == XECalendarCellStyleGeneral) {
        self.dayLabel.textColor = [UIColor grayColor];
        self.hbbImageView.hidden = YES;
        self.userInteractionEnabled = NO;
    } else if (model.style == XECalendarCellStyleChoice) {
        self.dayLabel.textColor = [UIColor blackColor];
        self.userInteractionEnabled = YES;
        self.hbbImageView.hidden = YES;
    } else {
        self.dayLabel.textColor = [UIColor yellowColor];
        self.hbbImageView.hidden = NO;
        self.userInteractionEnabled = YES;
    }
}

#pragma mark - getter/setter
- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.font = [UIFont systemFontOfSize:15];
    }
    return _dayLabel;
}

- (UIImageView *)hbbImageView {
    // 需要的时候再创建
    if (!_hbbImageView) {
        _hbbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 0, self.bounds.size.height, self.bounds.size.height)];
        _hbbImageView.backgroundColor = [UIColor blackColor];
        _hbbImageView.layer.cornerRadius = _hbbImageView.frame.size.height/2;
        _hbbImageView.layer.masksToBounds = YES;
        [self insertSubview:self.hbbImageView belowSubview:self.dayLabel];
    }
    return _hbbImageView;
}

@end
