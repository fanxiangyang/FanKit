//
//  FanDrawLayer.m
//  FanTest
//
//  Created by 向阳凡 on 2018/6/26.
//  Copyright © 2018年 向阳凡. All rights reserved.
//

#import "FanDrawLayer.h"

@implementation FanDrawLayer
+(CAShapeLayer *)fan_ovalInRect:(CGRect)frame lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor{
    CAShapeLayer *layer=[[CAShapeLayer alloc]init];
    layer.lineWidth=lineWidth;
    layer.lineCap = kCALineCapRound;
    layer.strokeColor=lineColor.CGColor;
    layer.fillColor=[UIColor clearColor].CGColor;
    UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:frame];
    layer.path=[path CGPath];
    return layer;
}
+(CAShapeLayer *)fan_lineStartPoint:(CGPoint)startPoint toPoint:(CGPoint)toPoint lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor{
    CAShapeLayer *layer=[[CAShapeLayer alloc]init];
    layer.lineWidth=lineWidth;
    layer.lineCap = kCALineCapRound;
    layer.strokeColor=lineColor.CGColor;
    layer.fillColor=[UIColor clearColor].CGColor;
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:toPoint];
    layer.path=[path CGPath];
    return layer;
}
+(CAShapeLayer *)fan_dottedLineStartPoint:(CGPoint)startPoint toPoint:(CGPoint)toPoint lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor lineSpace:(CGFloat)lineSpace{
    CAShapeLayer *layer=[[CAShapeLayer alloc]init];
    layer.lineWidth=lineWidth;
    layer.lineCap = kCALineCapRound;
    layer.strokeColor=lineColor.CGColor;
    layer.fillColor=[UIColor clearColor].CGColor;
    layer.lineDashPattern=@[@(lineWidth),@(lineSpace)];
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:toPoint];
    layer.path=[path CGPath];
    return layer;
}
+(CAShapeLayer *)fan_dottedLineFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor  cornerRadius:(CGFloat)cornerRadius lineSpace:(CGFloat)lineSpace{
    CAShapeLayer *layer=[[CAShapeLayer alloc]init];
    layer.lineWidth=lineWidth;
    layer.lineCap = kCALineCapRound;
    layer.strokeColor=lineColor.CGColor;
    layer.fillColor=[UIColor clearColor].CGColor;
    layer.lineDashPattern=@[@(lineWidth),@(lineSpace)];
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:cornerRadius];
    layer.path=[path CGPath];
    return layer;
}
+(CAShapeLayer *)fan_ringProgress:(CGFloat)progress ringWidth:(CGFloat)rightWidth ringColor:(UIColor *)ringColor Center:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle{
    CAShapeLayer *layer=[[CAShapeLayer alloc]init];
    layer.name=@"FanRingLayer";
    layer.lineWidth=rightWidth;
    layer.strokeColor=ringColor.CGColor;
    layer.fillColor=[UIColor clearColor].CGColor;
    layer.lineCap = kCALineCapRound;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:startAngle+progress*2*M_PI clockwise:YES];
    layer.path=[path CGPath];

    return layer;
}
/// 获取圆环进度Layer
/// @param progress 总进度
/// @param rightWidth 圆环宽度
/// @param ringColor 圆环颜色
/// @param center 中心点
/// @param radius 半径
/// @param startAngle 开始角度
/// @param clockwise 顺时针
+(CAShapeLayer *)fan_ringProgress:(CGFloat)progress ringWidth:(CGFloat)rightWidth ringColor:(UIColor *)ringColor Center:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle clockwise:(BOOL)clockwise{
    CAShapeLayer *layer=[[CAShapeLayer alloc]init];
    layer.lineWidth=rightWidth;
    layer.strokeColor=ringColor.CGColor;
    layer.fillColor=[UIColor clearColor].CGColor;
    layer.lineCap = kCALineCapRound;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:startAngle+progress*2*M_PI clockwise:clockwise];
    layer.path=[path CGPath];
    return layer;
}
+(CAGradientLayer*)fan_gradientLayerFrame:(CGRect)frame startColor:(UIColor *)startColor endColor:(UIColor *)endColor isVertical:(BOOL)isVertical{
    return [FanDrawLayer fan_gradientLayerFrame:frame colors:@[startColor,endColor] cornerRadius:0 isVertical:isVertical locations:@[@(0.1), @1.0]];
}
+(CAGradientLayer*)fan_gradientLayerFrame:(CGRect)frame startColor:(UIColor *)startColor endColor:(UIColor *)endColor isVertical:(BOOL)isVertical locations:(NSArray *)locations{
    return [FanDrawLayer fan_gradientLayerFrame:frame colors:@[startColor,endColor] cornerRadius:0 isVertical:isVertical locations:locations];
}
+(CAGradientLayer*)fan_gradientLayerFrame:(CGRect)frame startColor:(UIColor *)startColor endColor:(UIColor *)endColor cornerRadius:(CGFloat)cornerRadius isVertical:(BOOL)isVertical locations:(NSArray *)locations{
    return [FanDrawLayer fan_gradientLayerFrame:frame colors:@[startColor,endColor] cornerRadius:cornerRadius isVertical:isVertical locations:locations];
}
///生成多颜色渐变色和区域
+(CAGradientLayer*)fan_gradientLayerFrame:(CGRect)frame colors:(NSArray<UIColor *>*)colors cornerRadius:(CGFloat)cornerRadius isVertical:(BOOL)isVertical locations:(NSArray *)locations{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    NSMutableArray *cls=[[NSMutableArray alloc]init];
    for (UIColor *c in colors) {
        [cls addObject:(__bridge id)c.CGColor];
    }
    gradientLayer.colors = cls;
    gradientLayer.locations = locations;
    if (cornerRadius>0.0) {
        gradientLayer.cornerRadius=cornerRadius;
    }
    gradientLayer.startPoint = CGPointMake(0, 0);
    if (isVertical) {
        gradientLayer.endPoint = CGPointMake(0, 1.0);
    }else{
        gradientLayer.endPoint = CGPointMake(1.0, 0);
    }
    gradientLayer.frame =frame;
    
    return gradientLayer;
}
+(CAGradientLayer *)fan_gradientMaskLayerFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth startColor:(UIColor *)startColor endColor:(UIColor *)endColor cornerRadius:(CGFloat)cornerRadius isVertical:(BOOL)isVertical locations:(NSArray *)locations{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:cornerRadius];
    CAShapeLayer * boardLayer = [CAShapeLayer layer];
    boardLayer.frame = frame;
    boardLayer.fillColor =  [[UIColor clearColor] CGColor];
    //指定path的渲染颜色
    boardLayer.strokeColor  =[UIColor whiteColor].CGColor;
    boardLayer.lineCap = kCALineCapRound;
    boardLayer.lineWidth = lineWidth;
    boardLayer.path = [path CGPath];
  
    CAGradientLayer *gLayer = [FanDrawLayer fan_gradientLayerFrame:frame startColor:startColor endColor:endColor cornerRadius:cornerRadius isVertical:isVertical locations:locations];
    [gLayer setMask:boardLayer];
    return gLayer;
}
///生成多颜色渐变边框
+(CAGradientLayer *)fan_gradientMaskLayerFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth colors:(NSArray<UIColor *>*)colors cornerRadius:(CGFloat)cornerRadius isVertical:(BOOL)isVertical locations:(NSArray *)locations{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:cornerRadius];
    CAShapeLayer * boardLayer = [CAShapeLayer layer];
    boardLayer.frame = frame;
    boardLayer.fillColor =  [[UIColor clearColor] CGColor];
    //指定path的渲染颜色
    boardLayer.strokeColor  =[UIColor whiteColor].CGColor;
    boardLayer.lineCap = kCALineCapRound;
    boardLayer.lineWidth = lineWidth;
    boardLayer.path = [path CGPath];
  
    CAGradientLayer *gLayer = [FanDrawLayer fan_gradientLayerFrame:frame colors:(NSArray<UIColor *>*)colors cornerRadius:cornerRadius isVertical:isVertical locations:locations];
    [gLayer setMask:boardLayer];
    return gLayer;
}
+(CAShapeLayer *)fan_triangleFillColor:(UIColor *)fillColor topPoint:(CGPoint)topPoint leftPoint:(CGPoint)leftPoint rightPoint:(CGPoint)rightPoint {
    CAShapeLayer *layer=[[CAShapeLayer alloc]init];
    //    layer.strokeColor=lineColor.CGColor;
    layer.fillColor=fillColor.CGColor;
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:topPoint];
    [path addLineToPoint:leftPoint];
    [path addLineToPoint:rightPoint];
    layer.path=[path CGPath];
    return layer;
}
+(CAShapeLayer *)fan_roundingView:(CGRect)bounds byRoundingCorners:(UIRectCorner)roundingCorners cornerRadius:(CGFloat)cornerRadius{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, bounds.size.width, bounds.size.height) byRoundingCorners:roundingCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
}
+(CAShapeLayer *)fan_arrowPopupMaskFrame:(CGRect)frame arrowHeight:(CGFloat)arrowHeight arrowOffsetX:(CGFloat)arrowOffsetX cornerRadius:(CGFloat)radius{
    CAShapeLayer *layer=[[CAShapeLayer alloc]init];
    layer.frame=frame;
    UIBezierPath* path = [UIBezierPath bezierPath];
    //从左边第一个圆角开始
    [path addArcWithCenter:CGPointMake(frame.origin.x+radius, frame.origin.y+radius) radius:radius startAngle:M_PI endAngle:M_PI*1.5 clockwise:YES];
    [path addLineToPoint:CGPointMake(frame.origin.x+frame.size.width-radius, frame.origin.y)];
    [path addArcWithCenter:CGPointMake(frame.origin.x+frame.size.width-radius, frame.origin.y+radius) radius:radius startAngle:M_PI*1.5 endAngle:M_PI*2 clockwise:YES];
    
    [path addLineToPoint:CGPointMake(frame.origin.x+frame.size.width, frame.origin.y+frame.size.height-2*radius-arrowHeight)];
    [path addArcWithCenter:CGPointMake(frame.origin.x+frame.size.width-radius, frame.origin.y+frame.size.height-radius-arrowHeight) radius:radius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(frame.origin.x+arrowOffsetX+arrowHeight, frame.origin.y+frame.size.height-arrowHeight)];
    //箭头线
    [path addLineToPoint:CGPointMake(frame.origin.x+arrowOffsetX, frame.origin.y+frame.size.height)];
    [path addLineToPoint:CGPointMake(frame.origin.x+arrowOffsetX-arrowHeight, frame.origin.y+frame.size.height-arrowHeight)];
    
    
    [path addLineToPoint:CGPointMake(frame.origin.x+radius, frame.origin.y+frame.size.height-arrowHeight)];
    
    [path addArcWithCenter:CGPointMake(frame.origin.x+radius, frame.origin.y+frame.size.height-radius-arrowHeight) radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(frame.origin.x, frame.origin.y+radius)];
    //    [path closePath];
    layer.path=[path CGPath];
    return layer;
}
+(CAShapeLayer *)fan_arrowPopupFrame:(CGRect)frame arrowHeight:(CGFloat)arrowHeight arrowOffsetX:(CGFloat)arrowOffsetX cornerRadius:(CGFloat)radius lineWith:(CGFloat)lineWidth lineColor:(UIColor *)lineColor fillColor:(UIColor*)fillColor{
    CAShapeLayer *layer=[[CAShapeLayer alloc]init];
    //    layer.frame=frame;
    layer.lineWidth=lineWidth;
    layer.strokeColor=lineColor.CGColor;
    layer.fillColor=fillColor.CGColor;
    UIBezierPath* path = [UIBezierPath bezierPath];
    //从左边第一个圆角开始
    [path addArcWithCenter:CGPointMake(frame.origin.x+radius, frame.origin.y+radius) radius:radius startAngle:M_PI endAngle:M_PI*1.5 clockwise:YES];
    [path addLineToPoint:CGPointMake(frame.origin.x+frame.size.width-radius, frame.origin.y)];
    [path addArcWithCenter:CGPointMake(frame.origin.x+frame.size.width-radius, frame.origin.y+radius) radius:radius startAngle:M_PI*1.5 endAngle:M_PI*2 clockwise:YES];
    
    [path addLineToPoint:CGPointMake(frame.origin.x+frame.size.width, frame.origin.y+frame.size.height-2*radius-arrowHeight)];
    [path addArcWithCenter:CGPointMake(frame.origin.x+frame.size.width-radius, frame.origin.y+frame.size.height-radius-arrowHeight) radius:radius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(frame.origin.x+arrowOffsetX+arrowHeight, frame.origin.y+frame.size.height-arrowHeight)];
    [path addLineToPoint:CGPointMake(frame.origin.x+arrowOffsetX, frame.origin.y+frame.size.height)];
    
    [path addLineToPoint:CGPointMake(frame.origin.x+arrowOffsetX-arrowHeight, frame.origin.y+frame.size.height-arrowHeight)];
    [path addLineToPoint:CGPointMake(frame.origin.x+radius, frame.origin.y+frame.size.height-arrowHeight)];
    
    [path addArcWithCenter:CGPointMake(frame.origin.x+radius, frame.origin.y+frame.size.height-radius-arrowHeight) radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(frame.origin.x, frame.origin.y+radius)];
    //    [path closePath];
    layer.path=[path CGPath];
    return layer;
}
+(CAShapeLayer *)fan_arrowPopupleftRightMaskFrame:(CGRect)frame arrowWidth:(CGFloat)arrowWidth{
    CAShapeLayer *layer=[[CAShapeLayer alloc]init];
    layer.frame=frame;
    UIBezierPath* path = [UIBezierPath bezierPath];
    //从左边第一个箭头点开始
    [path moveToPoint:CGPointMake(0, frame.size.height/2.0)];
    [path addLineToPoint:CGPointMake(arrowWidth, 0)];
    [path addLineToPoint:CGPointMake(frame.size.width-arrowWidth, 0)];
    [path addLineToPoint:CGPointMake(frame.size.width, frame.size.height/2.0)];
    [path addLineToPoint:CGPointMake(frame.size.width-arrowWidth, frame.size.height)];
    [path addLineToPoint:CGPointMake(arrowWidth, frame.size.height)];
    [path addLineToPoint:CGPointMake(0, frame.size.height/2.0)];
    layer.path=[path CGPath];
    return layer;
}
+(CAShapeLayer *)fan_roundCutoutView:(UIView *)cutoutView cutoutFrame:(CGRect)frame byRoundingCorners:(UIRectCorner)roundingCorners cornerRadius:(CGFloat)cornerRadius{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:cutoutView.bounds];
    [maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:roundingCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)]bezierPathByReversingPath]];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.path = maskPath.CGPath;
    cutoutView.layer.mask=maskLayer;
    return maskLayer;
}
@end
