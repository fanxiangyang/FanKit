//
//  UILabel+FanCopy.m
//  FanKit
//
//  Created by 向阳凡 on 16/7/4.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import "UILabel+FanCopy.h"
#import <objc/runtime.h>


@implementation UILabel (FanCopy)
#pragma mark - 添加私有属性
@dynamic fan_originalColor;

static const void *baseColor=&baseColor;

-(UIColor *)fan_originalColor{
    return objc_getAssociatedObject(self, baseColor);
}

-(void)setFan_originalColor:(UIColor *)fan_originalColor{
    objc_setAssociatedObject(self, baseColor, fan_originalColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - 初始化
-(id)init{
    self=[super init];
    if (self==nil) {
        self=[[UILabel alloc]init];
        //可能是category的特性，该[super init]不为空
    }
    [self addLongGuest];
    return self;
}
//实现xib的的扩展
-(void)awakeFromNib{
    [super awakeFromNib];
    [self addLongGuest];
}
#pragma mark - 长按手势
//添加长按手势
-(void)addLongGuest{
    self.userInteractionEnabled=YES;
    UILongPressGestureRecognizer *longGuest=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longGuest];
    //添加通知中心，通知菜单消失时选中背景颜色复原
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(willHideEditMenu:) name:UIMenuControllerWillHideMenuNotification object:nil];
    //     [self.backgroundColor addObserver:self forKeyPath:@"fan_originalColor" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

-(void)longPress:(UILongPressGestureRecognizer *)longPressGuesture{
    [self becomeFirstResponder];
    
    //由于执行的先后顺序问题，有两中解决方法，一，加队列，二，touchBegan
    //[self setOriginalColor:self.backgroundColor];
    
    UIMenuController *menu=[UIMenuController sharedMenuController];
    [menu setTargetRect:self.frame inView:self.superview];
    //这里可以实现自定制菜单，但是不能给系统重名
    //    UIMenuItem *copy=[[UIMenuItem alloc]initWithTitle:@"copy" action:@selector(copy:)];
    //    UIMenuItem *past=[[UIMenuItem alloc]initWithTitle:@"paste" action:@selector(paste:)];
    //    [menu setMenuItems:@[copy,past]];
    [menu setMenuVisible:YES animated:YES];
    
    
    
    self.backgroundColor=[UIColor colorWithRed:194.0/255 green:206.0/255 blue:223.0/255 alpha:1];
}
//通知中心的，菜单消失时执行
-(void)willHideEditMenu:(id)sender{
    self.backgroundColor=[self fan_originalColor];
}
//#pragma mark - notificationCenter
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    if([object isKindOfClass:[UIColor class]]){
//        UIColor *colorNew=[change objectForKey:@"new"];
//        if (colorNew.CGColor==[UIColor colorWithRed:194.0/255 green:206.0/255 blue:223.0/255 alpha:1].CGColor) {
//            NSLog(@"color is change");
//            [self setOriginalColor:[change objectForKey:@"old"]];
//        }
//    }
//}
#pragma mark - UIResponder
//成为第一响应
-(BOOL)canBecomeFirstResponder{
    return YES;
}

//可以控制菜单的显示方式
//-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//     if(action ==@selector(copy:)){
//        return YES;
//     }
//    else if(action ==@selector(cut:)){
//         return YES;
//    }
//    else if(action ==@selector(paste:)){
//        return YES;
//    }
//    else if(action ==@selector(select:)){
//        return YES;
//    }
//    else if(action ==@selector(selectAll:)){
//        return YES;
//    }
//    else{
//        NSLog(@"not selected");
//        return [super canPerformAction:action withSender:sender];
//    }
//
//}

//具体实现copy
-(void)copy:(id)sender{
    UIPasteboard *pboard=[UIPasteboard generalPasteboard];
    pboard.string=self.text;
}
-(void)paste:(id)sender{
    UIPasteboard *pboard=[UIPasteboard generalPasteboard];
    self.text=pboard.string;
}
-(void)selectAll:(id)sender{
    UIPasteboard *pboard=[UIPasteboard generalPasteboard];
    pboard.string=self.text;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (CGColorEqualToColor(self.backgroundColor.CGColor, [UIColor colorWithRed:194.0/255 green:206.0/255 blue:223.0/255 alpha:1].CGColor)) {
        return;
    }
    [self setFan_originalColor:self.backgroundColor];
}
#pragma mark - delloc
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
}

@end
