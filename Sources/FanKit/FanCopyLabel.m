//
//  FanCopyLabel.m
//  Brain
//
//  Created by 向阳凡 on 2019/6/5.
//  Copyright © 2019 向阳凡. All rights reserved.
//

#import "FanCopyLabel.h"

@interface FanCopyLabel()

/// 用来过滤多次添加长按
@property (nonatomic,assign) BOOL addLongGesture;

//用来记录label原来的颜色(背景颜色)
@property(nonatomic,strong,nullable)UIColor *fan_originalColor;

@end

@implementation FanCopyLabel
#pragma mark - 初始化
-(instancetype)init{
    self=[super init];
    if (self) {
        [self addLongGestur];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addLongGestur];
    }
    return self;
}
//实现xib的的扩展
-(void)awakeFromNib{
    [super awakeFromNib];
    [self addLongGestur];
}
#pragma mark - 长按手势
//添加长按手势
-(void)addLongGestur{
    if(self.addLongGesture){
        return;
    }
    self.addLongGesture = YES;
    self.userInteractionEnabled=YES;
    UILongPressGestureRecognizer *longGuest=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longGuest];
    //添加通知中心，通知菜单消失时选中背景颜色复原
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(willHideEditMenu:) name:UIMenuControllerWillHideMenuNotification object:nil];
    self.fan_copyBgColor=[UIColor colorWithRed:194.0/255 green:206.0/255 blue:223.0/255 alpha:1];
}
-(void)longPress:(UILongPressGestureRecognizer *)longPressGuesture{
    [self becomeFirstResponder];    //由于执行的先后顺序问题，有两中解决方法，一，加队列，二，touchBegan
    //[self setOriginalColor:self.backgroundColor];
    
    UIMenuController *menu=[UIMenuController sharedMenuController];
    if (@available(iOS 13.0, *)) {
        [menu showMenuFromView:self.superview rect:self.frame];
    } else {
        [menu setTargetRect:self.frame inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
    }
   
    //这里可以实现自定制菜单，但是不能给系统重名
    //    UIMenuItem *copy=[[UIMenuItem alloc]initWithTitle:@"copy" action:@selector(copy:)];
    //    UIMenuItem *past=[[UIMenuItem alloc]initWithTitle:@"paste" action:@selector(paste:)];
    //    [menu setMenuItems:@[copy,past]];
    
    if(self.fan_originalColor == nil){
        self.fan_originalColor = self.backgroundColor;
        if(self.fan_originalColor == nil){
            self.fan_originalColor = [UIColor clearColor];
        }
    }
    self.backgroundColor=self.fan_copyBgColor;
}
//通知中心的，菜单消失时执行
-(void)willHideEditMenu:(id)sender{
    self.backgroundColor=self.fan_originalColor;
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

#pragma mark - delloc
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
