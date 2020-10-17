//
//  FanDataTool.m
//  FanKit
//
//  Created by 向阳凡 on 16/7/4.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import "FanDataTool.h"
#include <CommonCrypto/CommonCrypto.h>

@implementation FanDataTool

#pragma mark - 数据进制转换和解析

/**16进制字符串转data*/
+(NSData *)fan_hexToBytes:(NSString *)hexString{
    NSUInteger leng=hexString.length;
    NSMutableData *data=[[NSMutableData alloc]init];
    for (int i=0; i<leng/2; i++) {
        unsigned long red=strtoul([[hexString substringWithRange:NSMakeRange(i*2, 2)] UTF8String], 0, 16);
        Byte b=red;
        [data appendBytes:&b length:1];
    }
    return data;
}
/** 16进制字符串转long Int  没有对输入进行校验*/
+(long)fan_hexToInLong:(NSString *)hexString{
    unsigned long longInt=strtoul([hexString UTF8String], 0, 16);
    return longInt;
}
/** data转换成16进制字符串  */
+(NSString *)fan_dataToHexString:(NSData *)data{
    Byte *bytehex =(Byte *) data.bytes;
    NSMutableString *hexString=[[NSMutableString alloc]init];
    for (int i=0; i<data.length; i++) {
        Byte b=bytehex[i];
        [hexString appendFormat:@"%02X",b];
    }
    return hexString;
}
/**10进制字符串转16进制字符串(字符个数）*/
+(NSString *)fan_tenToHexString:(NSString *)tenString digit:(NSUInteger)digit{
    NSInteger ab=[tenString integerValue];
    NSMutableString *hexString=[[NSMutableString alloc]init];
    if(digit==2) {
        Byte b=ab;
        [hexString appendFormat:@"%02X", b];
    }else if(digit==4){
        UInt16 hexInt=htons(ab);
        NSData *data = [NSData dataWithBytes: &hexInt length:2];
        Byte *bytehex =(Byte *) data.bytes;
        
        [hexString appendFormat:@"%02X", bytehex[0]];
        [hexString appendFormat:@"%02X", bytehex[1]];
    }
    return hexString;
}
/**16进制字符串转asc字符串*/
+(NSString *)fan_hexToAscString:(NSString *)hexString{
    NSMutableString *ascString=[[NSMutableString alloc]init];
    for (int i=0; i<hexString.length/2; i++) {
        NSString *as=[hexString substringWithRange:NSMakeRange(i*2, 2)];
        if([as isEqualToString:@"00"]){
            [ascString appendString:@"0"];
        }else{
            unsigned long red=strtoul([as UTF8String], 0, 16);
            Byte b=red;
            [ascString appendFormat:@"%c",b];
        }
    }
    
    return ascString;
}

#pragma mark - socket字节编码
//判断系统是否是大端还是小端
+(BOOL)fan_isLittleEndian
{
    int32_t i = 1;
    char* b = (char*)&i;
    return b[0] == 1;
}

+(NSData *)fan_pack_int8:(int)val
{
    char myByteArray[] = {0};
    myByteArray[0]=val & 0xff;
    NSData *ret=[NSData dataWithBytes:myByteArray length:1];
    return ret;
}

+(NSData *)fan_pack_int16:(int)val bigEndian:(BOOL)bigEndian
{
    char myByteArray[] = {0,0};
    myByteArray[0]=val & 0xff;
    myByteArray[1]=(val>>8) & 0xff;
    
    if(bigEndian)
    {
        myByteArray[1]=val & 0xff;
        myByteArray[0]=(val>>8) & 0xff;
    }else{
        myByteArray[0]=val & 0xff;
        myByteArray[1]=(val>>8) & 0xff;
    }
    
    NSData *ret=[NSData dataWithBytes:myByteArray length:2];
    return ret;
}

+(NSData *)fan_pack_int32:(int)val bigEndian:(BOOL)bigEndian
{
    char myByteArray[] = {0,0,0,0};
    
    if(bigEndian)
    {
        myByteArray[3]=val & 0xff;
        myByteArray[2]=(val>>8) & 0xff;
        myByteArray[1]=(val>>16) & 0xff;
        myByteArray[0]=(val>>24) & 0xff;
    }else{
        myByteArray[0]=val & 0xff;
        myByteArray[1]=(val>>8) & 0xff;
        myByteArray[2]=(val>>16) & 0xff;
        myByteArray[3]=(val>>24) & 0xff;
    }
    
    
    NSData *ret=[NSData dataWithBytes:myByteArray length:4];
    return ret;
}

+(NSData *)fan_pack_float32:(float)val bigEndian:(BOOL)bigEndian
{
    float valf=val;
    char myByteArray[] = {0,0,0,0};
    char *temp=(char *)(&valf);
    if(bigEndian)
    {
        myByteArray[3]=temp[0];
        myByteArray[2]=temp[1];
        myByteArray[1]=temp[2];
        myByteArray[0]=temp[3];
    }else{
        myByteArray[3]=temp[3];
        myByteArray[2]=temp[2];
        myByteArray[1]=temp[1];
        myByteArray[0]=temp[0];
    }
    NSData *ret=[NSData dataWithBytes:myByteArray length:4];
    return ret;
}

+(int8_t)fan_unpack_int8:(NSData *)data
{
    NSUInteger len = [data length];
    Byte *by=(Byte *)malloc(len);
    memcpy(by, [data bytes], len);
    int8_t ret=by[0] & 0xff;
    free(by);
    return ret;
    
}
+(int16_t)fan_unpack_int16:(NSData *)data bigEndian:(BOOL)bigEndian
{
    NSUInteger len = [data length];
    Byte *by=(Byte *)malloc(len);
    memcpy(by, [data bytes], len);
    int16_t ret=((by[1] & 0xFF) << 8) + (by[0] & 0xff);
    if (bigEndian) {
        ret=((by[0] & 0xFF) << 8) + (by[1] & 0xff);
    }
    free(by);
    return ret;
}
+(int32_t)fan_unpack_int32:(NSData *)data bigEndian:(BOOL)bigEndian
{
    NSUInteger len = [data length];
    Byte *by=(Byte *)malloc(len);
    memcpy(by, [data bytes], len);
    int32_t ret=(by[3] << 24) + ((by[2] & 0xFF) << 16) + ((by[1] & 0xFF) << 8) + (by[0] & 0xFF);
    if (bigEndian) {
        ret = ((by[0] & 0xFF) << 24) + ((by[1] & 0xFF) << 16) + ((by[2] & 0xFF) << 8) + (by[3] & 0xff);
    }
    free(by);
    return ret;
}
+(float)fan_unpack_float32:(NSData *)data bigEndian:(BOOL)bigEndian
{
    NSUInteger len = [data length];
    Byte *by=(Byte *)malloc(len);
    memcpy(by, [data bytes], len);
    float valf=0.0;
    char *temp=(char *)(&valf);
    if(bigEndian)
    {
        temp[3]=by[0];
        temp[2]=by[1];
        temp[1]=by[2];
        temp[0]=by[3];
    }else{
        temp[3]=by[3];
        temp[2]=by[2];
        temp[1]=by[1];
        temp[0]=by[0];
    }
    free(by);
    return valf;
}
+(NSData *)fan_pack_string8:(NSString*)str
{
    NSData *bytes = [str dataUsingEncoding:NSUTF16LittleEndianStringEncoding];
    NSData *nd = [[self class] fan_pack_int8:(int)[bytes length]];
    NSMutableData *data=[NSMutableData dataWithData:nd];
    [data appendData:bytes];
    return data;
}

+(NSData *)fan_pack_string16:(NSString*)str
{
    NSData *bytes = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSData *nd = [[self class] fan_pack_int16:(int)[bytes length] bigEndian:YES];
    NSMutableData *data=[NSMutableData dataWithData:nd];
    [data appendData:bytes];
    return data;
    
}

+(NSString *)fan_unpack_string8:(NSData*)data
{
    NSData *intdata= [data subdataWithRange:(NSRange){0, 1}];
    int len=[[self class] fan_unpack_int8:intdata];
    NSString *ret = [[NSString alloc]initWithData:[data subdataWithRange:(NSRange){1,len}] encoding:NSUTF16LittleEndianStringEncoding];
    return ret;
    
}
+(NSString *)fan_unpack_string16:(NSData*)data;
{
    NSData *intdata= [data subdataWithRange:(NSRange){0, 2}];
    int len=[[self class] fan_unpack_int16:intdata bigEndian:YES];
    NSString *ret = [[NSString alloc]initWithData:[data subdataWithRange:(NSRange){2,len}] encoding:NSUTF8StringEncoding];
    return ret;
}

#pragma mark - MD5校验

+(NSString *)fan_md5String:(NSString *)str{
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    //要比循环拼接效率高点吧
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
+(NSData *)fan_md5Data:(NSString *)str{
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}


@end
