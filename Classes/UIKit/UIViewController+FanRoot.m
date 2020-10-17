//
//  UIViewController+FanRoot.m
//  FanKit
//
//  Created by 向阳凡 on 16/7/4.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import "UIViewController+FanRoot.h"

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
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}
-(CGFloat)fan_navigationHeight{
    return [[UIApplication sharedApplication] statusBarFrame].size.height+self.navigationController.navigationBar.frame.size.height;
}


@end
