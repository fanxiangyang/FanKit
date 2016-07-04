//
//  NSString+FanTime.h
//  FanKit
//
//  Created by 向阳凡 on 16/7/4.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FanTime)
/**
 *  字符串转成日期
 *
 *  @param dateStr yyyy-MM-dd hh:mm:ss  至少10个字符串
 *
 *  @return 日期
 */
+ (NSDate *)fan_stringToDate:(NSString *)dateStr;

/**
 *  格式化日期（几年，几天前，几点前）
 *
 *  @param dateStr yyyy-MM-dd hh:mm:ss  至少10个字符串
 *
 *  @return （几年，几天前，几点前）
 */
+ (NSString *)fan_stringFromCurrent:(NSString *)dateStr;

/**
 *  时间戳转化为时间字符串
 *
 *  @param stamp 时间戳
 *
 *  @return 字符串yyyy-MM-dd HH:mm:ss
 */
+(NSString*)fan_timeStamp:(NSString *)stamp;

/** 时间转换具体的天
 
 *  现在时间戳：      1427953149.691974
 *  时间戳           1427953149
 *  dataFormat:     yyyy-MM-dd hh:mm:ss
 *  时间：           2015年5月30号
 *  新闻事件：        2014/12/09
 *  直接汉字          昨天
 *  今天时刻          21:15
 */
+ (NSString *)fan_getTheRightTimeWith:(id)timeObj;

@end
