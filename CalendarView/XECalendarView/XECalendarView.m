//
//  CPCalendarView.m
//  日历demo
//
//  Created by 小二 on 2019/6/5.
//  Copyright © 2019年 小二. All rights reserved.
//

#import "XECalendarView.h"
#import "XECalendarCell.h"
#import "XECalendarHeader.h"
#import "XEDateHandler.h"

#define kXEScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

static const CGFloat calendarViewWidth = 280;
static const CGFloat hiddenClassHeight = 330;
static const CGFloat headerHeight = 70;

@interface XECalendarView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayot;
@property (nonatomic, strong) XEDateHandler *dateHandler;
@property (nonatomic, strong) XECalendarHeader *header;

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSArray *monthArray;
@property (nonatomic, assign) CGFloat showClassHeight;
@property (nonatomic, strong) NSString *selectDate;
@property (nonatomic, strong) NSIndexPath *oldIndexPath; //单选
@property (nonatomic, strong) NSMutableArray *dataArray;  //数据源

@end

@implementation XECalendarView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake((kXEScreenWidth - calendarViewWidth)/2, 88, calendarViewWidth, hiddenClassHeight);
    [self addSubview:self.header];
    [self addSubview:self.collectionView];
}

- (void)setDate:(NSDate *)date {
    _date = date;
    [self.collectionView reloadData];
}

- (void)reloadCalendarViewWithMonthArray:(NSArray *)monthArray
                                dayArray:(NSArray *)dayArray
                          otherDateArray:(NSArray *)otherDateArray {
    self.monthArray = monthArray;
    // 标题
    for (NSInteger i = 0; i < monthArray.count; i++) {
        NSString *monthStr = monthArray[i];
        NSArray *array = [monthStr componentsSeparatedByString:@"-"];
        NSString *title = [NSString stringWithFormat:@"%@年%@月",array[0],array[1]];
        [self.titleArray addObject:title];
    }
    [self.header headerWithTitle:_title];
    
    // 生成日历数据源
    self.dataArray = [self.dateHandler generateCalendarDataSourceWithMonthArray:monthArray
                                                              canChooseDayArray:dayArray otherDayArray:otherDateArray];
    [self.collectionView reloadData];
}

- (void)layoutSubviews {
    CGFloat itemWidth = calendarViewWidth/7;
    self.flowLayot.itemSize = CGSizeMake(itemWidth, itemWidth - 8);
    self.flowLayot.headerReferenceSize = CGSizeMake(calendarViewWidth, 35);
    self.collectionView.frame = CGRectMake(0, headerHeight, calendarViewWidth, hiddenClassHeight - headerHeight);
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.monthArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 42;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CPCalendarMonthHeader" forIndexPath:indexPath];
        UILabel *monthLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, header.frame.size.width, header.frame.size.height)];
        monthLb.textAlignment = NSTextAlignmentCenter;
        monthLb.text = self.titleArray[indexPath.section];
        monthLb.font = [UIFont systemFontOfSize:15];
        monthLb.backgroundColor = [UIColor whiteColor];
        monthLb.layer.masksToBounds = YES;
        [header addSubview:monthLb];
        reusableView = header;
    }
    return reusableView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CPCalendarCell";
    XECalendarCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    XECalendarModel *calendarModel = self.dataArray[indexPath.section][indexPath.row];
    [cell reloadCellWithModel:calendarModel];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //点同一个日期
    if ([_oldIndexPath isEqual:indexPath]) {
        return;
    }
    
    XECalendarCell *selCell = (XECalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    XECalendarModel *model = self.dataArray[indexPath.section][indexPath.row];
    model.style = XECalendarCellStyleSelected;
    [selCell reloadCellWithModel:model];
    
    if (_oldIndexPath) {
        XECalendarCell *oldCell = (XECalendarCell *)[collectionView cellForItemAtIndexPath:_oldIndexPath];
        XECalendarModel *oldModel = self.dataArray[_oldIndexPath.section][_oldIndexPath.row];
        oldModel.style = XECalendarCellStyleChoice;
        [oldCell reloadCellWithModel:oldModel];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(xeCalendarView:didSelectLeaveDate:)]) {
        [self.delegate xeCalendarView:self didSelectLeaveDate:model.dateStr];
    }
    
    _selectDate = model.dateStr;
    _oldIndexPath = indexPath;
}

#pragma mark - getter/setter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayot];
        [self addSubview:_collectionView];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[XECalendarCell class] forCellWithReuseIdentifier:@"CPCalendarCell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CPCalendarMonthHeader"];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayot {
    if (!_flowLayot) {
        _flowLayot = [[UICollectionViewFlowLayout alloc] init];
        _flowLayot.sectionInset = UIEdgeInsetsZero;
        _flowLayot.minimumLineSpacing = 0;
        _flowLayot.minimumInteritemSpacing = 0;
    }
    return _flowLayot;
}

- (XEDateHandler *)dateHandler {
    if (!_dateHandler) {
        _dateHandler = [[XEDateHandler alloc] init];
    }
    return _dateHandler;
}

- (XECalendarHeader *)header {
    if (!_header) {
        _header = [[XECalendarHeader alloc] initWithFrame:CGRectMake(0, 0, calendarViewWidth, headerHeight)];
    }
    return _header;
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] init];
    }
    return _titleArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
