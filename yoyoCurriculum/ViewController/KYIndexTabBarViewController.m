//
//  KYIndexTabBarViewController.m
//  yoyoCurriculum
//
//  Created by 刘成 on 15/12/22.
//  Copyright © 2015年 KangYang. All rights reserved.
//

#import "KYIndexTabBarViewController.h"
#import "KYMonthCurriculumViewController.h"
#import "KYWeekCurriculumViewController.h"
#import "KYDayCurriculumViewController.h"
#import "UINavigationBar+KYAdd.h"
#import <Masonry.h>

@interface KYIndexTabBarViewController ()

@property (strong, nonatomic) UILabel *titleMonthLabel;
@property (strong, nonatomic) UILabel *titleWeekLabel;
@property (strong, nonatomic) UILabel *titleTermLabel;
@property (strong, nonatomic) UIView *buttonsBox;
@property (strong, nonatomic) NSMutableArray<UIButton *> *titleButtons;

@property (strong, nonatomic) UIButton *tabBarTodayButton;
@property (strong, nonatomic) UIButton *tabBarNoteButton;
@property (strong, nonatomic) UILabel *tabBarTodayLabel;
@property (strong, nonatomic) UILabel *tabBarNoteLabel;

@end

@implementation KYIndexTabBarViewController

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    KYMonthCurriculumViewController *month = [KYMonthCurriculumViewController new];
    KYWeekCurriculumViewController *week = [KYWeekCurriculumViewController new];
    KYDayCurriculumViewController *day = [KYDayCurriculumViewController new];
    
    self.viewControllers = @[month,week,day];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleButtons = [[NSMutableArray alloc] initWithCapacity:3];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.navigationController.navigationBar customCurriculumNavigationBar];
        [self _initTabBar];
        [self _initTitleView];
    });
}

- (void)_initTitleView
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44);
    self.navigationItem.titleView = view;
    
    _titleMonthLabel = [[UILabel alloc] init];
    _titleMonthLabel.text = @"2月";
    _titleMonthLabel.font = [UIFont boldSystemFontOfSize:28];
    _titleMonthLabel.textColor = [UIColor blackColor];
    [view addSubview:_titleMonthLabel];
    [_titleMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(view);
    }];
    
    _titleWeekLabel = [[UILabel alloc] init];
    _titleWeekLabel.text = @"第2周";
    _titleWeekLabel.font = [UIFont systemFontOfSize:12];
    _titleWeekLabel.textColor = [UIColor blackColor];
    [view addSubview:_titleWeekLabel];
    [_titleWeekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleMonthLabel).offset(3);
        make.left.equalTo(_titleMonthLabel.mas_right).offset(5);
    }];
    
    _titleTermLabel = [[UILabel alloc] init];
    _titleTermLabel.text = @"2016年下学期";
    _titleTermLabel.font = [UIFont systemFontOfSize:12];
    _titleTermLabel.textColor = [UIColor blackColor];
    [view addSubview:_titleTermLabel];
    [_titleTermLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleWeekLabel.mas_bottom);
        make.left.equalTo(_titleMonthLabel.mas_right).offset(5);
    }];
    
    _buttonsBox = [[UIView alloc] init];
    [view addSubview:_buttonsBox];
    [_buttonsBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(110, 36));
    }];
    
    UIButton *lastButton = nil;
    for (NSString *item in @[@"月",@"周",@"日"])
    {
        UIButton *button = [self _titleButtonWithImage:@"date_background"
                                             highlight:@"date_selected_back"
                                                  text:item];
        [button setSelected:[item isEqualToString:@"月"]];
        [_buttonsBox insertSubview:button atIndex:0];
        [_titleButtons addObject:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_buttonsBox);
            make.size.mas_equalTo(CGSizeMake(40, 36));
            if (lastButton) {
                make.left.equalTo(lastButton.mas_right).offset(-5);
            } else {
                make.left.equalTo(_buttonsBox);
            }
        }];
        
        lastButton = button;
    }
}

- (void)_initTabBar
{
    [self.tabBar.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.tabBar.backgroundImage = [[UIImage alloc] init];
    self.tabBar.shadowImage = [[UIImage alloc] init];
    
    UIImageView *background = [[UIImageView alloc] init];
    background.frame = self.tabBar.bounds;
    background.image = [UIImage imageNamed:@"tabbar_background"];
    background.userInteractionEnabled = YES;
    background.layer.shadowColor = [UIColor grayColor].CGColor;
    background.layer.shadowOpacity = 0.5;
    background.layer.shadowRadius = 1.5;
    background.layer.shadowOffset = CGSizeMake(0, -1.5);
    [self.tabBar addSubview:background];
    
    _tabBarTodayButton = [self _tabBarButtonWithImage:@"today_back"
                                            highlight:@"today_selected_back"
                                                 text:@"今日"];
    [background addSubview:_tabBarTodayButton];
    [_tabBarTodayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@3);
        make.size.mas_equalTo(CGSizeMake(24, 43));
        make.right.equalTo(background).offset(-20);
    }];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger dayOfMonth = [calendar component:NSCalendarUnitDay fromDate:[NSDate date]];
    
    _tabBarTodayLabel = [[UILabel alloc] init];
    _tabBarTodayLabel.font = [UIFont boldSystemFontOfSize:12];
    _tabBarTodayLabel.text = [NSString stringWithFormat:@"%zd",dayOfMonth];
    _tabBarTodayLabel.textColor = [UIColor colorWithRed:0.435 green:0.439 blue:0.443 alpha:1];
    [_tabBarTodayButton addSubview:_tabBarTodayLabel];
    [_tabBarTodayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@7);
        make.centerX.equalTo(_tabBarTodayButton);
    }];
    
    _tabBarNoteButton = [self _tabBarButtonWithImage:@"jishiben_back"
                                           highlight:nil
                                                text:@"记事"];
    [background addSubview:_tabBarNoteButton];
    [_tabBarNoteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@3);
        make.size.mas_equalTo(CGSizeMake(24, 43));
        make.right.equalTo(_tabBarTodayButton.mas_left).offset(-30);
    }];
    
    UIImageView *noteIcon = [[UIImageView alloc] init];
    noteIcon.image = [UIImage imageNamed:@"tixing_background"];
    [background addSubview:noteIcon];
    [noteIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@11);
        make.centerY.equalTo(background);
    }];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    
    _tabBarNoteLabel = [[UILabel alloc] init];
    _tabBarNoteLabel.font = [UIFont systemFontOfSize:13];
    _tabBarNoteLabel.textColor = [UIColor colorWithRed:0.529 green:0.533 blue:0.537 alpha:1];
    _tabBarNoteLabel.text = [formatter stringFromDate:[NSDate date]];
    [background addSubview:_tabBarNoteLabel];
    [_tabBarNoteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(background);
        make.left.equalTo(noteIcon.mas_right).offset(4);
        make.right.lessThanOrEqualTo(_tabBarNoteButton.mas_left).offset(-5);
    }];
}

#pragma mark - event response

- (void)titleButtonSwitchAction:(UIButton *)sender
{
    NSInteger index = [self.titleButtons indexOfObject:sender];
    if (index == self.selectedIndex) return;
    
    UIView *fromView = self.selectedViewController.view;
    UIView *toView = self.viewControllers[index].view;
    
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished) {
         self.selectedViewController = self.viewControllers[index];
     }];
    
    [self.buttonsBox bringSubviewToFront:sender];
    [self.titleButtons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
         obj.selected = NO;
    }];
    sender.selected = YES;
}

#pragma mark - private method

- (UIButton *)_titleButtonWithImage:(NSString *)imageName
                          highlight:(NSString *)highlightImageName
                               text:(NSString *)text
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateSelected];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button addTarget:self action:@selector(titleButtonSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIButton *)_tabBarButtonWithImage:(NSString *)imageName
                           highlight:(NSString *)highlightImageName
                                text:(NSString *)text
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    
    if (highlightImageName && highlightImageName.length > 0) {
        [button setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:0.612 green:0.616 blue:0.620 alpha:1];
    label.text = text;
    label.font = [UIFont systemFontOfSize:12];
    [button addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(button);
    }];
    
    return button;
}

@end
