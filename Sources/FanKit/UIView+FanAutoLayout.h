//
//  UIView+FanAutoLayout.h
//  FanYou360
//
//  Created by 向阳凡 on 15/10/17.
//  Copyright © 2015年 向阳凡. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  靠边约束的类型
 */
typedef NS_ENUM(NSInteger, FanLayoutAttribute){
    //有一端长度固定
    /**
     *  靠上（左右缩放）约束
     */
    FanLayoutAttributeTop=1,
    /**
     *  靠左（上下缩放）约束
     */
    FanLayoutAttributeLeft,
    /**
     *  靠下（左右缩放）约束
     */
    FanLayoutAttributeBottom,
    /**
     *  靠右（上下缩放）约束
     */
    FanLayoutAttributeRight,
    
    //宽高固定
    /**
     *  上左（宽高固定）约束
     */
    FanLayoutAttributeTopLeft,
    /**
     *  上右（宽高固定）约束
     */
    FanLayoutAttributeTopRight,
    /**
     *  下左（宽高固定）约束
     */
    FanLayoutAttributeBottomLeft,
    /**
     *  下右（宽高固定）约束
     */
    FanLayoutAttributeBottomRight,
    
    
    //宽高都不固定
    /**
     *  上左下右约束
     */
    FanLayoutAttributeAll
};
/**
 *  中心约束（宽高固定）
 */
typedef NS_ENUM(NSInteger, FanLayoutCenter){
    /**
     *  水平居中Top靠齐
     */
    FanLayoutCenterXTop=1,
    /**
     *  水平居中底部靠齐
     */
    FanLayoutCenterXBottom,
    /**
     *  上下居中左靠齐
     */
    FanLayoutCenterYLeft,
    /**
     *  上下居中右靠齐
     */
    FanLayoutCenterYRight,
    /**
     *  中心坐标居中
     */
    FanLayoutCenterAll
};
/**
 *  宽高比固定靠边约束
 */
typedef NS_ENUM(NSInteger, FanLayoutAspectRatio){
    /**
     *  靠上的宽高比约束
     */
    FanLayoutAspectRatioTop,
    /**
     *  靠下的宽高比约束
     */
    FanLayoutAspectRatioBottom,
    /**
     *  靠左的宽高比约束
     */
    FanLayoutAspectRatioLeft,
    /**
     *  靠右的宽高比约束
     */
    FanLayoutAspectRatioRight
};
@interface UIView (FanAutoLayout)
/**
 *  移除该View的所有约束
 */
- (void)fan_removeAllAutoLayout;
/**
 *  给子控件添加中心约束
 *
 *  @param centerView 约束控件
 *  @param size       控件宽度
 */
-(void)fan_addConstraintsCenter:(id)centerView viewSize:(CGSize)size;
/**
 *  宽高固定的Center X ,Y约束
 *
 *  @param centerView   约束控件
 *  @param size         控件大小
 *  @param layoutCenter 中心类型
 *  @param padding      间距
 */
-(void)fan_addConstraintsCenter:(id)centerView viewSize:(CGSize)size layoutCenter:(FanLayoutCenter)layoutCenter padding:(CGFloat)padding;
/**
 *  添加（子控件） 1=单方向三边，2=双边（宽高固定），3=全边（缩放）约束
 *
 *  @param constraintView  约束控件
 *  @param edgeInsets      上左下右间距
 *  @param layoutAttribute 约束类型
 *  @param size            控件大小
 */
-(void)fan_addConstraints:(id)constraintView edgeInsets:(UIEdgeInsets)edgeInsets  layoutType:(FanLayoutAttribute)layoutAttribute viewSize:(CGSize)size;
/**
 *  宽高比固定的靠边约束【宽高比<Width/Height>】
 *
 *  @param constraintView    约束控件
 *  @param edgeInsets        间距
 *  @param layoutAspectRatio 靠边类型
 *  @param ratio             宽高比<Width/Height>
 */
-(void)fan_addConstraintsAspectRatio:(id)constraintView edgeInsets:(UIEdgeInsets)edgeInsets  layoutType:(FanLayoutAspectRatio)layoutAspectRatio aspectRatio:(CGFloat)ratio;
/**
 *  带一个View依靠的全方向缩放
 *
 *  @param constraintView  约束控件
 *  @param dependView      依靠控件
 *  @param edgeInsets      间距
 *  @param layoutAttribute 类型（只能是FanLayoutAttributeTop，Bottom,Left,Right）
 */
-(void)fan_addConstraintsAll:(id)constraintView dependView:(id)dependView edgeInsets:(UIEdgeInsets)edgeInsets  layoutType:(FanLayoutAttribute)layoutAttribute;
/**
 *  有一个依靠控件的一端固定的约束
 *
 *  @param constraintView  约束控件
 *  @param dependView      依靠控件
 *  @param edgeInsets      间距
 *  @param layoutAttribute 类型（只能是FanLayoutAttributeTop，Bottom,Left,Right）
 *  @param size            控件大小
 */
-(void)fan_addConstraintsOne:(id)constraintView dependView:(id)dependView edgeInsets:(UIEdgeInsets)edgeInsets  layoutType:(FanLayoutAttribute)layoutAttribute viewSize:(CGSize)size;

#pragma mark - VFL格式话约束+居中约束
// @"H:|-20-[V1(50)]-20-[V2(==V1)]-20-[V3(==V1)]";
/// 添加多view约束Format方式(参数必须是 V1,V2,....)
/// @param views 多个view
/// @param formatH 水平format
/// @param formatV 垂直format
/// @param formatOptions 可选参数 默认 0
-(void)fan_addConstraintsFormatViews:(NSArray *)views formatH:(NSString *)formatH formatV:(NSString *)formatV formatOptions:(NSLayoutFormatOptions)formatOptions;
/// 添加单view约束Format方式(format里面必须是view)
/// @param view 需要约束的view
/// @param formatH 水平format
/// @param formatV 垂直format
/// @param formatOptions 可选参数 默认 0
-(void)fan_addConstraintsFormat:(id)view formatH:(NSString *)formatH formatV:(NSString *)formatV formatOptions:(NSLayoutFormatOptions)formatOptions;
/// 添加中心约束XY
/// @param centerView 需要居中的view
/// @param centerX X偏移量
/// @param centerY Y偏移量
-(void)fan_addConstraintsCenterXY:(id)centerView centerX:(CGFloat)centerX centerY:(CGFloat)centerY;
/// 添加中心约束centerX
/// @param centerView 需要居中的View
/// @param centerX X偏移量
/// @param multiplier 距离中心百分比 默认中心1.0
-(void)fan_addConstraintsCenterX:(id)centerView centerX:(CGFloat)centerX multiplier:(CGFloat)multiplier;
/// 添加中心约束centerY
/// @param centerView 需要居中的View
/// @param centerY Y偏移量
/// @param multiplier 距离中心百分比 默认中心1.0
-(void)fan_addConstraintsCenterY:(id)centerView centerY:(CGFloat)centerY multiplier:(CGFloat)multiplier;
/// 添加宽高固定的View
/// @param view 宽高固定view
/// @param size view尺寸
-(void)fan_addConstraintsWidthHeightView:(id)view viewSize:(CGSize)size;
/// 自己一边依赖另外一个view的边
/// @param constraintView 自己View
/// @param dependView 依赖view
/// @param attribute NSLayoutAttribute
/// @param dependAttribute 依赖的
/// @param space 间距
-(void)fan_addConstraintsDepend:(id)constraintView dependView:(id)dependView attribute:(NSLayoutAttribute)attribute dependAttribute:(NSLayoutAttribute)dependAttribute space:(CGFloat)space;
/// 自己一边依赖另外一个view的边,也可以是自己和自己宽高比
/// @param constraintView 自己View
/// @param dependView 依赖view
/// @param attribute NSLayoutAttribute
/// @param dependAttribute 依赖的
/// @param space 间距
/// @param multiplier 默认1.0  宽高比
-(void)fan_addConstraintsDepend:(id)constraintView dependView:(id)dependView attribute:(NSLayoutAttribute)attribute dependAttribute:(NSLayoutAttribute)dependAttribute space:(CGFloat)space multiplier:(CGFloat)multiplier;
/// 添加在父类安全区域的一边约束
/// @param constraintView 需要约束的控件
/// @param attribute 需要约束的方位
/// @param safeAttribute 依赖的方位
/// @param space 间距
-(void)fan_addSafeAreaConstraintsView:(id)constraintView attribute:(NSLayoutAttribute)attribute safeAttribute:(NSLayoutAttribute)safeAttribute space:(CGFloat)space;
@end
