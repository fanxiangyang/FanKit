//
//  FanAnimationToll.h  
//
//  Created by 凡向阳 on 15-2-9.
//  Copyright (c) 2015年 未名空间. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

/**注意：
 *  1.CATransition(系统最上层动画）|CABasicAnimation（系统底层动画）|CAKeyframeAnimation（系统底层动画）
 *
 *  2.要停止动画，可以通过调用-removeAnimationForKey:@”rotate”这个函数从层上面移除动画
 *  3.注意动画过多出现界面卡顿的现象
 *  4.INT_MAX最大次数
 *  5.需要<QuartzCore/QuartzCore.h>框架支持
 *
 */


@interface FanAnimationToll : NSObject


#pragma mark - CATransition基本动画
/**动画切换页面的效果(CATransition)
 
 *此方法用于任意View的layer层上面
 *subType 方向 kCATransitionFromBottom ....
 *subtypes: kCAAnimationCubic迅速透明移动,cube 3D立方体翻页 pageCurl从一个角翻页，
 *          pageUnCurl反翻页，rippleEffect水波效果，suckEffect缩放到一个角,oglFlip中心立体翻转
 *          (kCATransitionFade淡出，kCATransitionMoveIn覆盖原图，kCATransitionPush推出，kCATransitionReveal卷轴效果)
 */
+(CATransition *)fan_transitionAnimationWithSubType:(NSString *)subType withType:(NSString *)xiaoguo duration:(CGFloat)duration;


#pragma mark - CABasicAnimation动画
/**永久闪烁的动画：动画时间（秒）*/
+(CABasicAnimation *)fan_opacityForever_Animation:(float)time;
/**有闪烁次数的动画:次数+动画时间（秒）*/
+(CABasicAnimation *)fan_opacityTimes_Animation:(float)repeatTimes durTimes:(float)time;
/**横向移动:移动距离(fromX--toX)+动画时间（秒）*/
+(CABasicAnimation *)fan_moveXWithTime:(float)time fromX:(float)fromX toX:(float)toX;
/**纵向移动:移动距离(fromY--toY)+动画时间（秒）*/
+(CABasicAnimation *)fan_moveYWithTime:(float)time fromY:(float)fromY toY:(float)toY;
/**点移动:移动的是偏移量*/
+(CABasicAnimation *)fan_movepoint:(CGPoint )point;
/**动画放大和缩小:放大倍数+动画次数 */
+(CABasicAnimation *)fan_scaleFrom:(float)multiple toMultiple:(float)toMultiple durTimes:(float)time Rep:(float)repeatTimes;
/**组合动画:动画时间+动画次数 */
+(CAAnimationGroup *)fan_groupAnimation:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes; //组合动画

/** 旋转绕Z轴
 
 * dur 时间
 * degree旋转角度
 * direction方向(0-1)
 * repeatCount次数
 */
+(CABasicAnimation *)fan_rotationTime:(float)dur degree:(float)degree directionZ:(float)directionZ repeatCount:(int)repeatCount;
/** 围绕三维坐标轴旋转（单个动画时间+3D)
 
 *第一个参数是旋转角度(pi/2正向，1.5pi逆向），后面三个参数形成一个围绕其旋转的向量(x,y,z)，起点位置由UIView的center属性标识。
 *CATransform3D t = CATransform3DMakeRotation(CGFloat angle, CGFloat x, CGFloat y, CGFloat z);
 */
+(CABasicAnimation *)fan_rotationTime:(float)dur transform3D:(CATransform3D)transform3D;

/**左右晃动:是偏移量移动*/
+(CABasicAnimation *)fan_rockWithTime:(float)time fromX:(float)fromX toX:(float)toX repeatCount:(int)repeatCount;
/**上下晃动:是偏移量移动*/
+(CABasicAnimation *)fan_rockWithTime:(float)time fromY:(float)fromY toY:(float)toY repeatCount:(int)repeatCount;
/**点晃动:是点移动*/
+(CABasicAnimation *)fan_rockWithTime:(float)time fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint repeatCount:(int)repeatCount;
#pragma mark - CAKeyframeAnimation动画
/**路径动画（点的移动，圆，曲线）
 
 *path 路径
 *time 持续的时间
 *repeatTimes 重复的次数
 */
+(CAKeyframeAnimation *)fan_keyframeAniamtion:(CGMutablePathRef)path durTimes:(float)time Rep:(float)repeatTimes; //路径动画
/// 左右摇晃，抖动角度
/// @param shakeDegress 抖动左偏移角度（0-360）
/// @param sigleDuration 单次抖动时间
/// @param repeatCount 执行次数 HUGE_VALF
+(CAKeyframeAnimation * )fan_shakeAnimationDegress:(float)shakeDegress sigleDuration:(float)sigleDuration repeatCount:(float)repeatCount;
/**贝塞尔路径动画（曲线）*/
+(CAKeyframeAnimation *)fan_bezierPathAniamtion:(UIBezierPath *)bezierPath durTimes:(float)time Rep:(float)repeatTimes;

#pragma mark - 其他辅佐方法
/**快速获得视图相对屏幕的坐标*/
+ (CGRect)fan_relativeFrameForScreenWithView:(UIView *)v;


@end
