//
//  YZXKeychain.h
//  YZXUnlockText
//
//  Created by 尹星 on 2018/4/9.
//  Copyright © 2018年 尹星. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZXKeychain : NSObject


/**
 保存/更新密码
 
 @param content 密码
 @param service keychain_service
 @param account keychain_account
 */
- (void)yzx_savePassword:(id)content
                 service:(NSString *)service
                 account:(NSString *)account;

/**
 删除密码
 
 @param service keychain_service
 @param account keychain_account
 */
- (void)yzx_deletePasswordForService:(NSString *)service
                             account:(NSString *)account;

/**
 获取密码
 
 @param service keychain_service
 @param account keychain_account
 @return 返回获取的密码
 */
- (id)yzx_readPasswordForService:(NSString *)service
                         account:(NSString *)account;

@end
