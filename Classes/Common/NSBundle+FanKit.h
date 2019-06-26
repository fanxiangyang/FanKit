//
//  NSBundle+FanKit.h
//  FanKit
//
//  Created by 向阳凡 on 2018/10/13.
//  Copyright © 2018 凡向阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (FanKit)

///这个是只作用在FanKit.bundle资源文件，用于FanKit框架使用
+ (instancetype)fan_bundle;

+ (NSString *)fan_localizedStringForKey:(NSString *)key value:(nullable NSString *)value;

+ (NSString *)fan_localizedStringForKey:(NSString *)key;

//获取资源图片，图片全路径
+ (UIImage *)fan_bundleImageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
