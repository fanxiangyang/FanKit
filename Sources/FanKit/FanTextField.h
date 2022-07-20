//
//  FanTextField.h
//  Brain
//
//  Created by 向阳凡 on 2018/7/2.
//  Copyright © 2018年 向阳凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FanTextField : UITextField
///默认左边距 =10
@property(nonatomic,assign)CGFloat leftSpace;
///默认右边距 =0
@property(nonatomic,assign)CGFloat rightSpace;
///默认左View边距 =0
@property(nonatomic,assign)CGFloat leftViewSpace;
///默认右View边距 =0
@property(nonatomic,assign)CGFloat rightViewSpace;
/// 底部下划线 颜色和宽度-需要自己加约束lineImgView
@property (nonatomic,strong) UIImageView *lineImgView;

@end
