//
//  FanDataTool.h
//  FanKit
//
//  Created by 向阳凡 on 16/7/4.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  int类型的字节编码(Data)
 *
 *  @param intType     int类型（UInt16,UInt32 ...)
 *  @param _member     int 数大小
 *  @param mutableData 可变字节
 *
 *  @return 无
 */
#define Fan_ENCODE(intType, _member,mutableData) \
    do { \
        intType member = _member;          \
        NSInteger size = sizeof(intType);\
        switch (size) { \
        case 1: \
            [mutableData appendBytes:&member length:1]; break; \
        case 2: { \
            UInt16 temp = htons(member);\
            [mutableData appendBytes:&temp length:2];\
        } break;\
        case 4: {\
            UInt32 temp = htonl(member); \
            [mutableData appendBytes:&temp length:4]; \
        } break; \
        case 8: { \
            UInt64 temp = htonll(member);  /**dthtonll(member)*/ \
            [mutableData appendBytes:&temp length:8]; \
        } break; \
        default:\
            NSLog(@"不支持的int型字节编码"); break; \
        } \
    } while (0)


@interface FanDataTool : NSObject


#pragma mark - 数据进制转换和解析
/**16进制字符串转data*/
+(NSData *)fan_hexToBytes:(NSString *)hexString;
/** 16进制字符串转long Int  没有对输入进行校验*/
+(long)fan_hexToInLong:(NSString *)hexString;
/** data转换成16进制字符串  */
+(NSString *)fan_dataToHexString:(NSData *)data;
/**10进制字符串转16进制字符串(字符个数）*/
+(NSString *)fan_tenToHexString:(NSString *)tenString digit:(NSUInteger)digit;
/**16进制字符串转asc字符串*/
+(NSString *)fan_hexToAscString:(NSString *)hexString;//3132->12

#pragma mark - socket字节编码
//判断系统是否是大端还是小端
+(BOOL)fan_isLittleEndian;
+(int8_t)fan_unpack_int8:(NSData *)data;
+(int16_t)fan_unpack_int16:(NSData *)data bigEndian:(BOOL)bigEndian;
+(int32_t)fan_unpack_int32:(NSData *)data bigEndian:(BOOL)bigEndian;
+(NSData *)fan_pack_float32:(float)val bigEndian:(BOOL)bigEndian;

+(NSData *)fan_pack_int8:(int)val;
+(NSData *)fan_pack_int16:(int)val bigEndian:(BOOL)bigEndian;
+(NSData *)fan_pack_int32:(int)val bigEndian:(BOOL)bigEndian;
+(float)fan_unpack_float32:(NSData *)data bigEndian:(BOOL)bigEndian;

+(NSData *)fan_pack_string8:(NSString*)str;
+(NSData *)fan_pack_string16:(NSString*)str;

+(NSString *)fan_unpack_string8:(NSData*)data;
+(NSString *)fan_unpack_string16:(NSData*)data;


#pragma mark - MD5校验
///求字符串的32位小写MD5加密字符串
+(NSString *)fan_md5String:(NSString *)str;
///求字符串的16字节MD5加密Data
+(NSData *)fan_md5Data:(NSString *)str;

@end
