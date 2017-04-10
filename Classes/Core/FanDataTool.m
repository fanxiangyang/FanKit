//
//  FanDataTool.m
//  FanKit
//
//  Created by 向阳凡 on 16/7/4.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import "FanDataTool.h"

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


#pragma mark - socket字节编码

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

+(NSData *)fan_pack_int16:(int)val
{
    char myByteArray[] = {0,0};
    myByteArray[0]=val & 0xff;
    myByteArray[1]=(val>>8) & 0xff;
    
    if([[self class] fan_isLittleEndian])
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

+(NSData *)fan_pack_int32:(int)val
{
    char myByteArray[] = {0,0,0,0};
    
    if([[self class] fan_isLittleEndian])
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

+(int)fan_unpack_int8:(NSData *)data
{
    NSUInteger len = [data length];
    Byte *by=(Byte *)malloc(len);
    memcpy(by, [data bytes], len);
    int ret=by[0] & 0xff;
    free(by);
    return ret;
    
}
+(int)fan_unpack_int16:(NSData *)data
{
    NSUInteger len = [data length];
    Byte *by=(Byte *)malloc(len);
    memcpy(by, [data bytes], len);
    
    int ret=((by[0] & 0xFF) << 8) + (by[1] & 0xff);
    free(by);
    return ret;
}
+(int)fan_unpack_int32:(NSData *)data
{
    NSUInteger len = [data length];
    Byte *by=(Byte *)malloc(len);
    memcpy(by, [data bytes], len);
    int ret=((by[0] & 0xFF) << 24) + ((by[1] & 0xFF) << 16) + ((by[2] & 0xFF) << 8) + (by[3] & 0xff);
    //by[3] << 24 + ((by[2] & 0xFF) << 16) + ((by[1] & 0xFF) << 8) + (by[0] & 0xFF);
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
    NSData *nd = [[self class] fan_pack_int16:(int)[bytes length]];
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
    int len=[[self class] fan_unpack_int16:intdata];
    NSString *ret = [[NSString alloc]initWithData:[data subdataWithRange:(NSRange){2,len}] encoding:NSUTF8StringEncoding];
    return ret;
}
#pragma mark - 文件操作

+(NSString *)fan_cachePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = ([paths count] > 0) ? [paths objectAtIndex:0] : [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] ;
    return cachePath;
}
//文件夹copy
+(void)fan_copyAtDirPath:(NSString *)srcDirPath toDirPath:(NSString *)toDirPath isRemoveOld:(BOOL)isRemoveOld{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //当前srcDirPath目录下全路径（包含文件夹）  ***/**.png
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:srcDirPath];
    for (NSString *fileStr in enumerator) {
        NSString *fileAllPath=[[toDirPath stringByAppendingPathComponent:fileStr] stringByDeletingLastPathComponent];
        BOOL isDir;
        if (![fileManager fileExistsAtPath:fileAllPath isDirectory:&isDir])
        {
            [fileManager createDirectoryAtPath:fileAllPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if (isRemoveOld) {
            //只移除文件，不移除路径
            if (!isDir) {
                [fileManager removeItemAtPath:[toDirPath stringByAppendingPathComponent:fileStr] error:nil];
            }
        }
        [fileManager copyItemAtPath:[srcDirPath stringByAppendingPathComponent:fileStr] toPath:[toDirPath stringByAppendingPathComponent:fileStr] error:nil];
    }
}
/**删除目录下所有文件*/
+ (BOOL)fan_deleteFilesAtPath:(NSString *)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:filePath]){
        return YES;
    }else{
        
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:filePath] objectEnumerator];
    NSString* fileName;
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString* fileAbsolutePath = [filePath stringByAppendingPathComponent:fileName];
        NSError *error;
        [manager removeItemAtPath:fileAbsolutePath error:&error];
    }
    
    return YES;
}
/**
 *  请求文件（夹）路径的所有文件大小
 *
 *  @param path 文件（夹）路径
 *
 *  @return 返回大小，字节
 */
- (unsigned long long)fan_fileSizeFromPath:(NSString *)path
{
    if (path==nil) {
        //如果文件路径不存在，取到应用缓存路径Caches(同级别的有Cookies）
        NSString *caches=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
        //        path=[caches stringByAppendingPathComponent:@"default"];
        path=caches;
    }
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 是否为文件夹
    BOOL isDirectory = NO;
    // 这个路径是否存在
    BOOL exists = [mgr fileExistsAtPath:path isDirectory:&isDirectory];
    // 路径不存在
    if (exists == NO) return 0;
    
    if (isDirectory) { // 文件夹
        // 总大小
        NSInteger size = 0;
        // 获得文件夹中的所有内容
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:path];
        for (NSString *subpath in enumerator) {
            // 获得全路径
            NSString *fullSubpath = [path stringByAppendingPathComponent:subpath];
            // 获得文件属性
            size += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
        }
        return size;
    } else { // 文件
        return [mgr attributesOfItemAtPath:path error:nil].fileSize;
    }
}

@end
