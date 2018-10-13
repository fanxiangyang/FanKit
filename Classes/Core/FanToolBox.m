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

@implementation FanToolBox

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
        //        //如果文件路径不存在，取到应用缓存路径Caches(同级别的有Cookies）
        //        NSString *caches=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
        //        //        path=[caches stringByAppendingPathComponent:@"default"];
        //        path=caches;
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
#pragma mark - 其他

+(NSString *)fan_wifiInfo_ssid{
    NSArray *ifs=(__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    NSString *ssid;
    for (NSString *ifnam in ifs) {
        info=(__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        //        NSLog(@"22222:%@=>%@",ifnam,info);
        if(info){
            ssid=info[@"SSID"];
            break;
        }
        if(info&&[info count]){
            break;
        }
    }
    return ssid;
}

@end
