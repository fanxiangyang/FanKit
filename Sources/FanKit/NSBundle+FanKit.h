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

/** 获取资源图片，图片全路径login@2x.png*/
+(UIImage *)fan_bundleImageFileName:(NSString *)imageName;
/** 获取资源图片，只是图片名(没有后缀)，自动适配@2x,@3x*/
+(UIImage *)fan_bundleImageName:(NSString *)imageName;
/** 获取资源图片，只是图片名和扩展，自动适配@2x,@3x*/
+(UIImage *)fan_bundleImageName:(NSString *)imageName extName:(NSString *)extName;

@end

NS_ASSUME_NONNULL_END
