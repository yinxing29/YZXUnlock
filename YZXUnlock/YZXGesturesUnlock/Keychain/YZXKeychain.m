//
//  YZXKeychain.m
//  YZXUnlockText
//
//  Created by 尹星 on 2018/4/9.
//  Copyright © 2018年 尹星. All rights reserved.
//

#import "YZXKeychain.h"
#import <Security/Security.h>

@interface YZXKeychain ()

@property (nonatomic, copy) NSString         *service;
@property (nonatomic, copy) NSString         *account;

@end

@implementation YZXKeychain

- (void)yzx_savePassword:(id)content
                 service:(NSString *)service
                 account:(NSString *)account
{
    self.service = service;
    self.account = account;
    NSMutableDictionary *password = nil;
    NSMutableDictionary *searchPassword = [self keychain];
    //查找密码
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)searchPassword, nil);
    //存在则更新
    if (status == errSecSuccess) {
        password = [[NSMutableDictionary alloc] init];
        //设置以data的形式保存
        [password setObject:[self data:content] forKey:(__bridge id)kSecValueData];
        //更新密码
        status = SecItemUpdate((__bridge CFDictionaryRef)searchPassword, (__bridge CFDictionaryRef)password);
    }else if (status == errSecItemNotFound) {//不存在则创建
        password = [self keychain];
        //设置以data的形式保存
        [password setObject:[self data:content] forKey:(__bridge id)kSecValueData];
        //保存密码
        status = SecItemAdd((__bridge CFDictionaryRef)password, NULL);
    }
}

- (void)yzx_deletePasswordForService:(NSString *)service
                             account:(NSString *)account
{
    self.service = service;
    self.account = account;
    NSMutableDictionary *searchPassword = [self keychain];
    //查找密码
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)searchPassword, nil);
    //未找到，直接return
    if (status == errSecItemNotFound) {
        return;
    }
    //删除
    SecItemDelete((__bridge CFDictionaryRef)searchPassword);
}

- (id)yzx_readPasswordForService:(NSString *)service
                         account:(NSString *)account
{
    self.service = service;
    self.account = account;
    
    CFTypeRef result = NULL;
    NSMutableDictionary *searchPassword = [self keychain];
    //表明返回的类型为data
    [searchPassword setObject:@YES forKey:(__bridge id)kSecReturnData];
    //未知？？（有大神看到能否解释一下）
    [searchPassword setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)searchPassword, &result);
    if (status != errSecSuccess) {
        return nil;
    }
    return [self dataString:(__bridge_transfer NSData *)result];
}

/**
 获取keychain需要的dictionary
 
 @return dictionary
 */
- (NSMutableDictionary *)keychain
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithCapacity:3];
    //设置累心为通用密码
    [dictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    //设置service，用于后面更新，删除和获取等的标识（与account联用）
    if (self.service) {
        [dictionary setObject:self.service forKey:(__bridge id)kSecAttrService];
    }
    //设置account，用于后面更新，删除和获取等的标识（与service联用）
    if (self.account) {
        [dictionary setObject:self.account forKey:(__bridge id)kSecAttrAccount];
    }
    return dictionary;
}


/**
 密码转data类型
 
 @param password 密码
 @return 密码data
 */
- (NSData *)data:(id)password
{
    if ([password isKindOfClass:[NSArray class]]) {
        return [NSJSONSerialization dataWithJSONObject:password options:kNilOptions error:nil];
    }
    return [password dataUsingEncoding:NSUTF8StringEncoding];
}

/**
 密码data转密码
 
 @param password 密码data
 @return 密码
 */
- (id)dataString:(NSData *)password
{
    if ([password length]) {
        id result = [NSJSONSerialization JSONObjectWithData:password options:NSJSONReadingAllowFragments error:nil];
        return result;
    }
    return nil;
}

@end
