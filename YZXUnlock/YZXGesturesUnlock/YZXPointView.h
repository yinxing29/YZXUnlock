//
//  YZXPointView.h
//  unlockText
//
//  Created by 尹星 on 2017/10/26.
//  Copyright © 2017年 尹星. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZXPointView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                       withID:(NSString *)ID;

@property (nonatomic, copy, readonly) NSString             *ID;

//选中
@property (nonatomic, assign) BOOL             isSelected;
//解锁失败
@property (nonatomic, assign) BOOL             isError;
//解锁成功
@property (nonatomic, assign) BOOL             isSuccess;

@end
