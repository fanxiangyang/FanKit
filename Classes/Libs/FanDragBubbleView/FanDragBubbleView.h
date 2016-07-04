//
//  FanDragBubbleView.h
//  FanDragBubbleView
//
//  Created by 凡向阳 on 15/7/15.
//  Copyright (c) 2015年 Fan. All rights reserved.
//

/**
 *  模仿QQ未读消息的拖拽动画
 
 *  注意：使用方法
 *  1.
        FanDragBubbleView *bv=[[FanDragBubbleView alloc] initWithFrame:CGRectMake(60, 60, 25, 25)];
        bv.showGameCenterAnimation=YES;
        [self.view addSubview:bv];
        bv.bubbleLabel.text=@"2";
 *  2.
         -(void)fanDragBubbleView:(FanDragBubbleView *)bubbleView isRemove:(BOOL)isRemove{
            if (isRemove) {
                [bubbleView removeFromSuperview];
                bubbleView=nil;
            }
         }
 *
 */


#import <UIKit/UIKit.h>

@class FanDragBubbleView;

@protocol FanDragBubbleViewDelegate <NSObject>

-(void)fanDragBubbleView:(FanDragBubbleView *)bubbleView isRemove:(BOOL)isRemove;

@end


@interface FanDragBubbleView : UIView

@property (nonatomic,weak)id<FanDragBubbleViewDelegate> delegate;

/**
 *  气泡上显示数字的label 设置text时要在addSubView之后
 *  the label on the bubble
 */
@property (nonatomic,strong)UILabel *bubbleLabel;

/**
 *  气泡的直径
 *  bubble's diameter
 */
@property (nonatomic,assign)CGFloat bubbleWidth;

/**
 *  气泡粘性系数，越大可以拉得越长
 *  viscosity of the bubble,the bigger you set,the longer you drag
 */
@property (nonatomic,assign)CGFloat viscosity;

@property (nonatomic,assign)CGFloat breakViscosity;

/**
 *  气泡颜色
 *  bubble's color
 */
@property (nonatomic,strong)UIColor *bubbleColor;

/**
 *  GameCenter动画 default NO
 *  if you want show GameCenter Animation you can set it yes default NO
 */
@property (nonatomic,assign)BOOL showGameCenterAnimation;

/**
 *  允许拖拽手势 default yes
 *  allow PanGestureRecognizer default yes
 */
@property (nonatomic,assign)BOOL allowPan;

/**
 *  开启模式
 */
-(void)start;


@end
