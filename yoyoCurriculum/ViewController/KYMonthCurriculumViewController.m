//
//  KYMonthCurriculumViewController.m
//  yoyoCurriculum
//
//  Created by 刘成 on 15/12/22.
//  Copyright © 2015年 KangYang. All rights reserved.
//

#import "KYMonthCurriculumViewController.h"
#import <JTCalendar.h>
#import <Masonry.h>

@interface KYMonthCurriculumViewController ()<JTCalendarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSDate *_dateSelected;
}

@property (strong, nonatomic) JTHorizontalCalendarView *calendarContentView;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<__kindof NSArray *> *allCurriculum;
@property (assign, nonatomic) NSInteger currentDayIndex;

@end

@implementation KYMonthCurriculumViewController

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.929 green:0.933 blue:0.941 alpha:1];
    
    [self _initCalendar];
    [self _initTableView];
    [self _initTestData];
}

- (void)_initCalendar
{
    _calendarContentView = [[JTHorizontalCalendarView alloc] init];
    _calendarContentView.backgroundColor = [UIColor whiteColor];
    _calendarContentView.clipsToBounds = YES;
    _calendarContentView.layer.shadowColor = [UIColor grayColor].CGColor;
    _calendarContentView.layer.shadowOpacity = 0.5;
    _calendarContentView.layer.shadowRadius = 1.5;
    _calendarContentView.layer.shadowOffset = CGSizeMake(0, -1.5);
    [self.view addSubview:_calendarContentView];
    [_calendarContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@64);
        make.height.equalTo(@300);
        make.width.equalTo(self.view);
    }];
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
}

- (void)_initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseableIdentifier"];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-49);
        make.top.equalTo(_calendarContentView.mas_bottom);
    }];
}

#pragma makr - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allCurriculum[self.currentDayIndex].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 22;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseableIdentifier"
                                                            forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = self.allCurriculum[self.currentDayIndex][indexPath.row];
    cell.backgroundColor = self.view.backgroundColor;
    
    return cell;
}

#pragma mark - CalendarManager delegate

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    if ([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]) {
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor colorWithRed:1 green:0.792 blue:0 alpha:1];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    } else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]) {
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    } else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]) {
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    } else {
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    dayView.dotView.hidden = ![self haveEventForDay:dayView.date];
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    }
                    completion:nil];
    
    if (![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]) {
        if ([_calendarContentView.date compare:dayView.date] == NSOrderedAscending) {
            [_calendarContentView loadNextPageWithAnimation];
        } else {
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
    
    self.currentDayIndex += 1;
    if (self.currentDayIndex >= 5) self.currentDayIndex = 0;
    [self.tableView reloadData];
}

#pragma mark - CalendarManager delegate - Page mangement

- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return YES;
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    
}

#pragma mark - private method

- (BOOL)haveEventForDay:(NSDate *)date
{
    return NO;
}

- (void)_initTestData
{
    self.allCurriculum = [[NSMutableArray alloc] init];
    NSArray *subject = @[@"语文 (A3教学楼108教室)",
                         @"数学 (A11教学楼108教室)",
                         @"物理 (A5教学楼442教室)",
                         @"化学 (B20教学楼337教室)",
                         @"英语 (C3教学楼3305教室)"];
    
    for (int i = 0; i < 5; i++) {
        
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        [self.allCurriculum addObject:temp];
        
        for (int j = 0; j < 12; j++) {
            [temp addObject:[NSString stringWithFormat:@"%d:00 %@",(j+8),subject[i]]];
        }
    }
}

@end
