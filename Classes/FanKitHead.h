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

#define FanScreenWidth [UIScreen mainScreen].bounds.size.width
#define FanScreenHeight [UIScreen mainScreen].bounds.size.height


//打印数据
#ifdef DEBUG
# define FanLog(fmt, ...) NSLog((@"[文件名:%s]" "[函数名:%s]" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define FanLog(fmt, ...) NSLog((@"[文件名:%s]" "[函数名:%s]" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif

//颜色
#define FanColor(r,g,b,a)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]




#endif /* FanKitHead_h */
