//
//  FanKitHead.h
//  FanKit
//
//  Created by 向阳凡 on 16/7/4.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#ifndef FanKitHead_h
#define FanKitHead_h

#import "FanUIKit.h"
/// 过期提醒  NS_DEPRECATED(2.0)
#define FanDeprecated(DESCRIPTION) __attribute__((deprecated(DESCRIPTION)))

#define FanWeakSelf __weak typeof(self) weakSelf = self;

//系统版本号
#define Fan_iOS_Version [[[UIDevice currentDevice] systemVersion] floatValue]
//屏幕宽高
#define FanScreenWidth [FanUIKit fan_mainScreen].bounds.size.width
#define FanScreenHeight [FanUIKit fan_mainScreen].bounds.size.height
#define FanWidth [FanUIKit fan_mainScreen].bounds.size.width
#define FanHeight [FanUIKit fan_mainScreen].bounds.size.height
//强制取长边为宽
#define FanScreenWidthRotion  (FanScreenWidth>FanScreenHeight?FanScreenWidth:FanScreenHeight)
#define FanScreenHeightRotion (FanScreenWidth>FanScreenHeight?FanScreenHeight:FanScreenWidth)

//打印数据
#ifdef DEBUG
# define FanLog(fmt, ...) NSLog((@"[%s:%d]\n" fmt), [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, ##__VA_ARGS__)
#else
# define FanLog(...)
#endif
//print打印
#ifdef DEBUG
#define FanPrintf(fmt, ...) fprintf(stderr, "%s:%d\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: fmt, ##__VA_ARGS__] UTF8String]);
#else
#define FanPrintf(...)
#endif

//颜色
#define FanColor(r,g,b,a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define FanColorf(r,g,b,a)   [UIColor colorWithRed:r green:g blue:b alpha:a]
///不带#的6位 488fjj 颜色值
#define FanHexColor(hex)   [FanUIKit fan_colorFromHexColor:hex]
//白色
#define FanWhiteColor(a)  [UIColor colorWithWhite:1.0 alpha:a]
//黑色
#define FanBlackColor(a) [[UIColor blackColor]colorWithAlphaComponent:a]
//本地化-废弃
#define FanLocalizedString(key) NSLocalizedString(key, @"")
#define FanLocalizedStringFromTable(key,tbl) NSLocalizedStringFromTable(key, tbl, @"")
//本地化-简化版
#define FanString(key) NSLocalizedString(key, @"")
#define FanStringTable(key,tbl) NSLocalizedStringFromTable(key, tbl, @"")

//自定义字体(废弃)
#define FanSystemFontOfSize(fontSize) [UIFont systemFontOfSize:fontSize]
#define FanBoldSystemFontOfSize(fontSize) [UIFont boldSystemFontOfSize:fontSize]

#define FanCustomFontOfSize(fontName,fontSize) [UIFont fontWithName:fontName size:fontSize]
//自定义字体(新)
#define FanFont(fontSize) [UIFont systemFontOfSize:fontSize]
#define FanMediumFont(fontSize) [UIFont systemFontOfSize:fontSize weight:UIFontWeightMedium]
#define FanBoldFont(fontSize) [UIFont boldSystemFontOfSize:fontSize]
#define FanFontName(fontName,fontSize) [UIFont fontWithName:fontName size:fontSize]

//图片内存优化(对于大图片建议的加载模式) asset.xcassets，只能用[UIImage imageName:@""]，支持@2x,@3x

///获取图片，可以读取asset.xcassets里面的图片
#define FanImageName(name) [UIImage imageNamed:name]
//---------------读取Bundle图片，不支持asset.xcassets--------------------
///自动获取bundle全名路径 user@2x.png
#define FanFileBundlePath(fileBundleName) [[NSBundle mainBundle]pathForResource:[fileBundleName stringByDeletingPathExtension] ofType:[fileBundleName pathExtension]]
#define FanFileBundleSubPath(fileBundleName,subPath) [[NSBundle mainBundle]pathForResource:[fileBundleName stringByDeletingPathExtension] ofType:[fileBundleName pathExtension] inDirectory:subPath]
///自动获取@2x,@3x图片路径
#define FanFileBundleName(fileBundleName) [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:fileBundleName]


///取到图片，图片必须是全名，没有@2x，@3x,拿去不到asset里面图片
#define FanImageWithAllName(imageName) [UIImage imageWithContentsOfFile:FanFileBundlePath(imageName)]

/**自动获取@2x,@3x图片*/
#define FanImageWithName(imageName)  [UIImage imageWithContentsOfFile:FanFileBundleName(imageName)]

///自动获取图片全路径
#define FanImageWithPath(imagePath) [UIImage imageWithContentsOfFile:imagePath]

///获取自定义bundle
#define FanBundle(bundleName) [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"]]
///或者自定义bundle里面的文件路径
#define FanBundleFilePath(bundleName,fileName)  [[FanBundle(bundleName) resourcePath] stringByAppendingString:fileName]
///获取自定义bundle里面的图片
#define FanImageWithBundle(bundleName,fileName) [UIImage imageWithContentsOfFile:FanBundleFilePath(bundleName,fileName)]
//---------------end--------------------

#endif /* FanKitHead_h */
