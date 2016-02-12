//
//  KYWeekCurriculumViewController.m
//  yoyoCurriculum
//
//  Created by 刘成 on 15/12/22.
//  Copyright © 2015年 KangYang. All rights reserved.
//

#import "KYWeekCurriculumViewController.h"
#import "KYWeekCurriculumViewCell.h"
#import <JTCalendar.h>
#import <Masonry.h>

@interface KYWeekCurriculumViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,JTCalendarDelegate>
{
    NSDate *_dateSelected;
}

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) JTHorizontalCalendarView *calendarContentView;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation KYWeekCurriculumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.929 green:0.933 blue:0.941 alpha:1];
    [self _initCalendar];
    [self _initCurriculum];
    [self _initTestData];
}

- (void)_initCalendar
{
    _calendarContentView = [[JTHorizontalCalendarView alloc] init];
    _calendarContentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_calendarContentView];
    [_calendarContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@64);
        make.left.equalTo(@15);
        make.height.equalTo(@85);
        make.right.equalTo(self.view);
    }];
    
    UIView *space = [[UIView alloc] init];
    space.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:space];
    [space mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.width.equalTo(@15);
        make.top.height.equalTo(_calendarContentView);
    }];
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.settings.weekModeEnabled = YES;
    _calendarManager.delegate = self;
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
}

- (void)_initCurriculum
{
    CGRect rect = self.view.bounds;
    rect.origin.y = 64 + 85;
    rect.size.height -= (64 + 85 + 49);
    
    UIImageView *background = [[UIImageView alloc] init];
    background.frame = rect;
    background.image = [UIImage imageNamed:@"curriculum_bg.jpg"];
    [self.view addSubview:background];
    [self.view addSubview:self.collectionView];
}

#pragma mark - CalendarManager delegate

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    if ([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]) {
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor colorWithRed:1 green:0.792 blue:0 alpha:1];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    } else if (_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]) {
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    } else if (![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]) {
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

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseIdentifer" forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    ((KYWeekCurriculumViewCell *)cell).scrollView.contentOffset = CGPointZero;
    
    NSDate *date = self.dataSource[indexPath.item];
    _dateSelected = date;
    [_calendarManager reload];
    
    NSInteger weekday = [_calendarManager.dateHelper.calendar component:NSCalendarUnitWeekday fromDate:date];
    
    if (![_calendarManager.dateHelper date:_calendarContentView.date isTheSameWeekThan:date]) {
        if ([_calendarContentView.date compare:date] == NSOrderedAscending) {
            if (weekday > 1) {
                [_calendarContentView loadNextPageWithAnimation];
            }
        } else {
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
    else if (weekday == 1) {
        [_calendarContentView loadPreviousPageWithAnimation];
    }
}

#pragma mark - private method

- (BOOL)haveEventForDay:(NSDate *)date
{
    return NO;
}

- (void)_initTestData
{
    self.dataSource = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        NSDate *date = [[NSDate date] dateByAddingTimeInterval:(60 * 60 * 24 * i)];
        [self.dataSource addObject:date];
    }
}

#pragma mark - getters and setters

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CGRect rect = self.view.bounds;
        rect.origin.y = 64 + 85;
        rect.size.height -= (64 + 85 + 49);
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.itemSize = CGSizeMake(rect.size.width, rect.size.height);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:rect
                                             collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[KYWeekCurriculumViewCell class]
            forCellWithReuseIdentifier:@"reuseIdentifer"];
    }
    return _collectionView;
}

@end
