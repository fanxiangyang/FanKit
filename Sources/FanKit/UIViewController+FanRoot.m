//
//  UIViewController+FanRoot.m
//  FanKit
//
//  Created by 向阳凡 on 16/7/4.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import "UIViewController+FanRoot.h"
#import "FanUIKit.h"

@implementation UIViewController (FanRoot)


-(void)fan_addTapGestureTarget:(id)target action:(SEL)action toView:(UIView *)tapView{
    UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapView.userInteractionEnabled=YES;
    [tapView addGestureRecognizer:imageTapGesture];
}

- (void)fan_addTitleViewWithTitle:(NSString *)title textColor:(UIColor *)color{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor=color;
    self.navigationItem.titleView = label;
}
-(CGFloat)fan_statusbarHeight{
    if (@available(iOS 13.0, *)) {
        return [FanUIKit fan_activeWindowScene].statusBarManager.statusBarFrame.size.height ;
    } else {
        return [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
}
-(CGFloat)fan_navigationHeight{
    if (@available(iOS 13.0, *)) {
        return [FanUIKit fan_activeWindowScene].statusBarManager.statusBarFrame.size.height+self.navigationController.navigationBar.frame.size.height ;
    } else {
        return [[UIApplication sharedApplication] statusBarFrame].size.height+self.navigationController.navigationBar.frame.size.height;
    }
}
-(CGFloat)fan_tabBarHeight{
    return self.tabBarController.tabBar.frame.size.height;
}

///添加子VC-并且添加view
-(void)fan_addChildViewController:(UIViewController *)vc{
    if (vc) {
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
    }
}
///从父控制器移除-并且移除view
-(void)fan_removeFromParentViewController{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
@end
