//
//  UIButton+FanCategory.m
//  FanKit
//
//  Created by 凡向阳 on 2024/03/15.
//  Copyright © 2024 向阳凡. All rights reserved.
//

#import "UIButton+FanCategory.h"


@implementation UIButton (FanCategory)

//MARK: - 新的按钮创建方式

/// 创建只有文本的按钮+内间距 （文本只支持单行和多行，不支持固定2行）
+(instancetype)fan_btnTitle:(NSString *)title textColor:(UIColor *)textColor font:(UIFont*)font edge:(UIEdgeInsets)edge{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    if (@available(iOS 15.0, *)) {
        UIButtonConfiguration *config = [UIButtonConfiguration plainButtonConfiguration];
        config.contentInsets = NSDirectionalEdgeInsetsMake(edge.top, edge.left, edge.bottom, edge.right);
        config.imagePadding = 8;
        config.titleTextAttributesTransformer = ^NSDictionary<NSAttributedStringKey,id> * _Nonnull(NSDictionary<NSAttributedStringKey,id> * _Nonnull textAttributes) {
            return @{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor};
        };
//        config.buttonSize = UIButtonConfigurationSizeLarge;
//        config.titleLineBreakMode = NSLineBreakByCharWrapping;
//        config.imagePlacement = NSDirectionalRectEdgeLeading;
        btn.configuration = config;
    } else {
        [btn setContentEdgeInsets:edge];
    }
    return btn;
}
/// 创建只有图片的按钮+内间距
+(instancetype)fan_btnImageName:(NSString *)imageName edge:(UIEdgeInsets)edge{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if (@available(iOS 15.0, *)) {
        UIButtonConfiguration *config = [UIButtonConfiguration plainButtonConfiguration];
        config.contentInsets = NSDirectionalEdgeInsetsMake(edge.top, edge.left, edge.bottom, edge.right);
        config.imagePadding = 8;
//        config.imagePlacement = NSDirectionalRectEdgeLeading;
        btn.configuration = config;
    } else {
        [btn setContentEdgeInsets:edge];
    }
    return btn;
}
///适配iOS15 UIButtonConfiguration设置字体颜色和大小
-(void)fan_setTextColor:(UIColor *)textColor font:(UIFont*)font{
    if (@available(iOS 15.0, *)) {
        UIButtonConfiguration *config = self.configuration;
        if(config){
            config.titleTextAttributesTransformer = ^NSDictionary<NSAttributedStringKey,id> * _Nonnull(NSDictionary<NSAttributedStringKey,id> * _Nonnull textAttributes) {
                return @{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor};
            };
            self.configuration = config;
            return;
        }

    }
    self.titleLabel.font = font;
    [self setTitleColor:textColor forState:UIControlStateNormal];
}
///设置内边距，支持iOS15的方法
-(void)fan_setMargins:(UIEdgeInsets)margins{
    if (@available(iOS 15.0, *)) {
        UIButtonConfiguration *config = self.configuration;
        if(config){
            config.contentInsets = NSDirectionalEdgeInsetsMake(margins.top, margins.left, margins.bottom, margins.right);
            self.configuration = config;
            return;
        }
    }
    self.contentEdgeInsets = margins;
}
///设置图片与文本间距(支持旧的左图右文结构，与iOS15之后的UIButtonConfiguration)
-(void)fan_setImagePadding:(CGFloat)imagePadding{
    if (@available(iOS 15.0, *)) {
        UIButtonConfiguration *config = self.configuration;
        if(config){
            config.imagePadding = imagePadding;
            self.configuration = config;
            return;
        }
    }
    UIEdgeInsets contentInsets = self.contentEdgeInsets;
    UIEdgeInsets imageInsets = self.imageEdgeInsets;
    contentInsets.left += imagePadding;
    imageInsets.left -= imagePadding;
    imageInsets.right += imagePadding;
    self.contentEdgeInsets = contentInsets;
    self.imageEdgeInsets = imageInsets;
}
///设置图片与文本间距(支持旧的图文结构，与iOS15之后的UIButtonConfiguration)
-(void)fan_setImagePadding:(CGFloat)imagePadding postion:(FanButtonEdgeStyle)postion{
    if (@available(iOS 15.0, *)) {
        UIButtonConfiguration *config = self.configuration;
        if(config){
            config.imagePadding = imagePadding;
            if(postion == FanButtonEdgeStyleLeft){
                config.imagePlacement = NSDirectionalRectEdgeLeading;
            }else if (postion == FanButtonEdgeStyleRight){
                config.imagePlacement = NSDirectionalRectEdgeTrailing;
            }else if (postion == FanButtonEdgeStyleTop){
                config.imagePlacement = NSDirectionalRectEdgeTop;
            }else if (postion == FanButtonEdgeStyleBottom){
                config.imagePlacement = NSDirectionalRectEdgeBottom;
            }
            self.configuration = config;
            return;
        }
    }
    UIEdgeInsets contentInsets = self.contentEdgeInsets;
    UIEdgeInsets imageInsets = self.imageEdgeInsets;
    if(postion == FanButtonEdgeStyleLeft){
        contentInsets.left += imagePadding;
        imageInsets.left -= imagePadding;
        imageInsets.right += imagePadding;
    }else if (postion == FanButtonEdgeStyleRight){
        contentInsets.right += imagePadding;
        imageInsets.left += imagePadding;
        imageInsets.right -= imagePadding;
    }else if (postion == FanButtonEdgeStyleTop){
        contentInsets.top += imagePadding;
        imageInsets.top -= imagePadding;
        imageInsets.bottom += imagePadding;
    }else if (postion == FanButtonEdgeStyleBottom){
        contentInsets.bottom += imagePadding;
        imageInsets.top += imagePadding;
        imageInsets.bottom -= imagePadding;
    }
    self.contentEdgeInsets = contentInsets;
    self.imageEdgeInsets = imageInsets;
}


@end

