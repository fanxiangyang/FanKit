//
//  FanRSA.h
//  FanKit
//
//  Created by 向阳凡 on 2020/3/30.
//  Copyright © 2020 凡向阳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*   RSA公钥加密，私钥解密
 *   注意 1.如果公钥私钥前缀不一样的话，请去掉前缀
     const NSString *fan_publickey_begin=@"-----BEGIN PRIVATE KEY-----";
     const NSString *fan_publickey_end=@"-----END PUBLIC KEY-----";
     const NSString *fan_privatekey_begin=@"-----BEGIN PRIVATE KEY-----";
     const NSString *fan_privatekey_end=@"-----END PRIVATE KEY-----";
 *
 */

@interface FanRSA : NSObject

#pragma mark - 加密

/// 字符串RSA加密返回base64编码
/// @param str 字符串
/// @param pubKey 公钥
+ (NSString *)fan_encryptString:(NSString *)str publicKey:(NSString *)pubKey;

/// data数据RSA加密
/// @param data 二进制数据
/// @param pubKey 公钥
+ (NSData *)fan_encryptData:(NSData *)data publicKey:(NSString *)pubKey;

//好像没有私钥加密先注释吧
//+ (NSString *)fan_encryptString:(NSString *)str privateKey:(NSString *)privKey;
//+ (NSData *)fan_encryptData:(NSData *)data privateKey:(NSString *)privKey;


#pragma mark - 解密

/// RAS公钥解密字符串
/// @param str 字符串
/// @param pubKey 公钥
+ (NSString *)fan_decryptString:(NSString *)str publicKey:(NSString *)pubKey;

/// RAS公钥解密Data
/// @param data 二进制
/// @param pubKey 公钥
+ (NSData *)fan_decryptData:(NSData *)data publicKey:(NSString *)pubKey;

/// RAS私钥解密字符串
/// @param str 字符串
/// @param privKey 私钥
+ (NSString *)fan_decryptString:(NSString *)str privateKey:(NSString *)privKey;

/// RAS私钥解密Data
/// @param data 二进制
/// @param privKey 私钥
+ (NSData *)fan_decryptData:(NSData *)data privateKey:(NSString *)privKey;

@end

NS_ASSUME_NONNULL_END
