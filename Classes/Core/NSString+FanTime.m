//
//  NSString+FanTime.m
//  FanKit
//
//  Created by 向阳凡 on 16/7/4.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import "NSString+FanTime.h"
#import "NSBundle+FanKit.h"

#define FanMINUTES        60
#define FanHOURS        3600
#define FanDAYS         86400
#define FanMONTHS        (86400 * 30)
#define FanYEARS        (86400 * 365)

@implementation NSString (FanTime)

+ (NSDate *)fan_stringToDate:(NSString *)dateStr isGMT:(BOOL)isGMT{
    if (isGMT) {
        return  [[self class]fan_stringToDate:dateStr timeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    }else{
        return  [[self class]fan_stringToDate:dateStr timeZone:[NSTimeZone localTimeZone]];
    }
}
+ (NSDate *)fan_stringToDate:(NSString *)dateStr timeZone:(NSTimeZone *)timeZone{
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
    [comps setYear:        [year integerValue]];
    [comps setMonth:    [month integerValue]];
    [comps setDay:        [day integerValue]];
    [comps setHour:        [hr integerValue]];
    [comps setMinute:    [mn integerValue]];
    [comps setSecond:    [sec integerValue]];
    
    NSCalendar *gregorian = [NSCalendar autoupdatingCurrentCalendar];
    gregorian.timeZone=timeZone;
    NSDate *returnDate = [gregorian dateFromComponents:comps];
    return returnDate;
}
+ (NSString *)fan_stringFromTimeStamp:(NSTimeInterval)timeStamp{
    double timeInterval = [[NSDate date] timeIntervalSince1970]-timeStamp;
    return [[self class] fan_stringFromSinceNowWithSpace:timeInterval];
}
+ (NSString *)fan_stringFromSinceNowDateToEarlierDate:(NSDate *)earlierDate{
    double timeInterval = [[NSDate date] timeIntervalSinceDate:earlierDate];
    return [[self class]fan_stringFromSinceNowWithSpace:timeInterval];
}
+ (NSString *)fan_stringFromSinceNowWithSpace:(NSTimeInterval)timeSpace{
    double timeInterval = timeSpace;
    NSInteger yearsAgo = timeInterval / FanYEARS;
    if (1 < yearsAgo) {
        
        return [NSString stringWithFormat:@"%ld %@", (long)yearsAgo,[NSBundle fan_localizedStringForKey:@"FanKit_yearAgo" value:@"年以前"]];
    } else if (1 == yearsAgo) {
        
        return [NSString stringWithFormat:@"1 %@",[NSBundle fan_localizedStringForKey:@"FanKit_yearAgo" value:@"年以前"]];
    }
    
    NSInteger monthsAgo = timeInterval / FanMONTHS;
    if (1 < monthsAgo) {
        
        return [NSString stringWithFormat:@"%ld %@", (long)monthsAgo,[NSBundle fan_localizedStringForKey:@"FanKit_monthAgo" value:@"月以前"]];;
    } else if (1 == monthsAgo) {
        
        return [NSString stringWithFormat:@"1 %@",[NSBundle fan_localizedStringForKey:@"FanKit_monthAgo" value:@"月以前"]];
    }
    
    NSInteger daysAgo = timeInterval / FanDAYS;
    if (1 < daysAgo) {
        
        return [NSString stringWithFormat:@"%ld %@", (long)daysAgo,[NSBundle fan_localizedStringForKey:@"FanKit_dayAgo" value:@"天以前"]];
    } else if (1 == daysAgo) {
        
        return [NSString stringWithFormat:@"1 %@",[NSBundle fan_localizedStringForKey:@"FanKit_dayAgo" value:@"天以前"]];
    }
    
    NSInteger hoursAgo = timeInterval / FanHOURS;
    if (1 < hoursAgo) {
        
        return [NSString stringWithFormat:@"%ld %@", (long)hoursAgo,[NSBundle fan_localizedStringForKey:@"FanKit_hourAgo" value:@"小时以前"]];
    } else if (1 == hoursAgo) {
        
        return [NSString stringWithFormat:@"1 %@",[NSBundle fan_localizedStringForKey:@"FanKit_hourAgo" value:@"小时以前"]];
    }
    
    NSInteger minutesAgo = timeInterval / FanMINUTES;
    if (1 < minutesAgo) {
        
        return [NSString stringWithFormat:@"%ld %@", (long)minutesAgo,[NSBundle fan_localizedStringForKey:@"FanKit_minuteAgo" value:@"分钟以前"]];
    } else if (1 == minutesAgo) {
        
        return [NSString stringWithFormat:@"1 %@",[NSBundle fan_localizedStringForKey:@"FanKit_minuteAgo" value:@"分钟以前"]];
    }
    return [NSString stringWithFormat:@"%ld %@", (long)timeInterval,[NSBundle fan_localizedStringForKey:@"FanKit_secondAgo" value:@"秒以前"]];
}
/**
 *  格式化日期（几年，几天前，几点前）
 *
 *  @param dateStr yyyy-MM-dd hh:mm:ss  至少10个字符串
 *  @param isGMT   是否是标准时间（GMT格林威治时间）否：本地时区
 *
 *  @return （几年，几天前，几点前）
 */
+ (NSString *)fan_stringFromCurrent:(NSString *)dateStr isGMT:(BOOL)isGMT{
    
    NSDate *earlierDate = [NSString fan_stringToDate:dateStr isGMT:isGMT];
    return [[self class]fan_stringFromSinceNowDateToEarlierDate:earlierDate];
    
}

/**
 *  时间戳转化为时间字符串
 *
 *  @param stamp 时间戳
 *
 *  @return 字符串yyyy-MM-dd HH:mm:ss
 */
+(NSString*)fan_stringWithTimeStamp:(NSString *)stamp{
    NSTimeInterval time=[stamp doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]]; //设置时区
    return [formatter stringFromDate:detaildate];
}
/**
 时间戳格式化想要的字符串
 
 @param format @"yyyy-MM-dd HH:mm:ss"
 @param timeStamp 时间戳
 @return 字符串2019-05-23 04:30:20
 */
+(NSString*)fan_stringWithFormat:(NSString *)format timeStamp:(NSTimeInterval)timeStamp{
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
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
+ (NSString *)fan_stingWithRealTime:(id)timeObj isGMT:(BOOL)isGMT{
    NSString *returnStr;//返回字符串
    NSTimeInterval timeNum=0.0;//本地的
    
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
                [formatter setDateFormat:@"yyyy/MM/dd"];
                //设置时区 NSDataFormatter默认输出格林威治时间，要输出本地时间要设置时区 ，跟北京时间差8小时
                [formatter setTimeZone:isGMT?[NSTimeZone timeZoneWithName:@"GMT"]:[NSTimeZone localTimeZone]];
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
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            //设置时区 NSDataFormatter默认输出格林威治时间，要输出本地时间要设置时区 ，跟北京时间差8小时
            [formatter setTimeZone:isGMT?[NSTimeZone timeZoneWithName:@"GMT"]:[NSTimeZone localTimeZone]];
            NSDate *theDate =  [formatter dateFromString:timeStr];
            timeNum = [theDate timeIntervalSince1970];
        }
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //设置时区 NSDataFormatter默认输出格林威治时间，要输出本地时间要设置时区 ，跟北京时间差8小时
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    //要处理的date
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:timeNum];
    //当前用户的calendar
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay| NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond  fromDate:lastDate];
    [components setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDateComponents * nowComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay| NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond  fromDate:[NSDate date]];
    [components setTimeZone:[NSTimeZone localTimeZone]];
    if (nowComponents.year!=components.year) {
        //不是同一年
        [formatter setDateFormat:@"yyyy-MM-dd"];
        returnStr = [formatter stringFromDate:lastDate];
    }else if (nowComponents.year==components.year) {
        if ([[NSCalendar currentCalendar] isDateInToday:lastDate]) {
            //今天  02:20
            [formatter setDateFormat:@"HH:mm"];
            returnStr = [formatter stringFromDate:lastDate];
        }else if ([[NSCalendar currentCalendar] isDateInYesterday:lastDate]){
            //昨天 16:40
            [formatter setDateFormat:@"HH:mm"];

            returnStr = [NSString stringWithFormat:@"%@ %@",[NSBundle fan_localizedStringForKey:@"FanKit_yesterday" value:@"昨天"],[formatter stringFromDate:lastDate]];
        }else{
            [formatter setDateFormat:@"yyyy-MM-dd"];
            returnStr = [formatter stringFromDate:lastDate];
        }
    }else{
        returnStr = [formatter stringFromDate:lastDate];
    }
    return returnStr;
}

+(NSDateComponents *)fan_componentsFromTimeStamp:(NSTimeInterval)timeStamp{
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSCalendar *calendar = [NSCalendar currentCalendar];//当前用户的calendar
    NSDateComponents * components = [calendar components:NSCalendarUnitYear | NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitDay fromDate:detaildate];
    [components setTimeZone:[NSTimeZone localTimeZone]];
    return components;
}

+ (NSTimeInterval)fan_getRealTimeIntervalWith:(id)timeObj isGMT:(BOOL)isGMT{
    NSTimeInterval timeNum=0.0;//本地的
    if([timeObj isKindOfClass:[NSDate class]])
    {
        NSDate *timeDate = (NSDate *)timeObj;
        timeNum = [timeDate timeIntervalSince1970];
    }else if([timeObj isKindOfClass:[NSNumber class]]){
        timeNum = [timeObj doubleValue];
    }else if ([timeObj isKindOfClass:[NSString class]]){
        NSString *timeStr = (NSString *)timeObj;
        if(timeStr.length == 17){
            timeNum = [timeStr doubleValue];
        }else if(timeStr.length == 5){
            //解析不出来
        }else if (timeStr.length == 10){
            NSRange range = [timeStr rangeOfString:@"/"];
            if(range.length){
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy/MM/dd"];
                //设置时区 NSDataFormatter默认输出格林威治时间，要输出本地时间要设置时区 ，跟北京时间差8小时
                [formatter setTimeZone:isGMT?[NSTimeZone timeZoneWithName:@"GMT"]:[NSTimeZone localTimeZone]];
                NSDate *theDate =  [formatter dateFromString:timeStr];
                timeNum = [theDate timeIntervalSince1970];
            }else{
                timeNum = [timeStr doubleValue];
            }
        }else {
            NSString *Regex = @"^[\u4e00-\u9fa5]{0,}$";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
            if ([predicate evaluateWithObject:timeStr]){
                //中文日期
            }else{
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                //设置时区 NSDataFormatter默认输出格林威治时间，要输出本地时间要设置时区 ，跟北京时间差8小时
                [formatter setTimeZone:isGMT?[NSTimeZone timeZoneWithName:@"GMT"]:[NSTimeZone localTimeZone]];
                NSDate *theDate =  [formatter dateFromString:timeStr];
                timeNum = [theDate timeIntervalSince1970];
            }
        }
    }
    return timeNum;
}
+(NSString *)fan_stringFormatWithTimeStamp:(NSTimeInterval)timeStamp{
    NSString *returnStr=@"";
    //需要输出的时间Format后面会修改
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //设置时区 NSDataFormatter默认输出格林威治时间，要输出本地时间要设置时区 ，跟北京时间差8小时
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    //要处理的date
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    //当前用户的calendar
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay| NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond  fromDate:lastDate];
    [components setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDateComponents * nowComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay| NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond  fromDate:[NSDate date]];
    [components setTimeZone:[NSTimeZone localTimeZone]];
    if (nowComponents.year!=components.year) {
        //不是同一年
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        returnStr = [formatter stringFromDate:lastDate];
    }else if (nowComponents.year==components.year) {
        if ([[NSCalendar currentCalendar] isDateInToday:lastDate]) {
            //今天  02:20
            [formatter setDateFormat:@"HH:mm"];
            returnStr = [formatter stringFromDate:lastDate];
        }else if ([[NSCalendar currentCalendar] isDateInYesterday:lastDate]){
            //昨天 16:40
            [formatter setDateFormat:@"HH:mm"];

            returnStr = [NSString stringWithFormat:@"%@ %@",[NSBundle fan_localizedStringForKey:@"FanKit_yesterday" value:@"昨天"],[formatter stringFromDate:lastDate]];
        }else{
            [formatter setDateFormat:@"MM-dd HH:mm"];
            returnStr = [formatter stringFromDate:lastDate];
        }
    }else{
        returnStr = [formatter stringFromDate:lastDate];
    }
    return returnStr;
}
@end
