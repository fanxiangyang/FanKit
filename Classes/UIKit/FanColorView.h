//
//  FanColorView.h
//  Brain
//
//  Created by 向阳凡 on 2019/4/28.
//  Copyright © 2019 向阳凡. All rights reserved.
//

/**
    参考：https://github.com/Zws-China/WSColorPicker
 *
 *
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FanColorViewBlock)(UIColor *touchColor,CGFloat r,CGFloat g,CGFloat b,CGFloat a);

typedef void(^FanColorViewMoveBlock)(CGPoint point,UIColor *touchColor);

@interface FanColorView : UIImageView

@property(nonatomic,copy)FanColorViewBlock colorBlock;
@property(nonatomic,copy)FanColorViewMoveBlock moveBlock;

//0=圆形图  1= 矩形色彩图 2=矩形色彩深度图
@property(nonatomic,assign,readonly)NSInteger colorType;
@property(nonatomic,assign)BOOL isVertical;//默认NO,横向

//深色模式下，开始颜色（赋值会时时变化）
@property(nonatomic,strong)UIColor *startDepthColor;


//必须实现该方法
-(void)initWithColorType:(NSInteger)colorType;



#pragma mark - 可选的执行方法
//必须在initWithFrame之后，执行，不然不显示
@property(nonatomic,strong,readonly)UIImageView *sliderView;
//添加滑杆，颜色选择滑杆
-(void)addSliderView:(UIImageView *)sliderView;


@end

NS_ASSUME_NONNULL_END
