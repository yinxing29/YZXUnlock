//
//  YZXGesturesView.h
//  unlockText
//
//  Created by 尹星 on 2017/10/27.
//  Copyright © 2017年 尹星. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const YZX_KEYCHAIN_SERVICE;
extern NSString *const YZX_KEYCHAIN_ACCOUNT;

//回传选择的id
typedef void (^GestureBlock)(NSArray *selectedID);
//回传手势验证结果
typedef void (^UnlockBlock)(BOOL isSuccess);
//设置手势失败
typedef void (^SettingBlock)(void);

@interface YZXGesturesView : UIView

/**
 设置密码时，返回设置的手势密码
 */
@property (nonatomic, copy) GestureBlock             gestureBlock;
                             
/**
 返回解锁成功还是失败状态
 */
@property (nonatomic, copy) UnlockBlock            unlockBlock;
                             
/**
 判断手势密码时候设置成功（手势密码不得少于四个点）
 */
@property (nonatomic, copy) SettingBlock           settingBlock;

/**
 判断是设置手势还是手势解锁
 */
@property (nonatomic, assign) BOOL         settingGesture;

@end
