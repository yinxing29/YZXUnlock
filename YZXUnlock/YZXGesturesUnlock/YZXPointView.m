//
//  YZXPointView.m
//  unlockText
//
//  Created by 尹星 on 2017/10/26.
//  Copyright © 2017年 尹星. All rights reserved.
//

#import "YZXPointView.h"
#import "YZXDefine.h"

@interface YZXPointView ()

@property (nonatomic, strong) CAShapeLayer             *contentLayer;

@property (nonatomic, strong) CAShapeLayer             *borderLayer;

@property (nonatomic, strong) CAShapeLayer             *centerLayer;

@property (nonatomic, copy, readwrite) NSString             *ID;

@end

@implementation YZXPointView

- (instancetype)initWithFrame:(CGRect)frame
                       withID:(NSString *)ID
{
    self = [super initWithFrame:frame];
    if (self) {
        self.ID = ID;
        [self p_initView];
    }
    return self;
}

- (void)p_initView
{
    [self.layer addSublayer:self.contentLayer];

    [self.layer addSublayer:self.borderLayer];
    
    [self.layer addSublayer:self.centerLayer];
    
    self.centerLayer.hidden = YES;
}

#pragma mark - setter
//根据情况显示三种状态
- (void)setIsSuccess:(BOOL)isSuccess
{
    _isSuccess = isSuccess;
    if (_isSuccess) {
        self.centerLayer.fillColor = YZX_RGB_COLOR(43.0, 210.0, 110.0, 1.0).CGColor;
    }else {
        self.centerLayer.fillColor = YZX_RGB_COLOR(30.0, 180.0, 244.0, 1.0).CGColor;
    }
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (_isSelected) {
        self.centerLayer.hidden = NO;
        self.borderLayer.strokeColor = YZX_RGB_COLOR(30.0, 180.0, 244.0, 1.0).CGColor;
    }else {
        self.centerLayer.hidden = YES;
        self.borderLayer.strokeColor = YZX_RGB_COLOR(105.0, 108.0, 111.0, 1.0).CGColor;
    }
}

- (void)setIsError:(BOOL)isError
{
    _isError = isError;
    if (_isError) {
        self.centerLayer.fillColor = YZX_RGB_COLOR(222.0, 64.0, 60.0, 1.0).CGColor;
    }else {
        self.centerLayer.fillColor = YZX_RGB_COLOR(30.0, 180.0, 244.0, 1.0).CGColor;
    }
}

#pragma mark - 懒加载
//外层手势按钮
- (CAShapeLayer *)contentLayer
{
    if (!_contentLayer) {
        _contentLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(2.0, 2.0, YZX_VIEW_WIDTH - 4.0, YZX_VIEW_HEIGHT - 4.0) cornerRadius:(YZX_VIEW_WIDTH - 4.0) / 2.0];
        _contentLayer.path = path.CGPath;
        _contentLayer.fillColor = YZX_RGB_COLOR(46.0, 47.0, 50.0, 1.0).CGColor;
        _contentLayer.strokeColor = YZX_RGB_COLOR(26.0, 27.0, 29.0, 1.0).CGColor;
        _contentLayer.strokeStart = 0;
        _contentLayer.strokeEnd = 1;
        _contentLayer.lineWidth = 2;
        _contentLayer.cornerRadius = self.bounds.size.width / 2.0;
    }
    return _contentLayer;
}

//手势按钮边框
- (CAShapeLayer *)borderLayer
{
    if (!_borderLayer) {
        _borderLayer = [CAShapeLayer layer];
        UIBezierPath *borderPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(YZX_VIEW_WIDTH / 2.0, YZX_VIEW_HEIGHT / 2.0) radius:YZX_VIEW_WIDTH / 2.0 startAngle:0 endAngle:2 * M_PI clockwise:NO];
        _borderLayer.strokeColor = YZX_RGB_COLOR(105.0, 108.0, 111.0, 1.0).CGColor;
        _borderLayer.fillColor = [UIColor clearColor].CGColor;
        _borderLayer.strokeEnd = 1;
        _borderLayer.strokeStart = 0;
        _borderLayer.lineWidth = 2;
        _borderLayer.path = borderPath.CGPath;
    }
    return _borderLayer;
}

//选中时，中间样式
- (CAShapeLayer *)centerLayer
{
    if (!_centerLayer) {
        _centerLayer = [CAShapeLayer layer];
        UIBezierPath *centerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(YZX_VIEW_WIDTH / 2.0 - (YZX_VIEW_WIDTH - 4.0) / 4.0, YZX_VIEW_HEIGHT / 2.0 - (YZX_VIEW_HEIGHT - 4.0) / 4.0, (YZX_VIEW_WIDTH - 4.0) / 2.0, (YZX_VIEW_WIDTH - 4.0) / 2.0) cornerRadius:(YZX_VIEW_WIDTH - 4.0) / 4.0];
        _centerLayer.path = centerPath.CGPath;
        _centerLayer.lineWidth = 3;
        _centerLayer.strokeColor = [UIColor colorWithWhite:0 alpha:0.7].CGColor;
        _centerLayer.fillColor = YZX_RGB_COLOR(30.0, 180.0, 244.0, 1.0).CGColor;
    }
    return _centerLayer;
}

@end
