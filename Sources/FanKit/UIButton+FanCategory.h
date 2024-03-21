//
//  UIButton+FanCategory.h
//  FanKit
//
//  Created by 凡向阳 on 2024/03/15.
//  Copyright © 2024 向阳凡. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FanButtonEdgeStyle) {
    FanButtonEdgeStyleTop, // image在上，label在下
    FanButtonEdgeStyleLeft, // image在左，label在右
    FanButtonEdgeStyleBottom, // image在下，label在上
    FanButtonEdgeStyleRight // image在右，label在左
};

@interface UIButton (FanCategory)

//MARK: - 新的按钮创建方式

/// 创建只有文本的按钮+内间距 （文本只支持单行和多行，不支持固定2行）
+(instancetype)fan_btnTitle:(NSString *)title textColor:(UIColor *)textColor font:(UIFont*)font edge:(UIEdgeInsets)edge;
/// 创建只有图片的按钮+内间距
+(instancetype)fan_btnImageName:(NSString *)imageName edge:(UIEdgeInsets)edge;
///适配iOS15 UIButtonConfiguration设置字体颜色和大小
-(void)fan_setTextColor:(UIColor *)textColor font:(UIFont*)font;
///设置内边距，支持iOS15的方法
-(void)fan_setMargins:(UIEdgeInsets)margins;
///设置图片与文本间距(支持旧的左图右文结构，与iOS15之后的UIButtonConfiguration)
-(void)fan_setImagePadding:(CGFloat)imagePadding;
///设置图片与文本间距(支持旧的图文结构，与iOS15之后的UIButtonConfiguration)
-(void)fan_setImagePadding:(CGFloat)imagePadding postion:(FanButtonEdgeStyle)postion;

@end

NS_ASSUME_NONNULL_END
