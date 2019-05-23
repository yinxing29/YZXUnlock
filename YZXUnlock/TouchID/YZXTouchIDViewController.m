//
//  YZXTouchIDViewController.m
//  unlockText
//
//  Created by 尹星 on 2017/10/26.
//  Copyright © 2017年 尹星. All rights reserved.
//

#import "YZXTouchIDViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface YZXTouchIDViewController ()

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation YZXTouchIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //已开启TouchID，验证指纹
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"OpenTouchID"] boolValue]) {
        [self p_touchID];
    }else {//未开启TouchID，询问是否开启
        [self p_openTouchID];
    }
}

- (IBAction)touchIDPressed:(UITapGestureRecognizer *)sender {
    //已开启TouchID，验证指纹
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"OpenTouchID"] boolValue]) {
        [self p_touchID];
    }else {//未开启TouchID，询问是否开启
        [self p_openTouchID];
    }
}

- (void)p_touchID
{
    dispatch_async(dispatch_get_main_queue(), ^{
        LAContext *context = [[LAContext alloc] init];
        NSError *error = nil;
        //判断是否支持TouchID
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"TouchID Text" reply:^(BOOL success, NSError * _Nullable error) {
                if (success) {//指纹验证成功
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UnlockLoginSuccess" object:nil];
                }else {//指纹验证失败
                    switch (error.code)
                    {
                        case LAErrorAuthenticationFailed:
                        {
                            NSLog(@"授权失败"); // -1 连续三次指纹识别错误
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"touchIDFailed" object:nil];
                        }
                            break;
                        case LAErrorUserCancel:
                        {
                            NSLog(@"用户取消验证Touch ID"); // -2 在TouchID对话框中点击了取消按钮
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                            break;
                        case LAErrorUserFallback:
                        {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"touchIDFailed" object:nil];
                                NSLog(@"用户选择输入密码，切换主线程处理"); // -3 在TouchID对话框中点击了输入密码按钮
                            }];
                            
                        }
                            break;
                        case LAErrorSystemCancel:
                        {
                            NSLog(@"取消授权，如其他应用切入，用户自主"); // -4 TouchID对话框被系统取消，例如按下Home或者电源键
                        }
                            break;
                        case LAErrorPasscodeNotSet:
                            
                        {
                            NSLog(@"设备系统未设置密码"); // -5
                        }
                            break;
                        case LAErrorBiometryNotAvailable:
                        {
                            NSLog(@"设备未设置Touch ID"); // -6
                        }
                            break;
                        case LAErrorBiometryNotEnrolled: // Authentication could not start, because Touch ID has no enrolled fingers
                        {
                            NSLog(@"用户未录入指纹"); // -7
                        }
                            break;
                            
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
                        case LAErrorBiometryLockout: //Authentication was not successful, because there were too many failed Touch ID attempts and Touch ID is now locked. Passcode is required to unlock Touch ID, e.g. evaluating LAPolicyDeviceOwnerAuthenticationWithBiometrics will ask for passcode as a prerequisite 用户连续多次进行Touch ID验证失败，Touch ID被锁，需要用户输入密码解锁，先Touch ID验证密码
                        {
                            NSLog(@"Touch ID被锁，需要用户输入密码解锁"); // -8 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                        }
                            break;
                        case LAErrorAppCancel:
                        {
                            NSLog(@"用户不能控制情况下APP被挂起"); // -9
                        }
                            break;
                        case LAErrorInvalidContext:
                        {
                            NSLog(@"LAContext传递给这个调用之前已经失效"); // -10
                        }
                            break;
#else
#endif
                        default:
                        {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                NSLog(@"其他情况，切换主线程处理");
                            }];
                            break;
                        }
                    }
                }
            }];
        }else {
            //不支持
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该设备不支持TouchID" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    });
}

- (void)p_openTouchID
{
//    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否开启TouchID?" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //开启TouchID
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"OpenTouchID"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenTouchIDSuccess" object:nil userInfo:nil];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //不开启TouchID
            [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"OpenTouchID"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenTouchIDSuccess" object:nil userInfo:nil];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
//    });
}


@end


