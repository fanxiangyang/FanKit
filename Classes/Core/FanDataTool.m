//
//  FanDataTool.m
//  FanKit
//
//  Created by 向阳凡 on 16/7/4.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import "FanDataTool.h"

//获取IP
#include <ifaddrs.h>
#include <arpa/inet.h>


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
    
    if(!bigEndian)
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
    
    if(!bigEndian)
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
    int16_t ret=((by[0] & 0xFF) << 8) + (by[1] & 0xff);
    if (bigEndian) {
        ret=((by[1] & 0xFF) << 8) + (by[0] & 0xff);
    }
    free(by);
    return ret;
}
+(int32_t)fan_unpack_int32:(NSData *)data bigEndian:(BOOL)bigEndian
{
    NSUInteger len = [data length];
    Byte *by=(Byte *)malloc(len);
    memcpy(by, [data bytes], len);
    int32_t ret = ((by[0] & 0xFF) << 24) + ((by[1] & 0xFF) << 16) + ((by[2] & 0xFF) << 8) + (by[3] & 0xff);
    if (bigEndian) {
        ret=(by[3] << 24) + ((by[2] & 0xFF) << 16) + ((by[1] & 0xFF) << 8) + (by[0] & 0xFF);
        
    }
    free(by);
    return ret;
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


//必须在有网的情况下才能获取手机的IP地址
+ (NSString *)fan_IPAdress {
    NSString *address = @"1.1.1.1";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) { // 0 表示获取成功
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in  *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

@end
