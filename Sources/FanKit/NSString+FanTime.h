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
 格式化日期（几年，几天前，几点前)

 @param timeStamp 时间戳
 @return 格式化后结果
 */
+ (NSString *)fan_stringFromTimeStamp:(NSTimeInterval)timeStamp;
/**
 *  格式化日期（几年，几天前，几点前)
 *
 *  @param earlierDate 日期
 *
 *  @return 格式化后结果
 */
+ (NSString *)fan_stringFromSinceNowDateToEarlierDate:(NSDate *)earlierDate;

/**
 格式化日期（几年，几天前，几点前)

 @param timeSpace 与现在的时间间隔
 @return 格式化后结果
 */
+ (NSString *)fan_stringFromSinceNowWithSpace:(NSTimeInterval)timeSpace;
/**
 *  时间戳转化为时间字符串
 *
 *  @param stamp 时间戳
 *
 *  @return 字符串yyyy-MM-dd HH:mm:ss
 */
+(NSString*)fan_stringWithTimeStamp:(NSString *)stamp;
/**
 时间戳格式化想要的字符串
 
 @param format @"yyyy-MM-dd HH:mm:ss"
 @param timeStamp 时间戳
 @return 字符串2019-05-23 04:30:20
 */
+(NSString*)fan_stringWithFormat:(NSString *)format timeStamp:(NSTimeInterval)timeStamp;
/** 时间转换具体的天
 
 *  现在时间戳：      1427953149.691974
 *  时间戳           1427953149
 *  dataFormat:     yyyy-MM-dd hh:mm:ss
 *  时间：           2015年5月30号
 *  新闻事件：        2014/12/09
 *  直接汉字          昨天
 *  今天时刻          21:15
 */
+ (NSString *)fan_stingWithRealTime:(id)timeObj isGMT:(BOOL)isGMT;
/**
 时间戳转化成年月日
 
 @param timeStamp 时间戳
 @return 年月日对象
 */
+(NSDateComponents *)fan_componentsFromTimeStamp:(NSTimeInterval)timeStamp;



/**
 通过对象生成时间戳

 @param timeObj 时间对象（NSDate，NSNumber，NSString（【17位的和10位的数字】+【yyyy-MM-dd HH:mm:ss】+【yyyy/MM/dd】）
 @param isGMT 是否是GMT
 @return 时间戳
 */
+ (NSTimeInterval)fan_getRealTimeIntervalWith:(id)timeObj isGMT:(BOOL)isGMT;

/**
 时间戳转成 今天，昨天 年月

 @param timeStamp 时间戳
 @return 格式化后的时间显示
 */
+(NSString *)fan_stringFormatWithTimeStamp:(NSTimeInterval)timeStamp;
@end
