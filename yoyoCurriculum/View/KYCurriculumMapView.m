//
//  KYCurriculumMapView.m
//  yoyoCurriculum
//
//  Created by 刘成 on 15/12/25.
//  Copyright © 2015年 KangYang. All rights reserved.
//

#import "KYCurriculumMapView.h"

@implementation KYCurriculumMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    return self;
}

- (NSArray<UIColor *> *)bgColors
{
    if (!_bgColors)
    {
        _bgColors = @[[UIColor colorWithRed:0.000 green:0.569 blue:0.890 alpha:1],
                      [UIColor colorWithRed:0.000 green:0.773 blue:0.369 alpha:1],
                      [UIColor colorWithRed:1.000 green:0.349 blue:0.000 alpha:1],
                      [UIColor colorWithRed:0.729 green:0.000 blue:1.000 alpha:1]];
    }
    return _bgColors;
}

- (void)display
{
    NSMutableArray *cacheGrids = [[NSMutableArray alloc] init];
    
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[KYCurriculumGridView class]]) {
            [cacheGrids addObject:subview];
            [subview removeFromSuperview];
            for (UIGestureRecognizer *gesture in subview.gestureRecognizers) {
                [subview removeGestureRecognizer:gesture];
            }
        }
    }
    
    CGFloat size = CGRectGetWidth(self.bounds) / 7;
    for (int i = 0; i < 6; i++)
    {
        KYCurriculumGridView *gridView;
        if (cacheGrids.count > 0) {
            gridView = cacheGrids.lastObject;
            [cacheGrids removeLastObject];
            
        } else {
            gridView = [[KYCurriculumGridView alloc] init];
        }
        
        CGRect rect = CGRectMake(size * i, size * i, size, size * 2);
        gridView.frame = rect;
        gridView.backgroundColor = self.bgColors[i % 4];
        [self addSubview:gridView];
        [gridView updateWithString:@"高等数学"];
    }
}

@end

@implementation KYCurriculumGridView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 6;
    
    _label = [[UILabel alloc] init];
    _label.textColor = [UIColor whiteColor];
    _label.numberOfLines = 0;
    _label.lineBreakMode = NSLineBreakByCharWrapping;
    _label.font = [UIFont systemFontOfSize:12];
    [self addSubview:_label];
    
    return self;
}

- (void)updateWithString:(NSString *)text
{
    CGFloat padding = 2;
    CGFloat maxWidth = CGRectGetWidth(self.bounds) - padding * 2;
    CGSize textSize = CGSizeZero;
    
    textSize = [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName : _label.font}
                                  context:nil].size;
    
    _label.text = text;
    _label.frame = CGRectMake((CGRectGetWidth(self.bounds) - textSize.width) / 2,
                              padding * 2, textSize.width, textSize.height);
}

@end