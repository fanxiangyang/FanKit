//
//  FanDrawLayer.h
//  FanTest
//
//  Created by 向阳凡 on 2018/6/26.
//  Copyright © 2018年 向阳凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FanDrawLayer : NSObject
/**
 画椭圆线
 
 @param frame frame
 @param lineWidth 线宽
 @param lineColor 线颜色
 @return layer
 */
+(CAShapeLayer *)fan_ovalInRect:(CGRect)frame lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor;
/**
 画直线段
 
 @param startPoint 开始点
 @param toPoint 结束点
 @param lineWidth 线宽
 @param lineColor 线颜色
 @return 虚线段
 */
+(CAShapeLayer *)fan_lineStartPoint:(CGPoint)startPoint toPoint:(CGPoint)toPoint lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor;
/**
 画虚线段

 @param startPoint 开始点
 @param toPoint 结束点
 @param lineWidth 线宽
 @param lineColor 线颜色
 @param lineSpace 虚线间距
 @return 虚线段
 */
+(CAShapeLayer *)fan_dottedLineStartPoint:(CGPoint)startPoint toPoint:(CGPoint)toPoint lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor lineSpace:(CGFloat)lineSpace;
/**
 画虚线框

 @param lineWidth 线宽
 @param lineColor 线的颜色
 @param cornerRadius 圆角半径
 @param frame 虚线区域
 @param lineSpace 虚线间距
 @return layre
 */
+(CAShapeLayer *)fan_dottedLineFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor cornerRadius:(CGFloat)cornerRadius lineSpace:(CGFloat)lineSpace;
/**
 获取圆环进度
 如果需要渐变色，可以用gradientLayer.mask=CAShapeLayer
 
 @param progress 进度0-1
 @param rightWidth 圆环宽度
 @param ringColor 圆环颜色
 @param center 圆心坐标
 @param radius 最大圆半径
 @param startAngle 进度的开始坐标
 @return layer
 */
+(CAShapeLayer *)fan_ringProgress:(CGFloat)progress ringWidth:(CGFloat)rightWidth ringColor:(UIColor *)ringColor Center:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle;
/// 获取圆环进度Layer
/// @param progress 总进度
/// @param rightWidth 圆环宽度
/// @param ringColor 圆环颜色
/// @param center 中心点
/// @param radius 半径
/// @param startAngle 开始角度
/// @param clockwise 顺时针
+(CAShapeLayer *)fan_ringProgress:(CGFloat)progress ringWidth:(CGFloat)rightWidth ringColor:(UIColor *)ringColor Center:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle clockwise:(BOOL)clockwise;
/**
 获取渐变色Layer就两种（水平和垂直）
 
 @param frame 渐变区域
 @param startColor 开始颜色
 @param endColor 结束颜色
 @param isVertical 是垂直吗
 @return 渐变Layer
 */
+(CAGradientLayer*)fan_gradientLayerFrame:(CGRect)frame startColor:(UIColor *)startColor endColor:(UIColor *)endColor isVertical:(BOOL)isVertical;
///自定义渐变区域
+(CAGradientLayer*)fan_gradientLayerFrame:(CGRect)frame startColor:(UIColor *)startColor endColor:(UIColor *)endColor isVertical:(BOOL)isVertical locations:(NSArray *)locations;
///含圆角
+(CAGradientLayer*)fan_gradientLayerFrame:(CGRect)frame startColor:(UIColor *)startColor endColor:(UIColor *)endColor cornerRadius:(CGFloat)cornerRadius isVertical:(BOOL)isVertical locations:(NSArray *)locations;
///生成多颜色渐变色和区域
+(CAGradientLayer*)fan_gradientLayerFrame:(CGRect)frame colors:(NSArray<UIColor *>*)colors cornerRadius:(CGFloat)cornerRadius isVertical:(BOOL)isVertical locations:(NSArray *)locations;
/**
 生成渐变遮罩边框

 @param frame 边框frame
 @param lineWidth 线宽
 @param startColor 开始颜色
 @param endColor 结束颜色
 @param cornerRadius 半径
 @param isVertical 是否垂直
 @param locations 渐变坐标点
 @return 渐变边框
 */
+(CAGradientLayer *)fan_gradientMaskLayerFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth startColor:(UIColor *)startColor endColor:(UIColor *)endColor cornerRadius:(CGFloat)cornerRadius isVertical:(BOOL)isVertical locations:(NSArray *)locations;
///生成多颜色渐变边框
+(CAGradientLayer *)fan_gradientMaskLayerFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth colors:(NSArray<UIColor *>*)colors cornerRadius:(CGFloat)cornerRadius isVertical:(BOOL)isVertical locations:(NSArray *)locations;
/**
 生成三角形

 @param fillColor 填充颜色
 @param topPoint 顶点
 @param leftPoint 左边点
 @param rightPoint 右边点
 @return 三角形layer
 */
+(CAShapeLayer *)fan_triangleFillColor:(UIColor *)fillColor topPoint:(CGPoint)topPoint leftPoint:(CGPoint)leftPoint rightPoint:(CGPoint)rightPoint;

/**
 设置自定义圆角View

 @param bounds View 尺寸
 @param roundingCorners 圆角方向
 @param cornerRadius 圆角半径
 @return maskLayer
 */
+(CAShapeLayer *)fan_roundingView:(CGRect)bounds byRoundingCorners:(UIRectCorner)roundingCorners  cornerRadius:(CGFloat)cornerRadius;

/**
 箭头弹窗的遮罩

 @param frame frame
 @param arrowHeight 箭头高度，底部箭头
 @param arrowOffsetX 箭头x坐标便宜量
 @param radius 圆角半径
 @return 遮罩
 */
+(CAShapeLayer *)fan_arrowPopupMaskFrame:(CGRect)frame arrowHeight:(CGFloat)arrowHeight arrowOffsetX:(CGFloat)arrowOffsetX cornerRadius:(CGFloat)radius;

/**
 箭头弹窗的边框
 
 @param frame frame
 @param arrowHeight 箭头高度，底部箭头
 @param arrowOffsetX 箭头x坐标便宜量
 @param radius 圆角半径
 @param lineWidth 线宽
 @param lineColor 线颜色
 @param fillColor 填充颜色
 @return 箭头气泡弹窗
 */
+(CAShapeLayer *)fan_arrowPopupFrame:(CGRect)frame arrowHeight:(CGFloat)arrowHeight arrowOffsetX:(CGFloat)arrowOffsetX cornerRadius:(CGFloat)radius lineWith:(CGFloat)lineWidth lineColor:(UIColor *)lineColor fillColor:(UIColor*)fillColor;
/**
 左右尖角的矩形<___>遮罩
 
 @param frame frame
 @param arrowWidth 尖角宽度
 @return layer
 */
+(CAShapeLayer *)fan_arrowPopupleftRightMaskFrame:(CGRect)frame arrowWidth:(CGFloat)arrowWidth;
/// 矩形镂空，圆形镂空
/// @param cutoutView 镂空view
/// @param frame 镂空尺寸
/// @param roundingCorners 圆角
/// @param cornerRadius 圆角半径
+(CAShapeLayer *)fan_roundCutoutView:(UIView *)cutoutView cutoutFrame:(CGRect)frame byRoundingCorners:(UIRectCorner)roundingCorners cornerRadius:(CGFloat)cornerRadius;
@end
