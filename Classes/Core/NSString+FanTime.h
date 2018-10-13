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
 *  字符串时间（2016-09-09 15:47:11）设定该时间为标准时区还是本地时区
 *
 *  @param dateStr 2016-09-09 15:47:11 至少10个字符串
 *  @param isGMT   是否是标准时间（GMT格林威治时间）否：本地时区
 *
 *  @return 日期
 */
+ (NSDate *)fan_stringToDate:(NSString *)dateStr isGMT:(BOOL)isGMT;
/**
 *  字符串时间（2016-09-09 15:47:11）设定改时间为哪个时区时间
 *
 *  @param dateStr  2016-09-09 15:47:11 至少10个字符串
 *  @param timeZone 时区
 *
 *  @return 日期
 */
+ (NSDate *)fan_stringToDate:(NSString *)dateStr timeZone:(NSTimeZone *)timeZone;
/**
 *  格式化日期（几年，几天前，几点前）
 *
 *  @param dateStr yyyy-MM-dd hh:mm:ss  至少10个字符串
 *  @param isGMT   是否是标准时间（GMT格林威治时间）否：本地时区
 *
 *  @return （几年，几天前，几点前）
 */
+ (NSString *)fan_stringFromCurrent:(NSString *)dateStr isGMT:(BOOL)isGMT;
/**
 *  格式化日期（几年，几天前，几点前)
 *
 *  @param earlierDate 日期
 *
 *  @return 格式化后结果
 */
+ (NSString *)fan_stringFromDate:(NSDate *)earlierDate;
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
+ (NSString *)fan_getTheRightTimeWith:(id)timeObj isGMT:(BOOL)isGMT;
/**
 时间戳转化成年月日
 
 @param stamp 时间戳
 @return 年月日对象
 */
+(NSDateComponents *)fan_componentsFromTimeStamp:(NSString *)stamp;
@end
