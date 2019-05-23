//
//  YZXGesturesView.m
//  unlockText
//
//  Created by 尹星 on 2017/10/27.
//  Copyright © 2017年 尹星. All rights reserved.
//

#import "YZXGesturesView.h"
#import "YZXPointView.h"
#import "YZXKeychain.h"
#import "YZXDefine.h"

NSString *const YZX_KEYCHAIN_SERVICE = @"YZX_KEYCHAIN_SERVICE";
NSString *const YZX_KEYCHAIN_ACCOUNT = @"YZX_KEYCHAIN_SERVICE";

@interface YZXGesturesView ()

//可变数组，用于存放初始化的点击按钮
@property (nonatomic, strong) NSMutableArray             *YZXPointViews;
//记录手势滑动的起始点
@property (nonatomic, assign) CGPoint                    startPoint;
//记录手势滑动的结束点
@property (nonatomic, assign) CGPoint                    endPoint;
//存储选中的按钮ID
@property (nonatomic, strong) NSMutableArray             *selectedView;
//手势滑动经过的点的连线
@property (nonatomic, strong) CAShapeLayer               *lineLayer;
//手势滑动的path
@property (nonatomic, strong) UIBezierPath               *linePath;
//用于存储选中的按钮
@property (nonatomic, strong) NSMutableArray             *selectedViewCenter;
//判断时候滑动是否结束
@property (nonatomic, assign) BOOL                       touchEnd;

@property (nonatomic, strong) YZXKeychain       *keychain;

@end

@implementation YZXGesturesView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_initData];
        [self p_initView];
    }
    return self;
}

- (void)p_initData
{
    self.touchEnd = NO;
}

- (void)p_initView
{
    //初始化开始点位和结束点位
    self.startPoint = CGPointZero;
    self.endPoint = CGPointZero;
    //布局手势按钮
    for (int i = 0; i<9 ; i++) {
        YZXPointView *pointView = [[YZXPointView alloc] initWithFrame:CGRectMake((i % 3) * (YZX_VIEW_WIDTH / 2.0 - 31.0) + 1, (i / 3) * (YZX_VIEW_HEIGHT / 2.0 - 31.0) + 1, 60, 60)
                                                         withID:[NSString stringWithFormat:@"gestures %d",i + 1]];
        [self addSubview:pointView];
        [self.YZXPointViews addObject:pointView];
    }
}

//touch事件
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.touchEnd) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //判断手势滑动是否在手势按钮范围
    for (YZXPointView *YZXPointView in self.YZXPointViews) {
        //滑动到手势按钮范围，记录状态
        if (CGRectContainsPoint(YZXPointView.frame, point)) {
            //如果开始按钮为zero，记录开始按钮，否则不需要记录开始按钮
            if (CGPointEqualToPoint(self.startPoint, CGPointZero)) {
                self.startPoint = YZXPointView.center;
            }
            //判断该手势按钮的中心点是否记录，未记录则记录
            if (![self.selectedViewCenter containsObject:[NSValue valueWithCGPoint:YZXPointView.center]]) {
                [self.selectedViewCenter addObject:[NSValue valueWithCGPoint:YZXPointView.center]];
            }
            //判断该手势按钮是否已经选中，未选中就选中
            if (![self.selectedView containsObject:YZXPointView.ID]) {
                [self.selectedView addObject:YZXPointView.ID];
                YZXPointView.isSelected = YES;
            }
        }
    }
    //如果开始点位不为zero则记录结束点位，否则跳过不记录
    if (!CGPointEqualToPoint(self.startPoint, CGPointZero)) {
        self.endPoint = point;
        [self p_drawLines];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //结束手势滑动的时候，将结束按钮设置为最后一个手势按钮的中心点，并画线
    self.endPoint = [self.selectedViewCenter.lastObject CGPointValue];
    //如果endPoint还是为zero说明未滑动到有效位置，不做处理
    if (CGPointEqualToPoint(self.endPoint, CGPointZero)) {
        return;
    }
    [self p_drawLines];
    //改变手势滑动结束的状态，为yes则无法在滑动手势划线
    self.touchEnd = YES;
    //设置手势时，返回设置的时候密码，否则继续下面的操作进行手势解锁
    if (_gestureBlock && _settingGesture) {
        //手势密码不得小于4个点
        if (self.selectedView.count < 4) {
            self.touchEnd = NO;
            for (YZXPointView *YZXPointView in self.YZXPointViews) {
                YZXPointView.isSelected = NO;
            }
            [self.lineLayer removeFromSuperlayer];
            [self.selectedView removeAllObjects];
            self.startPoint = CGPointZero;
            self.endPoint = CGPointZero;
            [self.selectedViewCenter removeAllObjects];
            if (_settingBlock) {
                self.settingBlock();
            }
            return;
        }
        _gestureBlock(self.selectedView);
        return;
    }
    
    //手势解锁
    //    NSArray *selectedID = [[NSUserDefaults standardUserDefaults] objectForKey:@"GestureUnlock"];
    NSArray *selectedID = (NSArray *)[self.keychain yzx_readPasswordForService:YZX_KEYCHAIN_SERVICE account:YZX_KEYCHAIN_ACCOUNT];
    NSLog(@"获取密码 %@",selectedID);
    //解锁成功
    if ([self.selectedView isEqualToArray:selectedID]) {
        //解锁成功，遍历YZXPointView，设置为成功状态
        for (YZXPointView *YZXPointView in self.YZXPointViews) {
            YZXPointView.isSuccess = YES;
        }
        self.lineLayer.strokeColor = YZX_RGB_COLOR(43.0, 210.0, 110.0, 1.0).CGColor;
        if (_unlockBlock) {
            self.unlockBlock(YES);
        }
    }else {//解锁失败
        //解锁失败，遍历YZXPointView，设置为失败状态
        for (YZXPointView *YZXPointView in self.YZXPointViews) {
            YZXPointView.isError = YES;
        }
        self.lineLayer.strokeColor = YZX_RGB_COLOR(222.0, 64.0, 60.0, 1.0).CGColor;
        if (_unlockBlock) {
            self.unlockBlock(NO);
        }
    }
}

- (void)p_drawLines
{
    //结束手势滑动，不画线
    if (self.touchEnd) {
        return;
    }
    //移除path的点和lineLayer
    [self.lineLayer removeFromSuperlayer];
    [self.linePath removeAllPoints];
    //画线
    [self.linePath moveToPoint:self.startPoint];
    for (NSValue *pointValue in self.selectedViewCenter) {
        [self.linePath addLineToPoint:[pointValue CGPointValue]];
    }
    [self.linePath addLineToPoint:self.endPoint];
    
    self.lineLayer.path = self.linePath.CGPath;
    self.lineLayer.lineWidth = 4.0;
    self.lineLayer.strokeColor = YZX_RGB_COLOR(30.0, 180.0, 244.0, 1.0).CGColor;
    self.lineLayer.fillColor = [UIColor clearColor].CGColor;
    
    [self.layer addSublayer:self.lineLayer];
    
    self.layer.masksToBounds = YES;
}

#pragma mark - setter
- (void)setSettingGesture:(BOOL)settingGesture
{
    _settingGesture = settingGesture;
}

#pragma mark - 懒加载
- (NSMutableArray *)YZXPointViews
{
    if (!_YZXPointViews) {
        _YZXPointViews = [NSMutableArray arrayWithCapacity:9];
    }
    return _YZXPointViews;
}

- (UIBezierPath *)linePath
{
    if (!_linePath) {
        _linePath = [UIBezierPath bezierPath];
    }
    return _linePath;
}

- (NSMutableArray *)selectedView
{
    if (!_selectedView) {
        _selectedView = [NSMutableArray array];
    }
    return _selectedView;
}

- (NSMutableArray *)selectedViewCenter
{
    if (!_selectedViewCenter) {
        _selectedViewCenter = [NSMutableArray array];
    }
    return _selectedViewCenter;
}

- (CAShapeLayer *)lineLayer
{
    if (!_lineLayer) {
        _lineLayer = [CAShapeLayer layer];
    }
    return _lineLayer;
}

- (YZXKeychain *)keychain
{
    if (!_keychain) {
        _keychain = [[YZXKeychain alloc] init];
    }
    return _keychain;
}

@end
