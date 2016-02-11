//
//  KYDayTimeTableViewCell.m
//  yoyoCurriculum
//
//  Created by 刘成 on 15/12/23.
//  Copyright © 2015年 KangYang. All rights reserved.
//

#import "KYDayTimeTableViewCell.h"
#import <Masonry.h>

@interface KYDayTimeTableViewCell ()

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *courseLabel;
@property (strong, nonatomic) UILabel *addrLabel;
@property (strong, nonatomic) UILabel *teacherLabel;

@end

@implementation KYDayTimeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self _initLines];
    [self _initLabels];
    
    return self;
}

- (void)_initLines
{
    UIColor *color = [UIColor colorWithRed:0.745 green:0.749 blue:0.753 alpha:1];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = color;
    [self.contentView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.right.bottom.equalTo(self.contentView);
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = color;
    [self.contentView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.width.equalTo(@0.5);
        make.top.bottom.equalTo(self.contentView);
    }];
}

- (void)_initLabels
{
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.text = @"9:00";
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.width.greaterThanOrEqualTo(@40);
        make.centerY.equalTo(self.contentView);
    }];
    
    _courseLabel = [[UILabel alloc] init];
    _courseLabel.font = [UIFont systemFontOfSize:14];
    _courseLabel.textColor = [UIColor blackColor];
    _courseLabel.text = @"高等数学";
    [self.contentView addSubview:_courseLabel];
    [_courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@8);
        make.left.equalTo(@55);
    }];
    
    _addrLabel = [[UILabel alloc] init];
    _addrLabel.font = [UIFont systemFontOfSize:12];
    _addrLabel.textColor = [UIColor blackColor];
    _addrLabel.text = @"地点：A3教学楼102教室";
    [self.contentView addSubview:_addrLabel];
    [_addrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_courseLabel);
        make.top.equalTo(_courseLabel.mas_bottom).offset(3);
    }];
    
    _teacherLabel = [[UILabel alloc] init];
    _teacherLabel.font = [UIFont systemFontOfSize:12];
    _teacherLabel.textColor = [UIColor blackColor];
    _teacherLabel.text = @"老师：小华";
    [self.contentView addSubview:_teacherLabel];
    [_teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addrLabel);
        make.left.equalTo(_addrLabel.mas_right).offset(10);
    }];
}

@end
