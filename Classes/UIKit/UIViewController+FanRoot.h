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
/**titleView*/
- (void)fan_addTitleViewWithTitle:(NSString *)title textColor:(UIColor *)color;
///获取状态栏高度(状态栏+安全区域)
-(CGFloat)fan_statusbarHeight;
///获取导航栏高度(状态栏+导航)
-(CGFloat)fan_navigationHeight;
///获取底部TabBar高度
-(CGFloat)fan_tabBarHeight;
///添加子VC-并且添加view
-(void)fan_addChildViewController:(UIViewController *)vc;
///从父控制器移除-并且移除view
-(void)fan_removeFromParentViewController;

@end
