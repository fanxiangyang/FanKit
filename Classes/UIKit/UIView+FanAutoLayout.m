//
//  UIView+FanAutoLayout.m
//  FanYou360
//
//  Created by 向阳凡 on 15/10/17.
//  Copyright © 2015年 向阳凡. All rights reserved.
//

#import "UIView+FanAutoLayout.h"

@implementation UIView (FanAutoLayout)
/**
 *  移除控件所有约束
 */
- (void)fan_removeAllAutoLayout{
    [self removeConstraints:self.constraints];
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if ([constraint.firstItem isEqual:self]) {
            [self.superview removeConstraint:constraint];
        }
    }
}
/**
 *  宽高固定的中心约束
 *
 *  @param centerView 中心控件
 *  @param size       控件大小
 */
-(void)fan_addConstraintsCenter:(id)centerView viewSize:(CGSize)size{
    ((UIView *)centerView).translatesAutoresizingMaskIntoConstraints=NO;

    NSDictionary* views = NSDictionaryOfVariableBindings(centerView);

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[centerView(%f)]",size.width] options:0 metrics:nil views:views]];
    //高度
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[centerView(%f)]",size.height] options:0 metrics:nil views:views]];
    //垂直居中
    [self addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    //水平居中
    [self addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}
/**
 *  宽高固定的Center X ,Y约束
 *
 *  @param centerView   约束控件
 *  @param size         控件大小
 *  @param layoutCenter 中心类型
 *  @param padding      间距
 */
-(void)fan_addConstraintsCenter:(id)centerView viewSize:(CGSize)size layoutCenter:(FanLayoutCenter)layoutCenter padding:(CGFloat)padding{
    ((UIView *)centerView).translatesAutoresizingMaskIntoConstraints=NO;
    NSDictionary* views = NSDictionaryOfVariableBindings(centerView);
    
    switch (layoutCenter) {
        case FanLayoutCenterXTop:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"[centerView(%f)]",size.width] options:0 metrics:nil views:views]];
            //高度
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[centerView(%f)]",padding, size.height] options:0 metrics:nil views:views]];
            //水平居中
            [self addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        }
            break;
        case FanLayoutCenterXBottom:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"[centerView(%f)]",size.width] options:0 metrics:nil views:views]];
            //高度
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[centerView(%f)]-(%f)-|",size.height,padding] options:0 metrics:nil views:views]];
            //水平居中
            [self addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        }
            break;
        case FanLayoutCenterYLeft:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|-(%f)-[centerView(%f)]",padding,size.width] options:0 metrics:nil views:views]];
            //高度
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[centerView(%f)]",size.height] options:0 metrics:nil views:views]];
            //垂直居中
            [self addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        }
            break;
        case FanLayoutCenterYRight:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"[centerView(%f)]-(%f)-|",size.width,padding] options:0 metrics:nil views:views]];
            //高度
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[centerView(%f)]",size.height] options:0 metrics:nil views:views]];
            //垂直居中
            [self addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        }

        case FanLayoutCenterAll:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"[centerView(%f)]",size.width] options:0 metrics:nil views:views]];
            //高度
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[centerView(%f)]",size.height] options:0 metrics:nil views:views]];
            //垂直居中
            [self addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            //水平居中
            [self addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        }
            break;
    
        default:
            break;
    }
}
/**
 *  添加（子控件） 1=单方向三边，2=双边（宽高固定），3=全边（缩放）约束
 *
 *  @param constraintView  约束控件
 *  @param edgeInsets      上左下右间距
 *  @param layoutAttribute 约束类型
 *  @param size            控件大小
 */
-(void)fan_addConstraints:(id)constraintView edgeInsets:(UIEdgeInsets)edgeInsets  layoutType:(FanLayoutAttribute)layoutAttribute viewSize:(CGSize)size{
   ((UIView *)constraintView).translatesAutoresizingMaskIntoConstraints=NO;
    NSDictionary* views = NSDictionaryOfVariableBindings(constraintView);
    switch (layoutAttribute) {
        case FanLayoutAttributeTop:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[constraintView]-(%f)-|",edgeInsets.left,edgeInsets.right] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[constraintView(%f)]",edgeInsets.top,size.height] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
        }
            break;
        case FanLayoutAttributeLeft:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[constraintView(%f)]",edgeInsets.left,size.width] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[constraintView]-(%f)-|",edgeInsets.top,edgeInsets.bottom] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
        }
            break;
        case FanLayoutAttributeBottom:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[constraintView]-(%f)-|",edgeInsets.left,edgeInsets.right] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[constraintView(%f)]-(%f)-|",size.height,edgeInsets.bottom] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
        }
            break;
        case FanLayoutAttributeRight:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[constraintView(%f)]-(%f)-|",size.width,edgeInsets.right] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[constraintView]-(%f)-|",edgeInsets.top,edgeInsets.bottom] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
        }
            break;
        case FanLayoutAttributeAll:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[constraintView]-(%f)-|",edgeInsets.left,edgeInsets.right] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[constraintView]-(%f)-|",edgeInsets.top,edgeInsets.bottom] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
        }
            break;
        case FanLayoutAttributeTopLeft:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[constraintView(%f)]",edgeInsets.left,size.width] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[constraintView(%f)]",edgeInsets.top,size.height] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
        }
            break;
        case FanLayoutAttributeTopRight:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[constraintView(%f)]-(%f)-|",size.width,edgeInsets.right] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[constraintView(%f)]",edgeInsets.top,size.height] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
        }
            break;
        case FanLayoutAttributeBottomLeft:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[constraintView(%f)]",edgeInsets.left,size.width] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[constraintView(%f)]-(%f)-|",size.height,edgeInsets.bottom] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
        }
            break;
        case FanLayoutAttributeBottomRight:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[constraintView(%f)]-(%f)-|",size.width,edgeInsets.right] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[constraintView(%f)]-(%f)-|",size.height,edgeInsets.bottom] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
        }
            break;
        default:
            break;
    }
}
/**
 *  宽高比固定的靠边约束【宽高比<Width/Height>】
 *
 *  @param constraintView    约束控件
 *  @param edgeInsets        间距
 *  @param layoutAspectRatio 靠边类型
 *  @param ratio             宽高比<Width/Height>
 */
-(void)fan_addConstraintsAspectRatio:(id)constraintView edgeInsets:(UIEdgeInsets)edgeInsets  layoutType:(FanLayoutAspectRatio)layoutAspectRatio aspectRatio:(CGFloat)ratio{
    ((UIView *)constraintView).translatesAutoresizingMaskIntoConstraints=NO;
    NSDictionary* views = NSDictionaryOfVariableBindings(constraintView);
    switch (layoutAspectRatio) {
        case FanLayoutAspectRatioTop:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[constraintView]-(%f)-|",edgeInsets.left,edgeInsets.right] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[constraintView]",edgeInsets.top] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            //定义高度比
            NSLayoutConstraint *constraint=[NSLayoutConstraint
             constraintWithItem:constraintView
             attribute:NSLayoutAttributeHeight
             relatedBy:NSLayoutRelationEqual
             toItem:constraintView
             attribute:NSLayoutAttributeWidth
             multiplier:1.0/ratio constant:0];
            constraint.priority=UILayoutPriorityDefaultHigh;
            [self addConstraint:constraint];
        }
            break;
        case FanLayoutAspectRatioBottom:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[constraintView]-(%f)-|",edgeInsets.left,edgeInsets.right] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[constraintView]-(%f)-|",edgeInsets.bottom] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            //定义高度比
            NSLayoutConstraint *constraint=[NSLayoutConstraint
                                            constraintWithItem:constraintView
                                            attribute:NSLayoutAttributeHeight
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:constraintView
                                            attribute:NSLayoutAttributeWidth
                                            multiplier:1.0/ratio constant:0];
            constraint.priority=UILayoutPriorityDefaultHigh;
            [self addConstraint:constraint];
        }
            break;
        case FanLayoutAspectRatioLeft:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[constraintView]",edgeInsets.left] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[constraintView]-(%f)-|",edgeInsets.top,edgeInsets.bottom] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            //定义高度比
            NSLayoutConstraint *constraint=[NSLayoutConstraint
                                            constraintWithItem:constraintView
                                            attribute:NSLayoutAttributeWidth
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:constraintView
                                            attribute:NSLayoutAttributeHeight
                                            multiplier:ratio
                                            constant:0];
            constraint.priority=UILayoutPriorityDefaultHigh;
            [self addConstraint:constraint];
        }
            break;
        case FanLayoutAspectRatioRight:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[constraintView]-(%f)-|",edgeInsets.right] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[constraintView]-(%f)-|",edgeInsets.top,edgeInsets.bottom] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            //定义高度比
            NSLayoutConstraint *constraint=[NSLayoutConstraint
                                            constraintWithItem:constraintView
                                            attribute:NSLayoutAttributeWidth
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:constraintView
                                            attribute:NSLayoutAttributeHeight
                                            multiplier:ratio
                                            constant:0];
            constraint.priority=UILayoutPriorityDefaultHigh;
            [self addConstraint:constraint];
        }
            break;
        default:
            break;
    }
    
}
/**
 *  带一个View依靠的全方向缩放
 *
 *  @param constraintView  约束控件
 *  @param dependView      依靠控件
 *  @param edgeInsets      间距
 *  @param layoutAttribute 类型（只能是FanLayoutAttributeTop，Bottom,Left,Right）
 */
-(void)fan_addConstraintsAll:(id)constraintView dependView:(id)dependView edgeInsets:(UIEdgeInsets)edgeInsets  layoutType:(FanLayoutAttribute)layoutAttribute {
    ((UIView *)constraintView).translatesAutoresizingMaskIntoConstraints=NO;
    NSMutableDictionary* views = [NSDictionaryOfVariableBindings(constraintView) mutableCopy];
    [views setValue:dependView forKey:@"dependView"];
    switch (layoutAttribute) {
        case FanLayoutAttributeTop:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[constraintView]-(%f)-|",edgeInsets.left,edgeInsets.right] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[constraintView]-(%f)-|",edgeInsets.bottom] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            NSLayoutConstraint *constraint=[NSLayoutConstraint
                                            constraintWithItem:constraintView
                                            attribute:NSLayoutAttributeTop
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:dependView
                                            attribute:NSLayoutAttributeBottom
                                            multiplier:1.0
                                            constant:edgeInsets.top];
            //            constraint.priority=UILayoutPriorityDefaultHigh;
            [self addConstraint:constraint];

        }
            break;
        case FanLayoutAttributeLeft:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[constraintView]-(%f)-|",edgeInsets.right] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[constraintView]-(%f)-|",edgeInsets.top,edgeInsets.bottom] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            NSLayoutConstraint *constraint=[NSLayoutConstraint
                                            constraintWithItem:constraintView
                                            attribute:NSLayoutAttributeLeft
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:dependView
                                            attribute:NSLayoutAttributeRight
                                            multiplier:1.0
                                            constant:edgeInsets.left];
            //            constraint.priority=UILayoutPriorityDefaultHigh;
            [self addConstraint:constraint];

        }
            break;
        case FanLayoutAttributeBottom:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[constraintView]-(%f)-|",edgeInsets.left,edgeInsets.right] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[constraintView]",edgeInsets.top] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            NSLayoutConstraint *constraint=[NSLayoutConstraint
                                            constraintWithItem:constraintView
                                            attribute:NSLayoutAttributeBottom
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:dependView
                                            attribute:NSLayoutAttributeTop
                                            multiplier:1.0
                                            constant:edgeInsets.bottom];//可能用负值，
            //            constraint.priority=UILayoutPriorityDefaultHigh;
            [self addConstraint:constraint];

        }
            break;
        case FanLayoutAttributeRight:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[constraintView]",edgeInsets.left] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[constraintView]-(%f)-|",edgeInsets.top,edgeInsets.bottom] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            NSLayoutConstraint *constraint=[NSLayoutConstraint
                                            constraintWithItem:constraintView
                                            attribute:NSLayoutAttributeRight
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:dependView
                                            attribute:NSLayoutAttributeLeft
                                            multiplier:1.0
                                            constant:edgeInsets.right];//可能是负值
            //            constraint.priority=UILayoutPriorityDefaultHigh;
            [self addConstraint:constraint];

        }
            break;
        default:
            break;
    }

}
/**
 *  有一个依靠控件的一端固定的约束
 *
 *  @param constraintView  约束控件
 *  @param dependView      依靠控件
 *  @param edgeInsets      间距
 *  @param layoutAttribute 类型（只能是FanLayoutAttributeTop，Bottom,Left,Right）
 *  @param size            控件大小
 */
-(void)fan_addConstraintsOne:(id)constraintView dependView:(id)dependView edgeInsets:(UIEdgeInsets)edgeInsets  layoutType:(FanLayoutAttribute)layoutAttribute viewSize:(CGSize)size{
    ((UIView *)constraintView).translatesAutoresizingMaskIntoConstraints=NO;
    NSMutableDictionary* views = [NSDictionaryOfVariableBindings(constraintView) mutableCopy];
    [views setValue:dependView forKey:@"dependView"];
    switch (layoutAttribute) {
        case FanLayoutAttributeTop:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[constraintView]-(%f)-|",edgeInsets.left,edgeInsets.right] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[constraintView(%f)]",size.height] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            NSLayoutConstraint *constraint=[NSLayoutConstraint
                                            constraintWithItem:constraintView
                                            attribute:NSLayoutAttributeTop
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:dependView
                                            attribute:NSLayoutAttributeBottom
                                            multiplier:1.0
                                            constant:edgeInsets.top];
            //            constraint.priority=UILayoutPriorityDefaultHigh;
            [self addConstraint:constraint];
        }
            break;
        case FanLayoutAttributeLeft:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[constraintView(%f)]",size.width] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[constraintView]-(%f)-|",edgeInsets.top,edgeInsets.bottom] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            NSLayoutConstraint *constraint=[NSLayoutConstraint
                                            constraintWithItem:constraintView
                                            attribute:NSLayoutAttributeLeft
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:dependView
                                            attribute:NSLayoutAttributeRight
                                            multiplier:1.0
                                            constant:edgeInsets.left];
            //            constraint.priority=UILayoutPriorityDefaultHigh;
            [self addConstraint:constraint];
        }
            break;
        case FanLayoutAttributeBottom:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[constraintView]-(%f)-|",edgeInsets.left,edgeInsets.right] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[constraintView(%f)]",size.height] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            NSLayoutConstraint *constraint=[NSLayoutConstraint
                                            constraintWithItem:constraintView
                                            attribute:NSLayoutAttributeBottom
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:dependView
                                            attribute:NSLayoutAttributeTop
                                            multiplier:1.0
                                            constant:edgeInsets.bottom];//可能用负值，
            //            constraint.priority=UILayoutPriorityDefaultHigh;
            [self addConstraint:constraint];
        }
            break;
        case FanLayoutAttributeRight:
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[constraintView(%f)]",size.width] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[constraintView]-(%f)-|",edgeInsets.top,edgeInsets.bottom] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            NSLayoutConstraint *constraint=[NSLayoutConstraint
                                            constraintWithItem:constraintView
                                            attribute:NSLayoutAttributeRight
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:dependView
                                            attribute:NSLayoutAttributeLeft
                                            multiplier:1.0
                                            constant:edgeInsets.right];//可能是负值
            //            constraint.priority=UILayoutPriorityDefaultHigh;
            [self addConstraint:constraint];
        }
            break;
        default:
            break;
    }
}
#pragma mark - VFL格式话约束+居中约束
// @"H:|-20-[V1(50)]-20-[V2(==V1)]-20-[V3(==V1)]";
/// 添加多view约束Format方式(参数必须是 V1,V2,....)
/// @param views 多个view
/// @param formatH 水平format
/// @param formatV 垂直format
/// @param formatOptions 可选参数 默认 0
-(void)fan_addConstraintsFormatViews:(NSArray *)views formatH:(NSString *)formatH formatV:(NSString *)formatV formatOptions:(NSLayoutFormatOptions)formatOptions{
    NSMutableDictionary *dicViews=[[NSMutableDictionary alloc]init];
    for (int i=0;i<views.count ;i++) {
        UIView *view=(UIView *)views[i];
        view.translatesAutoresizingMaskIntoConstraints=NO;
        [dicViews setObject:view forKey:[NSString stringWithFormat:@"V%ld",(long)(i+1)]];
    }
    //水平方向
    if (formatH.length>0) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatH options:formatOptions metrics:nil views:dicViews]];
    }
    //垂直方向
    if (formatV.length>0) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatV options:formatOptions metrics:nil views:dicViews]];
    }
}
/// 添加单view约束Format方式(format里面必须是view)
/// @param view 需要约束的view
/// @param formatH 水平format
/// @param formatV 垂直format
/// @param formatOptions 可选参数 默认 0
-(void)fan_addConstraintsFormat:(id)view formatH:(NSString *)formatH formatV:(NSString *)formatV formatOptions:(NSLayoutFormatOptions)formatOptions{
    ((UIView *)view).translatesAutoresizingMaskIntoConstraints=NO;
    NSDictionary* views = NSDictionaryOfVariableBindings(view);
    //水平方向
    if (formatH.length>0) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatH options:formatOptions metrics:nil views:views]];
    }
    //垂直方向
    if (formatV.length>0) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatV options:formatOptions metrics:nil views:views]];
    }
}
/// 添加中心约束XY
/// @param centerView 需要居中的view
/// @param centerX X偏移量
/// @param centerY Y偏移量
-(void)fan_addConstraintsCenterXY:(id)centerView centerX:(CGFloat)centerX centerY:(CGFloat)centerY{
    ((UIView *)centerView).translatesAutoresizingMaskIntoConstraints=NO;
    //水平居中
    [self addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:centerX]];
    //垂直居中
    [self addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:centerY]];
}
/// 添加中心约束centerX
/// @param centerView 需要居中的View
/// @param centerX X偏移量
/// @param multiplier 距离中心百分比 默认中心1.0
-(void)fan_addConstraintsCenterX:(id)centerView centerX:(CGFloat)centerX multiplier:(CGFloat)multiplier{
    ((UIView *)centerView).translatesAutoresizingMaskIntoConstraints=NO;
    //水平居中
    [self addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:multiplier constant:centerX]];
}
/// 添加中心约束centerY
/// @param centerView 需要居中的View
/// @param centerY Y偏移量
/// @param multiplier 距离中心百分比 默认中心1.0
-(void)fan_addConstraintsCenterY:(id)centerView centerY:(CGFloat)centerY multiplier:(CGFloat)multiplier{
    ((UIView *)centerView).translatesAutoresizingMaskIntoConstraints=NO;
    //垂直居中
    [self addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:multiplier constant:centerY]];
}
/// 添加宽高固定的View
/// @param view 宽高固定view
/// @param size view尺寸
-(void)fan_addConstraintsWidthHeightView:(id)view viewSize:(CGSize)size{
    ((UIView *)view).translatesAutoresizingMaskIntoConstraints=NO;
    NSDictionary* views = NSDictionaryOfVariableBindings(view);
    //宽高固定
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[constraintView(%f)]",size.width] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[constraintView(%f)]",size.height] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
}

/// 自己一边依赖另外一个view的边
/// @param constraintView 自己View
/// @param dependView 依赖view
/// @param attribute NSLayoutAttribute
/// @param dependAttribute 依赖的
/// @param space 间距
-(void)fan_addConstraintsDepend:(id)constraintView dependView:(id)dependView attribute:(NSLayoutAttribute)attribute dependAttribute:(NSLayoutAttribute)dependAttribute space:(CGFloat)space{
    ((UIView *)constraintView).translatesAutoresizingMaskIntoConstraints=NO;
    NSMutableDictionary* views = [NSDictionaryOfVariableBindings(constraintView) mutableCopy];
    [views setValue:dependView forKey:@"dependView"];
    NSLayoutConstraint *constraint=[NSLayoutConstraint
                                    constraintWithItem:constraintView
                                    attribute:attribute
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:dependView
                                    attribute:dependAttribute
                                    multiplier:1.0
                                    constant:space];
    //constraint.priority=UILayoutPriorityDefaultHigh;
    [self addConstraint:constraint];
}
/// 自己一边依赖另外一个view的边,也可以是自己和自己宽高比
/// @param constraintView 自己View
/// @param dependView 依赖view
/// @param attribute NSLayoutAttribute
/// @param dependAttribute 依赖的
/// @param space 间距
/// @param multiplier 默认1.0  宽高比
-(void)fan_addConstraintsDepend:(id)constraintView dependView:(id)dependView attribute:(NSLayoutAttribute)attribute dependAttribute:(NSLayoutAttribute)dependAttribute space:(CGFloat)space multiplier:(CGFloat)multiplier{
    ((UIView *)constraintView).translatesAutoresizingMaskIntoConstraints=NO;
    NSMutableDictionary* views = [NSDictionaryOfVariableBindings(constraintView) mutableCopy];
    [views setValue:dependView forKey:@"dependView"];
    NSLayoutConstraint *constraint=[NSLayoutConstraint
                                    constraintWithItem:constraintView
                                    attribute:attribute
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:dependView
                                    attribute:dependAttribute
                                    multiplier:multiplier
                                    constant:space];
    constraint.priority=UILayoutPriorityDefaultHigh;
    [self addConstraint:constraint];
}
/// 添加在父类安全区域的一边约束
/// @param constraintView 需要约束的控件
/// @param attribute 需要约束的方位
/// @param safeAttribute 依赖的方位
/// @param space 间距
-(void)fan_addSafeAreaConstraintsView:(id)constraintView attribute:(NSLayoutAttribute)attribute safeAttribute:(NSLayoutAttribute)safeAttribute space:(CGFloat)space{
    ((UIView *)constraintView).translatesAutoresizingMaskIntoConstraints=NO;
    if (@available(iOS 11.0, *)) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:constraintView attribute:attribute relatedBy:NSLayoutRelationEqual toItem:self.safeAreaLayoutGuide attribute:safeAttribute multiplier:1.0 constant:space];
        [self addConstraint:constraint];
    } else {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:constraintView attribute:attribute relatedBy:NSLayoutRelationEqual toItem:self attribute:safeAttribute multiplier:1.0 constant:space];
        [self addConstraint:constraint];
    }
}
@end
