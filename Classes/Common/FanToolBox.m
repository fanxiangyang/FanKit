//
//  FanToolBox.m
//  Brain
//
//  Created by 向阳凡 on 2018/6/5.
//  Copyright © 2018年 向阳凡. All rights reserved.
//

#import "FanToolBox.h"
//获取WiFi
#import <SystemConfiguration/CaptiveNetwork.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
//获取设备信息
#import <sys/sysctl.h>

@implementation FanToolBox
#pragma mark - 类，数据操作

+(NSDictionary *)fan_dictionaryWithString:(NSString *)jsonString{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [FanToolBox fan_dictionaryWithJsonData:jsonData];
}

+(NSDictionary *)fan_dictionaryWithJsonPath:(NSString *)jsonPath{
    if (![[NSFileManager defaultManager] fileExistsAtPath:jsonPath]){
        return nil;
    }
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    return [FanToolBox fan_dictionaryWithJsonData:jsonData];
}
+(NSDictionary *)fan_dictionaryWithJsonData:(NSData *)jsonData{
    if (jsonData==nil) {
        return nil;
    }
    NSError *error=nil;
    //NSJSONReadingMutableContainers 可变的数组和字典
    //NSJSONReadingMutableLeaves 指定返回json对象内部的字符串为可变字符串的实例
    //NSJSONReadingAllowFragments 指定解析的时候允许最外层(最顶层)的对象可以不是一个数组或字典对象也是可以的
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        return nil;
    }else{
        if (![dic isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        return dic;
    }
}
+(NSArray *)fan_arrayWithString:(NSString *)jsonString{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [FanToolBox fan_arrayWithJsonData:jsonData];
}
+(NSArray *)fan_arrayWithJsonPath:(NSString *)jsonPath{
    if (![[NSFileManager defaultManager] fileExistsAtPath:jsonPath]){
        return nil;
    }
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    return [FanToolBox fan_arrayWithJsonData:jsonData];
}
+(NSArray *)fan_arrayWithJsonData:(NSData *)jsonData{
    if (jsonData==nil) {
        return nil;
    }
    NSError *error=nil;
    //NSJSONReadingMutableContainers 可变的数组和字典
    //NSJSONReadingMutableLeaves 指定返回json对象内部的字符串为可变字符串的实例
    //NSJSONReadingAllowFragments 指定解析的时候允许最外层(最顶层)的对象可以不是一个数组或字典对象也是可以的
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        return nil;
    }else{
        if (![array isKindOfClass:[NSArray class]]) {
            return nil;
        }
    }
    return array;
}

#pragma mark - 文件操作

+(NSString *)fan_cachePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = ([paths count] > 0) ? [paths objectAtIndex:0] : [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] ;
    return cachePath;
}
+(NSString *)fan_documentPath{
    //    return [self fan_cachePath];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cachePath = ([paths count] > 0) ? [paths objectAtIndex:0] : [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ;
    return cachePath;
}
+(NSString *)fan_tmpPath{
    //NSTemporaryDirectory()生成的带/private/var---/tmp/
    return [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
}
+(BOOL)fan_createDirectoryAtPath:(NSString *)filePath{
    NSString *filePathCopy=[filePath copy];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    NSError *error=nil;
    if (![fileManager fileExistsAtPath:filePathCopy isDirectory:&isDir])
    {
        
        if ([filePathCopy pathExtension].length>0) {
            filePathCopy=[filePathCopy stringByDeletingLastPathComponent];
        }
        [fileManager createDirectoryAtPath:filePathCopy withIntermediateDirectories:YES attributes:nil error:&error];
    }
    if (error) {
        return NO;
    }
    return YES;
}
+(BOOL)fan_copyAtFilePath:(NSString *)srcFilePath toFilePath:(NSString *)toFilePath{
    if ([srcFilePath isEqualToString:toFilePath]) {
        return YES;
    }
    [FanToolBox fan_createDirectoryAtPath:toFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:srcFilePath isDirectory:nil]) {
        BOOL isDir=NO;
        if ([fileManager fileExistsAtPath:toFilePath isDirectory:&isDir]) {
            if (isDir==NO) {
                [fileManager removeItemAtPath:toFilePath error:nil];
                [fileManager copyItemAtPath:srcFilePath toPath:toFilePath error:nil];
            }
        }else{
            [fileManager copyItemAtPath:srcFilePath toPath:toFilePath error:nil];
        }
    }
    if ([fileManager fileExistsAtPath:toFilePath isDirectory:nil]) {
        return YES;
    }else{
        return NO;
    }
}
//文件夹copy
+(void)fan_copyAtDirPath:(NSString *)srcDirPath toDirPath:(NSString *)toDirPath isRemoveOld:(BOOL)isRemoveOld{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    BOOL isDir;
    //    if (![fileManager fileExistsAtPath:toDirPath isDirectory:&isDir])
    //    {
    //        [fileManager createDirectoryAtPath:toDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    //    }
    //    if (isRemoveOld) {
    //        //只移除文件，不移除路径
    //        if (isDir) {
    //            [fileManager removeItemAtPath:toDirPath error:nil];
    //        }
    //    }
    //    [fileManager copyItemAtPath:srcDirPath toPath:toDirPath error:nil];
    
    //当前srcDirPath目录下全路径（包含文件夹）  ***/**.png
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:srcDirPath];
    for (NSString *fileStr in enumerator) {
        //        NSLog(@"%@",fileStr);
        BOOL isDir;
        NSString *srcFileName=[srcDirPath stringByAppendingPathComponent:fileStr];
        if (![fileManager fileExistsAtPath:srcFileName isDirectory:&isDir])
        {
            continue;
        }
        if (isDir) {
            //是路径
        }else{
            //文件
            NSString *fileAllPath=[[toDirPath stringByAppendingPathComponent:fileStr] stringByDeletingLastPathComponent];
            if (![fileManager fileExistsAtPath:fileAllPath isDirectory:&isDir])
            {
                [fileManager createDirectoryAtPath:fileAllPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            if (isRemoveOld) {
                //移除文件，移除路径
                [fileManager removeItemAtPath:[toDirPath stringByAppendingPathComponent:fileStr] error:nil];
            }
            [fileManager copyItemAtPath:srcFileName toPath:[toDirPath stringByAppendingPathComponent:fileStr] error:nil];
        }
        
    }
}
+(BOOL)fan_moveSrcPath:(NSString *)srcPath pathName:(NSString *)pathName{
    NSString *toPath=[srcPath stringByReplacingOccurrencesOfString:[srcPath lastPathComponent] withString:pathName];
    return [FanToolBox fan_moveSrcPath:srcPath toPath:toPath removeOld:YES];
}
//文件夹move
+(BOOL)fan_moveSrcPath:(NSString *)srcPath toPath:(NSString *)toPath removeOld:(BOOL)removeOld{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:srcPath isDirectory:&isDir])
    {
        return NO;
    }
    if ([srcPath isEqualToString:toPath]) {
        return YES;
    }
    NSError *error = nil;
    if (isDir) {
        //文件夹
        if (![fileManager fileExistsAtPath:toPath isDirectory:&isDir])
        {
            [fileManager createDirectoryAtPath:[toPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
        }else{
            if (removeOld) {
                [fileManager removeItemAtPath:toPath error:nil];
            }else{
                return NO;
            }
        }
        BOOL success = [fileManager moveItemAtPath:srcPath toPath:toPath error:&error];
        if (success==NO) {
            NSLog(@"重命名Error:%@",error);
            return NO;
        }
        
    }else{
        //文件
        if (![fileManager fileExistsAtPath:toPath isDirectory:&isDir])
        {
            NSString *filePath=[toPath stringByReplacingOccurrencesOfString:[toPath lastPathComponent] withString:@""];
            [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }else{
            if (removeOld) {
                [fileManager removeItemAtPath:toPath error:nil];
            }else{
                return NO;
            }
        }
        BOOL success = [fileManager moveItemAtPath:srcPath toPath:toPath error:&error];
        if (success==NO) {
            NSLog(@"重命名Error:%@",error);
            return NO;
        }
    }
    return YES;
}
/**删除目录下所有文件*/
+ (BOOL)fan_deleteFilesAtPath:(NSString *)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:filePath]){
        return YES;
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
///删除目录所有内容包括他本身
+ (BOOL)fan_deleteAllAtPath:(NSString *)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:filePath]){
        return YES;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:filePath] objectEnumerator];
    NSString* fileName;
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString* fileAbsolutePath = [filePath stringByAppendingPathComponent:fileName];
        NSError *error;
        [manager removeItemAtPath:fileAbsolutePath error:&error];
    }
    [manager removeItemAtPath:filePath error:nil];
    return YES;
}
+ (BOOL)fan_deleteFile:(NSString *)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSError *error;
    BOOL isDir=NO;
    if ([manager fileExistsAtPath:filePath isDirectory:&isDir]) {
        if (isDir) {
//            NSLog(@"删除路径");
        }else{
            [manager removeItemAtPath:filePath error:&error];
        }
    }
    if (error) {
        return NO;
    }
    return YES;
}
///判断是否 只存在文件，不是路径
+(BOOL)fan_fileExistsAtFilePath:(NSString *)filePath{
    BOOL isDir=NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir]) {
        return NO;
    }else{
        if (isDir) {
            return NO;
        }
        return YES;
    }
}
/**
 *  请求文件（夹）路径的所有文件大小
 *
 *  @param path 文件（夹）路径
 *
 *  @return 返回大小，字节
 */
+ (unsigned long long)fan_fileSizeFromPath:(NSString *)path
{
    if (path==nil) {
        return 0;
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
        // 获得文件夹中的所有内容enumeratorAtPath遍历事for内存不释放
        //NSDirectoryEnumerationSkipsHiddenFiles忽略隐藏文件大小
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtURL:[NSURL fileURLWithPath:path] includingPropertiesForKeys:@[NSFileSize] options:0 errorHandler:NULL];
        for(NSURL *fileURL in enumerator){
            NSNumber *fileSize;
            [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            size+=fileSize.unsignedIntegerValue;
        }
        return size;
    } else { // 文件
        return [mgr attributesOfItemAtPath:path error:nil].fileSize;
    }
}
+(NSString *)fan_randomStringWithLength:(NSInteger)len{
    NSString *randomStr=@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    [randomString appendFormat: @"%C", [randomStr characterAtIndex:arc4random_uniform((uint32_t)[randomStr length]-1)]];
    for (NSInteger i = 1; i < len; i++) {
        [randomString appendFormat: @"%C", [randomStr characterAtIndex:arc4random_uniform((uint32_t)[randomStr length])]];
    }
    return randomString;
}
#pragma mark - 其他
//if(@available(iOS 13.0,*))特殊设置
//1、使用定位功能，并且获得了定位服务权限的应用;
//2、使用NEHotspotConfiguration配置过的Wi-Fi;
//3、应用程序已安装有效的VPN配置;
+(NSString *)fan_wifiInfo_ssid{
    NSString *ssid;
#if TARGET_OS_IOS
    NSArray *ifs=(__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        //iOS14之后建议用NEHotspotNetwork，需要向苹果申请权限
        info=(__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if(info){
            ssid=info[(__bridge NSString*)kCNNetworkInfoKeySSID];
            break;
        }
        if(info&&[info count]){
            break;
        }
    }
#endif
    return ssid;
}
//必须在有网的情况下才能获取手机的IP地址
+ (NSString *)fan_IPAdress {
    NSString *address = @"0.0.0.0";
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
                    
                    //                    //广播地址--10.22.70.255
                    //                    NSLog(@"广播地址--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)]);
                    //                    //本机地址--10.22.70.111
                    //                    NSLog(@"本机地址--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]);
                    //                    //子网掩码地址--255.255.255.0
                    //                    NSLog(@"子网掩码地址--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)]);
                    //                    //端口地址--en0
                    //                    NSLog(@"端口地址--%@",[NSString stringWithUTF8String:temp_addr->ifa_name]);
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

+ (BOOL)fan_isOpenWiFi{
    NSCountedSet * cset = [NSCountedSet new];
    struct ifaddrs *interfaces;
    if( ! getifaddrs(&interfaces) ) {
        for( struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next) {
            if ( (interface->ifa_flags & IFF_UP) == IFF_UP ) {
                [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
            }
        }
    }
    return [cset countForObject:@"awdl0"] > 1 ? YES : NO;
}
#pragma mark 返回设备类型

+(NSString *)fan_platformString{
    // Gets a string with the device model
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
//    NSDictionary* d =  @{
//        @"iPhone1,1": @"iPhone 2G",
//        @"iPhone1,2": @"iPhone 3G",
//        @"iPhone2,1": @"iPhone 3GS",
//        @"iPhone3,1": @"iPhone 4",
//        @"iPhone3,2": @"iPhone 4",
//        @"iPhone3,3": @"iPhone 4 (CDMA)",
//        @"iPhone4,1": @"iPhone 4S",
//        @"iPhone5,1": @"iPhone 5 (CDMA)",
//        @"iPhone5,2": @"iPhone 5 (GSM+CDMA)",
//        @"iPhone5,3": @"iPhone 5C (CDMA)",
//        @"iPhone5,4": @"iPhone 5C (GSM+CDMA)",
//        @"iPhone6,1": @"iPhone 5S (CDMA)",
//        @"iPhone6,2": @"iPhone 5S (GSM+CDMA)",
//        @"iPhone7,1": @"iPhone 6 Plus",
//        @"iPhone7,2": @"iPhone 6",
//        @"iPhone8,1": @"iPhone 6S",
//        @"iPhone8,2": @"iPhone 6S Plus",
//        @"iPhone8,4": @"iPhone SE",
//        @"iPhone9,1": @"iPhone 7",
//        @"iPhone9,3": @"iPhone 7",
//        @"iPhone9,2": @"iPhone 7 Plus",
//        @"iPhone9,4": @"iPhone 7 Plus",
//        @"iPhone10,1": @"iPhone 8",
//        @"iPhone10,4": @"iPhone 8",
//        @"iPhone10,2": @"iPhone 8 Plus",
//        @"iPhone10,5": @"iPhone 8 Plus",
//        @"iPhone10,3": @"iPhone X",
//        @"iPhone10,6": @"iPhone X",
//
//        @"iPhone11,8": @"iPhone XR",
//        @"iPhone11,2": @"iPhone XS",
//        @"iPhone11,4": @"iPhone XS Max",
//        @"iPhone11,6": @"iPhone XS Max",
//
//
//        @"iPod1,1": @"iPod Touch (1 Gen)",
//        @"iPod2,1": @"iPod Touch (2 Gen)",
//        @"iPod3,1": @"iPod Touch (3 Gen)",
//        @"iPod4,1": @"iPod Touch (4 Gen)",
//        @"iPod5,1": @"iPod Touch (5 Gen)",
//        @"iPod7,1": @"iPod Touch (6 Gen)",
//
//        @"iPad1,1": @"iPad",
//        @"iPad1,2": @"iPad 3G",
//        @"iPad2,1": @"iPad 2 (WiFi)",
//        @"iPad2,2": @"iPad 2",
//        @"iPad2,3": @"iPad 2 (CDMA)",
//        @"iPad2,4": @"iPad 2",
//        @"iPad2,5": @"iPad Mini (WiFi)",
//        @"iPad2,6": @"iPad Mini",
//        @"iPad2,7": @"iPad Mini (GSM+CDMA)",
//        @"iPad3,1": @"iPad 3 (WiFi)",
//        @"iPad3,2": @"iPad 3 (GSM+CDMA)",
//        @"iPad3,3": @"iPad 3",
//        @"iPad3,4": @"iPad 4 (WiFi)",
//        @"iPad3,5": @"iPad 4",
//        @"iPad3,6": @"iPad 4 (GSM+CDMA)",
//        @"iPad4,1": @"iPad air",
//        @"iPad4,2": @"iPad air",
//        @"iPad4,3": @"iPad air",
//        @"iPad4,4": @"iPad mini 2",
//        @"iPad4,5": @"iPad mini 2",
//        @"iPad4,6": @"iPad mini 2",
//        @"iPad4,7": @"iPad mini 3",
//        @"iPad4,8": @"iPad mini 3",
//        @"iPad4,9": @"iPad mini 3",
//        @"iPad5,1": @"iPad mini 4",
//        @"iPad5,2": @"iPad mini 4",
//        @"iPad5,3": @"iPad air 2",
//        @"iPad5,4": @"iPad air 2",
//
//        @"iPad6,3": @"iPad Pro 9.7",
//        @"iPad6,4": @"iPad Pro 9.7",
//        @"iPad6,7": @"iPad Pro 12.9",
//        @"iPad6,8": @"iPad Pro 12.9",
//
//        @"iPad6,11": @"iPad 2017 9.7",
//        @"iPad6,12": @"iPad 2017 9.7",
//
//        @"iPad7,1": @"iPad Pro 12.9",
//        @"iPad7,2": @"iPad Pro 12.9",
//        @"iPad7,3": @"iPad Pro 10.5",
//        @"iPad7,4": @"iPad Pro 10.5",
//        @"iPad7,5": @"iPad 2018 9.7",
//        @"iPad7,6": @"iPad 2018 9.7",
//
//
//        @"i386": @"Simulator",
//        @"x86_64": @"Simulator"
//    };
    if (platform.length==0){
        return [UIDevice currentDevice].model;
    }
    return platform;
}

#pragma mark - 数学公式

/// 获取三次Hermite插值函数y
/// @param p0 开始点
/// @param p1 结束点
/// @param rp0 开始点倒数
/// @param rp1 结束点倒数
/// @param x 带入x
+(double)fan_hemiteP0:(CGPoint)p0 p1:(CGPoint)p1 rp0:(float)rp0 rp1:(float)rp1 x:(float)x{
    if (p1.x-p0.x==0.0f) {
        return 0;
    }
    double y=p0.y*(1.0+2.0f*(x-p0.x)/(p1.x-p0.x))*pow(((x-p1.x)/(p0.x-p1.x)), 2)+p1.y*(1.0+2.0f*(x-p1.x)/(p0.x-p1.x))*pow(((x-p0.x)/(p1.x-p0.x)), 2)+rp0*(x-p0.x)*pow(((x-p1.x)/(p0.x-p1.x)), 2)+rp1*(x-p1.x)*pow(((x-p0.x)/(p1.x-p0.x)), 2);
    return y;
}

/// 获取3次贝塞尔曲线函数方程
/// @param p0 开始点
/// @param p1 结束点
/// @param c0 控制点0
/// @param c1 控制点1
/// @param t 相对x取值区间 0<t<1
+(CGPoint)fan_bezierPointP0:(CGPoint)p0 p1:(CGPoint)p1 c0:(CGPoint)c0 c1:(CGPoint)c1 t:(float)t{
    CGPoint b=CGPointZero;
    b.x=[FanToolBox fan_bezierP0:p0.x p1:p1.x c0:c0.x c1:c1.x t:t];
    b.y=[FanToolBox fan_bezierP0:p0.y p1:p1.y c0:c0.y c1:c1.y t:t];
    return b;
}
/// 获取3次贝塞尔曲线函数方程
/// @param p0 开始点
/// @param p1 结束点
/// @param c0 控制点0
/// @param c1 控制点1
/// @param t 相对x取值区间 0<t<1
+(double)fan_bezierP0:(float)p0 p1:(float)p1 c0:(float)c0 c1:(float)c1 t:(float)t{
    double b=p0*pow((1.0-t), 3)+3.0f*c0*t*pow((1.0f-t), 2)+3.0*c1*pow(t, 2)*(1.0-t)+p1*pow(t, 3);
    return b;
}

@end
