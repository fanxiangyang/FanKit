//
//  FanToolBox.h
//  Brain
//
//  Created by 向阳凡 on 2018/6/5.
//  Copyright © 2018年 向阳凡. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FanToolBox : NSObject



#pragma mark - 文件操作
/** 缓存路径*/
+(NSString *)fan_cachePath;
+(NSString *)fan_documentPath;
+(BOOL)fan_createDirectoryAtPath:(NSString *)filePath;
///文件copy,必须是全路径包括扩展名，不然不能copy
+(BOOL)fan_copyAtFilePath:(NSString *)srcFilePath toFilePath:(NSString *)toFilePath;
/** copy文件夹下所有子文件和文件夹，放到目标文件夹下 是否移除旧文件*/
+(void)fan_copyAtDirPath:(NSString *)srcDirPath toDirPath:(NSString *)toDirPath isRemoveOld:(BOOL)isRemoveOld;
/**删除目录下所有文件*/
+ (BOOL)fan_deleteFilesAtPath:(NSString *)filePath;
+ (BOOL)fan_deleteFile:(NSString *)filePath;//删除文件
/** 请求文件（夹）路径的所有文件大小（字节）*/
+ (unsigned long long)fan_fileSizeFromPath:(NSString *)path;

//删除文件下大于7天的文件

#pragma mark - 其他
/** 获取WiFi ssid*/
+(NSString *)fan_wifiInfo_ssid;
///必须在有网的情况下才能获取手机的IP地址
+ (NSString *)fan_IPAdress;
///获取是否打开WiFi
+ (BOOL)fan_isOpenWiFi;
@end
