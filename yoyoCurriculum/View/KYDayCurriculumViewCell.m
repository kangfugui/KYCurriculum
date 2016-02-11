//
//  KYDayCurriculumViewCell.m
//  yoyoCurriculum
//
//  Created by 刘成 on 15/12/24.
//  Copyright © 2015年 KangYang. All rights reserved.
//

#import "KYDayCurriculumViewCell.h"

@implementation KYDayCurriculumViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self _initTableView];
    
    return self;
}

- (void)_initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = self.backgroundColor;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
}

@end
