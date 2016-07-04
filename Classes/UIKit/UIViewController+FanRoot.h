//
//  UIViewController+FanRoot.h
//  FanKit
//
//  Created by 向阳凡 on 16/7/4.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FanRoot)


/** 添加单击手势 */
-(void)fan_addTapGestureTarget:(id)target action:(SEL)action toView:(UIView *)tapView;

/** 根据不同的提示信息，创建警告框 */
-(void)fan_showAlertWithMessage:(NSString *)message delegate:(id)fan_delegate;
-(void)fan_showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)fan_delegate tag:(NSInteger)tag;
/**titleView*/
- (void)fan_addTitleViewWithTitle:(NSString *)title textColor:(UIColor *)color;



@end
