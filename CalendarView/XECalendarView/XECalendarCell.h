//
//  CPCalendarCell.h
//  日历demo
//
//  Created by 小二 on 2019/6/5.
//  Copyright © 2019年 小二. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XECalendarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XECalendarCell : UICollectionViewCell

- (void)reloadCellWithModel:(XECalendarModel *)model;

@end

NS_ASSUME_NONNULL_END
