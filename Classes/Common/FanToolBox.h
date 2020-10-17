//
//  FanToolBox.h
//  Brain
//
//  Created by 向阳凡 on 2018/6/5.
//  Copyright © 2018年 向阳凡. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FanToolBox : NSObject


#pragma mark - 类，数据操作

/// json字符串转字典
/// @param jsonString json字符串
+(NSDictionary *)fan_dictionaryWithString:(NSString *)jsonString;
/// json字符串转数组
/// @param jsonString json字符串
+(NSArray *)fan_arrayWithString:(NSString *)jsonString;


#pragma mark - 文件操作
/** 缓存路径  NSTemporaryDirectory() = tmp文件夹*/
+(NSString *)fan_cachePath;
+(NSString *)fan_documentPath;
+(BOOL)fan_createDirectoryAtPath:(NSString *)filePath;
///文件copy,必须是全路径包括扩展名，不然不能copy
+(BOOL)fan_copyAtFilePath:(NSString *)srcFilePath toFilePath:(NSString *)toFilePath;
/** copy文件夹下所有子文件和文件夹，放到目标文件夹下 是否移除旧文件*/
+(void)fan_copyAtDirPath:(NSString *)srcDirPath toDirPath:(NSString *)toDirPath isRemoveOld:(BOOL)isRemoveOld;
///重命名 文件/文件夹 (移动 文件/文件夹) removeOld=NO如果有旧文件失败
+(BOOL)fan_moveSrcPath:(NSString *)srcPath toPath:(NSString *)toPath removeOld:(BOOL)removeOld;
///重命名文件/文件夹 pathName重命名的名字不含路径
+(BOOL)fan_moveSrcPath:(NSString *)srcPath pathName:(NSString *)pathName;
/**删除目录下所有文件*/
+ (BOOL)fan_deleteFilesAtPath:(NSString *)filePath;
+ (BOOL)fan_deleteFile:(NSString *)filePath;//删除文件
/** 请求文件（夹）路径的所有文件大小（字节）*/
+ (unsigned long long)fan_fileSizeFromPath:(NSString *)path;

///随机生成len长度的字符串(a-zA-Z0-9) 避免0开头
+(NSString *)fan_randomStringWithLength:(NSInteger)len;

#pragma mark - 其他
//if(@available(iOS 13.0,*))特殊设置
//1、使用定位功能，并且获得了定位服务权限的应用;
//2、使用NEHotspotConfiguration配置过的Wi-Fi;
//3、应用程序已安装有效的VPN配置;
/** 获取WiFi ssid*/
+(NSString *)fan_wifiInfo_ssid;
///必须在有网的情况下才能获取手机的IP地址
+ (NSString *)fan_IPAdress;
///获取是否打开WiFi
+ (BOOL)fan_isOpenWiFi;
#pragma mark 返回设备类型
+(NSString *)fan_platformString;
@end
