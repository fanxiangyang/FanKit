//
//  NSString+FanTime.m
//  FanKit
//
//  Created by 向阳凡 on 16/7/4.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import "NSString+FanTime.h"

#define FanMINUTES		60
#define FanHOURS		3600
#define FanDAYS		86400
#define FanMONTHS		(86400 * 30)
#define FanYEARS		(86400 * 30 * 12)

@implementation NSString (FanTime)
/**
 *  字符串转成日期
 *
 *  @param dateStr yyyy-MM-dd hh:mm:ss  至少10个字符串
 *
 *  @return 日期
 */
+ (NSDate *)fan_stringToDate:(NSString *)dateStr {
    
    if (10 > [dateStr length]) {
        
        return [NSDate date];
    }
    NSRange range;
    NSString *year, *month, *day, *hr, *mn, *sec;
    range.location = 0;
    range.length = 4;
    year = [dateStr substringWithRange:range];
    
    range.location = 5;
    range.length = 2;
    month = [dateStr substringWithRange:range];
    
    range.location = 8;
    range.length = 2;
    day = [dateStr substringWithRange:range];
    
    if (11 < [dateStr length]) {
        
        range.location = 11;
        range.length = 2;
        hr = [dateStr substringWithRange:range];
    } else {
        hr = @"0";
    }
    
    if (14 < [dateStr length]) {
        
        range.location = 14;
        range.length = 2;
        mn = [dateStr substringWithRange:range];
    } else {
        mn = @"0";
    }
    
    if (17 < [dateStr length]) {
        
        range.location = 17;
        range.length = 2;
        sec = [dateStr substringWithRange:range];
    } else {
        sec = @"0";
    }
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:		[year integerValue]];
    [comps setMonth:	[month integerValue]];
    [comps setDay:		[day integerValue]];
    [comps setHour:		[hr integerValue]];
    [comps setMinute:	[mn integerValue]];
    [comps setSecond:	[sec integerValue]];
    
    NSCalendar *gregorian = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *returnDate = [gregorian dateFromComponents:comps];
    return returnDate;
}

/**
 *  格式化日期（几年，几天前，几点前）
 *
 *  @param dateStr yyyy-MM-dd hh:mm:ss  至少10个字符串
 *
 *  @return （几年，几天前，几点前）
 */
+ (NSString *)fan_stringFromCurrent:(NSString *)dateStr {
    
    NSDate *earlierDate = [NSString fan_stringToDate:dateStr];
    
    NSDate *sysDate = [NSDate date];
    double timeInterval = [sysDate timeIntervalSinceDate:earlierDate];
    
    NSInteger yearsAgo = timeInterval / FanYEARS;
    if (1 < yearsAgo) {
        
        return [NSString stringWithFormat:@"%ld 年以前", (long)yearsAgo];
    } else if (1 == yearsAgo) {
        
        return @"1 年以前";
    }
    
    NSInteger monthsAgo = timeInterval / FanMONTHS;
    if (1 < monthsAgo) {
        
        return [NSString stringWithFormat:@"%ld 月以前", (long)monthsAgo];;
    } else if (1 == monthsAgo) {
        
        return [NSString stringWithFormat:@"1 月以前"];
    }
    
    NSInteger daysAgo = timeInterval / FanDAYS;
    if (1 < daysAgo) {
        
        return [NSString stringWithFormat:@"%ld 天以前", (long)daysAgo];
    } else if (1 == daysAgo) {
        
        return @"1 天以前";
    }
    
    NSInteger hoursAgo = timeInterval / FanHOURS;
    if (1 < hoursAgo) {
        
        return [NSString stringWithFormat:@"%ld 小时以前", (long)hoursAgo];
    } else if (1 == hoursAgo) {
        
        return @"1小时以前";
    }
    
    NSInteger minutesAgo = timeInterval / FanMINUTES;
    if (1 < minutesAgo) {
        
        return [NSString stringWithFormat:@"%ld 分钟以前", (long)minutesAgo];
    } else if (1 == minutesAgo) {
        
        return @"1 分钟以前";
    }
    return [NSString stringWithFormat:@"%ld 秒以前", (long)timeInterval];
}

/**
 *  时间戳转化为时间字符串
 *
 *  @param stamp 时间戳
 *
 *  @return 字符串yyyy-MM-dd HH:mm:ss
 */
+(NSString*)fan_timeStamp:(NSString *)stamp{
    NSTimeInterval time=[stamp doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]]; //设置时区
    return [formatter stringFromDate:detaildate];
}

/**  时间转换具体的天
 
 *  现在时间戳：      1427953149.691974
 *  时间戳           1427953149
 *  dataFormat:     yyyy-MM-dd hh:mm:ss
 *  时间：           2015年5月30号
 *  新闻事件：        2014/12/09
 *  直接汉字          昨天
 *  今天时刻          21:15
 */
+ (NSString *)fan_getTheRightTimeWith:(id)timeObj{
    NSString *returnStr;//返回字符串
    NSTimeInterval timeNum=0.0;
    
    if([timeObj isKindOfClass:[NSDate class]])
    {
        NSDate *timeDate = (NSDate *)timeObj;
        timeNum = [timeDate timeIntervalSince1970];
    }else if([timeObj isKindOfClass:[NSNumber class]]){
        timeNum = [timeObj doubleValue];
    }else if ([timeObj isKindOfClass:[NSString class]]){
        NSString *timeStr = (NSString *)timeObj;
        NSString *Regex = @"^[\u4e00-\u9fa5]{0,}$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
        if(timeStr.length == 17){
            timeNum = [timeStr doubleValue];
        }else if(timeStr.length == 5){
            returnStr = timeStr;
            return returnStr;
        }else if (timeStr.length == 10){
            NSRange range = [timeStr rangeOfString:@"/"];
            if(range.length){
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"YYYY/MM/dd"];
                //设置时区 NSDataFormatter默认输出格林威治时间，要输出本地时间要设置时区 ，跟北京时间差8小时
                [formatter setTimeZone:[NSTimeZone localTimeZone]];
                NSDate *theDate =  [formatter dateFromString:timeStr];
                timeNum = [theDate timeIntervalSince1970];
            }else{
                timeNum = [timeStr doubleValue];
            }
        }else if ([predicate evaluateWithObject:timeStr]){
            returnStr = timeStr;
            return returnStr;
        }else{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            //设置时区 NSDataFormatter默认输出格林威治时间，要输出本地时间要设置时区 ，跟北京时间差8小时
            [formatter setTimeZone:[NSTimeZone localTimeZone]];
            NSDate *theDate =  [formatter dateFromString:timeStr];
            timeNum = [theDate timeIntervalSince1970];
        }
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //设置时区 NSDataFormatter默认输出格林威治时间，要输出本地时间要设置时区 ，跟北京时间差8小时
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    //处理凌晨时间戳
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd 23:59:59"];
    [dateFormatter1 setTimeZone:[NSTimeZone localTimeZone]];
    NSString *currentDateStr1 = [dateFormatter1 stringFromDate:[NSDate date]];
    
    NSTimeInterval timeNowNum = [[NSString fan_stringToDate:currentDateStr1]timeIntervalSince1970];
    
    //要处理的date
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:timeNum];
    
    //是否同一天
    int betweenDay = ((int)(timeNowNum -timeNum)/(FanDAYS));
    int betweenYear = ((int)(timeNowNum -timeNum)/(FanYEARS)) ;
    //不是今年
    if(betweenYear && betweenYear<20){
        [formatter setDateFormat:@"YYYY-MM-dd"];
        returnStr = [formatter stringFromDate:lastDate];
    }else if(betweenYear == 0){
        if (betweenDay == 0){
            //今天
            [formatter setDateFormat:@"HH:mm"];
            returnStr = [formatter stringFromDate:lastDate];
        }else if (betweenDay == 1){
            //昨天
            returnStr = @"昨天";
        }else{
            [formatter setDateFormat:@"YYYY-MM-dd"];
            returnStr = [formatter stringFromDate:lastDate];
        }
    }else{
        returnStr = @"";
    }
    
    return returnStr;
}
@end
