//
//  ViewController.m
//  CalendarView
//
//  Created by 小二 on 2019/11/19.
//  Copyright © 2019 小二. All rights reserved.
//

#import "ViewController.h"
#import "XECalendarView.h"

@interface ViewController ()<XECalendarViewDelegate>
@property (nonatomic, strong) XECalendarView *calendarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:self.calendarView];
    
    [self getRequestData];
}

- (void)getRequestData {
    NSArray *dataArray = @[@{@"operDate": @"2019-11-20"},@{@"operDate": @"2019-11-21"},@{@"operDate": @"2019-11-22"},@{@"operDate": @"2019-12-02"},@{@"operDate": @"2019-12-03"},@{@"operDate": @"2019-12-04"},@{@"operDate": @"2020-01-02"},@{@"operDate": @"2020-01-03"},@{@"operDate": @"2020-01-04"}];
    
    NSArray *otherDataArr = @[@"2019-11-20",@"2019-12-03",@"2020-01-03"];
    
    NSMutableArray *operDateArray = [[NSMutableArray alloc] init];
    NSMutableArray *monthArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in dataArray) {
        NSString *dateStr = dic[@"operDate"];
        [operDateArray addObject:dateStr];
        
        NSString *yearMonthStr = [dateStr substringToIndex:7]; //结果：2019-06
        if (![monthArray containsObject:yearMonthStr]) {
            [monthArray addObject:yearMonthStr];
        }
    }
    
    [self.calendarView reloadCalendarViewWithMonthArray:monthArray dayArray:operDateArray otherDateArray:otherDataArr];
}

#pragma mark - XECalendarViewDelegate
-(void)xeCalendarView:(id)calendarView didSelectLeaveDate:(NSString *)dateStr {
    
}

#pragma mark - getter/setter
- (XECalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[XECalendarView alloc] init];
        _calendarView.delegate = self;
        _calendarView.title = @"简单日历";
    }
    return _calendarView;
}


@end
