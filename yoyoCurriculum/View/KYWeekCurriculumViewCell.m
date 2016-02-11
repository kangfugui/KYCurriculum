//
//  KYWeekCurriculumViewCell.m
//  yoyoCurriculum
//
//  Created by 刘成 on 15/12/22.
//  Copyright © 2015年 KangYang. All rights reserved.
//

#import "KYWeekCurriculumViewCell.h"
#import "KYCurriculumMapView.h"

#define kLeftWidth 15
#define kGridSize (CGRectGetWidth(self.frame) - kLeftWidth) / 7

@implementation KYWeekCurriculumViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self addSubview:self.scrollView];
    [self _initSessions];
    [self _initLines];
    [self configGrids];
    
    return self;
}

- (void)_initSessions
{
    UIView *leftBackground = [[UIView alloc] init];
    leftBackground.frame = CGRectMake(0, 0, kLeftWidth, self.scrollView.contentSize.height);
    leftBackground.backgroundColor = [UIColor colorWithRed:0.463 green:0.800 blue:0.075 alpha:1];
    [self.scrollView addSubview:leftBackground];
    
    for (int i = 0; i < 12; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, kLeftWidth, 20);
        label.center = CGPointMake(kLeftWidth / 2, (kGridSize / 2) + (i * kGridSize));
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%d",i+1];
        [self.scrollView addSubview:label];
    }
}

- (void)_initLines
{
    for (int j = 0; j < 7; j++) {
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path setLineWidth:0.5];
        [path moveToPoint:CGPointMake(kGridSize * j + kLeftWidth, 0)];
        [path addLineToPoint:CGPointMake(kGridSize * j + kLeftWidth,
                                         self.scrollView.contentSize.height)];
        
        CAShapeLayer *verticalLine = [CAShapeLayer layer];
        verticalLine.path = path.CGPath;
        verticalLine.fillColor = [UIColor clearColor].CGColor;
        verticalLine.strokeColor = [UIColor colorWithRed:0.741 green:0.839 blue:0.871 alpha:1].CGColor;
        [self.scrollView.layer addSublayer:verticalLine];
    }
    
    for (int i = 0; i < 20; i++) {
        
        CGFloat y = kGridSize * i;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path setLineWidth:0.5];
        [path moveToPoint:CGPointMake(0, y)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), y)];
        [path closePath];
        
        CAShapeLayer *horizontalLine = [CAShapeLayer layer];
        horizontalLine.path = path.CGPath;
        horizontalLine.fillColor = [UIColor clearColor].CGColor;
        horizontalLine.strokeColor = [UIColor colorWithRed:0.741 green:0.839 blue:0.871 alpha:1].CGColor;
        [self.scrollView.layer addSublayer:horizontalLine];
    }
}

- (void)configGrids
{
    CGRect rect = CGRectMake(kLeftWidth, 0, CGRectGetWidth(self.bounds) - kLeftWidth,
                             self.scrollView.contentSize.height);
    KYCurriculumMapView *mapView = [[KYCurriculumMapView alloc] initWithFrame:rect];
    [self.scrollView addSubview:mapView];
    [mapView display];
}

#pragma mark - getters and setters

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), kGridSize * 19);
    }
    return _scrollView;
}

@end
