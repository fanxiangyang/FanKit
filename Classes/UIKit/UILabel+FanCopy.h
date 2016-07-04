//
//  UILabel+FanCopy.h
//  FanKit
//
//  Created by 向阳凡 on 16/7/4.
//  Copyright © 2016年 凡向阳. All rights reserved.
//
/*
  1.记得改选中时的背景颜色，对于恢复时，
 因为是catigory，加私有成员是静态的，所以不默认恢复白色，
 也本想通过kvo实现，没有实现
 
 */

#import <UIKit/UIKit.h>

@interface UILabel (FanCopy)
//用来记录label原来的颜色
@property(nonatomic,strong)UIColor *fan_originalColor;


@end
