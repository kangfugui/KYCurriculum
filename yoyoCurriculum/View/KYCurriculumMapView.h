//
//  KYCurriculumMapView.h
//  yoyoCurriculum
//
//  Created by 刘成 on 15/12/25.
//  Copyright © 2015年 KangYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYCurriculumMapView : UIView

@property (copy, nonatomic) NSArray<UIColor *> *bgColors;

- (void)display;

@end

@interface KYCurriculumGridView : UIView

@property (strong, nonatomic) UILabel *label;

- (void)updateWithString:(NSString *)text;

@end
