//
//  UIStackView+FanCategory.h
//  FanKit
//
//  Created by 向阳凡 on 2024/03/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIStackView (FanCategory)
/// 获取水平方向等间距的StackView 默认居中
/// - Parameter spacing: 间距
+(instancetype)fan_stackViewHorizontalSpacing:(CGFloat)spacing;
/// 获取重置方向等间距的StackView 默认居中
/// - Parameter spacing: 间距
+(instancetype)fan_stackViewVerticalSpacing:(CGFloat)spacing;


@end

NS_ASSUME_NONNULL_END
