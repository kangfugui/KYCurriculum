//
//  UINavigationBar+KYAdd.m
//  yoyoCurriculum
//
//  Created by 刘成 on 15/12/24.
//  Copyright © 2015年 KangYang. All rights reserved.
//

#import "UINavigationBar+KYAdd.h"

@implementation UINavigationBar (KYAdd)

- (void)customCurriculumNavigationBar
{
    [self setBarTintColor:[UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1]];
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UIImage new]];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],
                                   NSFontAttributeName : [UIFont boldSystemFontOfSize:18]}];
}

@end
