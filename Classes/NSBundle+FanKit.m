//
//  NSBundle+FanKit.m
//  FanKit
//
//  Created by 向阳凡 on 2018/10/13.
//  Copyright © 2018 凡向阳. All rights reserved.
//

#import "NSBundle+FanKit.h"

@implementation NSBundle (FanKit)
+ (instancetype)fan_bundle
{
    static NSBundle *fankitBundle = nil;
    if (fankitBundle == nil) {
        fankitBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"FanKit" ofType:@"bundle"]];
    }
    return fankitBundle;
}
+(UIImage *)fan_bundleImageName:(NSString *)imageName{
    UIImage *fImage = [UIImage imageWithContentsOfFile:[[self fan_bundle] pathForResource:[imageName stringByDeletingPathExtension] ofType:[imageName pathExtension]]];
    return fImage;
}
+ (NSString *)fan_localizedStringForKey:(NSString *)key
{
    return [self fan_localizedStringForKey:key value:nil];
}

+ (NSString *)fan_localizedStringForKey:(NSString *)key value:(nullable NSString *)value
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans"; // 简体中文
            } else { // zh-Hant\zh-HK\zh-TW
                language = @"zh-Hant"; // 繁體中文
            }
        } else {
            language = @"en";
        }
        
        // 从FanKit.bundle中查找资源
        bundle = [NSBundle bundleWithPath:[[NSBundle fan_bundle] pathForResource:language ofType:@"lproj"]];
    }
    //先从自己配置文件中找，然后去主项目配置文件找，找不到就被自己fankit.bundle覆盖了
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}

@end
