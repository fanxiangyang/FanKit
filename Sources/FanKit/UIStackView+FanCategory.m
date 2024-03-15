//
//  UIStackView+FanCategory.h
//  FanKit
//
//  Created by 向阳凡 on 2024/03/15.
//

#import "UIStackView+FanCategory.h"

@implementation UIStackView (FanCategory)


/// 获取水平方向等间距的StackView 默认居中
/// - Parameter spacing: 间距
+(instancetype)fan_stackViewHorizontalSpacing:(CGFloat)spacing{
    UIStackView *rStackView = [[UIStackView alloc]init];
    rStackView.axis = UILayoutConstraintAxisHorizontal;
    rStackView.distribution = UIStackViewDistributionFill;
    rStackView.alignment = UIStackViewAlignmentCenter;
    rStackView.backgroundColor = [UIColor clearColor];
    rStackView.spacing = spacing;
    return rStackView;
}
/// 获取重置方向等间距的StackView 默认居中
/// - Parameter spacing: 间距
+(instancetype)fan_stackViewVerticalSpacing:(CGFloat)spacing{
    UIStackView *rStackView = [[UIStackView alloc]init];
    rStackView.axis = UILayoutConstraintAxisVertical;
    rStackView.distribution = UIStackViewDistributionFill;
    rStackView.alignment = UIStackViewAlignmentCenter;
    rStackView.backgroundColor = [UIColor clearColor];
    rStackView.spacing = spacing;
    return rStackView;
}
@end
