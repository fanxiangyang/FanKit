//
//  FanKitHead.h
//  FanKit
//
//  Created by 向阳凡 on 16/7/4.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#ifndef FanKitHead_h
#define FanKitHead_h

//系统版本号
#define __iOS__Version [[[UIDevice currentDevice] systemVersion] floatValue]
//屏幕宽高
#define FanScreenWidth [UIScreen mainScreen].bounds.size.width
#define FanScreenHeight [UIScreen mainScreen].bounds.size.height
//强制取长边为宽
#define FanScreenWidthRotion  (FanScreenWidth>FanScreenHeight?FanScreenWidth:FanScreenHeight)
#define FanScreenHeightRotion (FanScreenWidth>FanScreenHeight?FanScreenHeight:FanScreenWidth)

//打印数据
#ifdef DEBUG
# define FanLog(fmt, ...) NSLog((@"[文件名:%s]" "[函数名:%s]" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
# define FanLog(fmt, ...)
#endif

//颜色
#define FanColor(r,g,b,a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

//本地化
#define FanLocalizedString(key) NSLocalizedString(key, @"")
#define FanLocalizedStringFromTable(key,tbl) NSLocalizedStringFromTable(key, tbl, @"")

//自定义字体
#define FanSystemFontOfSize(fontName,fontSize) [UIFont fontWithName:fontName size:fontSize]
#define FanBoldFontOfSize(fontName,fontSize) [UIFont fontWithName:fontName size:fontSize]

//图片内存优化(对于大图片建议的加载模式)
#define FanFileBundlePath(fileBundleName) [[NSBundle mainBundle]pathForResource:[fileBundleName stringByDeletingPathExtension] ofType:[fileBundleName pathExtension]]
#define FanFileBundleSubPath(fileBundleName,subPath) [[NSBundle mainBundle]pathForResource:[fileBundleName stringByDeletingPathExtension] ofType:[fileBundleName pathExtension] inDirectory:subPath]

//取到图片，图片必须是全名，没有@2x，@3x
#define FanImageWithName(imageName) [UIImage imageWithContentsOfFile:FanFileBundlePath(imageName)]



#endif /* FanKitHead_h */
