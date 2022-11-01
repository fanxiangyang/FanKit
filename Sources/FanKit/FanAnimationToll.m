//
//  FanAnimationToll.m
//
//  Created by 凡向阳 on 15-2-9.
//  Copyright (c) 2015年 未名空间. All rights reserved.
//

#import "FanAnimationToll.h"
#import "FanUIKit.h"


@implementation FanAnimationToll

#pragma mark - CATransition基本动画
/**动画切换页面的效果(CATransition)
 *subType 方向 kCATransitionFromBottom ....
 *subtypes: kCAAnimationCubic迅速透明移动,cube 3D立方体翻页 pageCurl从一个角翻页，
 *          pageUnCurl反翻页，rippleEffect水波效果，suckEffect缩放到一个角,oglFlip中心立体翻转
 *          (kCATransitionFade淡出，kCATransitionMoveIn覆盖原图，kCATransitionPush推出，kCATransitionReveal卷轴效果)
 */
+(CATransition *)fan_transitionAnimationWithSubType:(NSString *)subType withType:(NSString *)xiaoguo duration:(CGFloat)duration
{
    CATransition *animation=[CATransition animation];
    //立体翻转的效果cube ,rippleEffect,(水波）
    [animation setType:xiaoguo];
    //设置动画方向
    [animation setSubtype:subType];
    //设置动画的动作时长
    [animation setDuration:duration];
    //均匀的作用效果
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    return animation;
}


#pragma mark - CABasicAnimation动画
/**永久闪烁的动画：动画时间（秒）*/
+(CABasicAnimation *)fan_opacityForever_Animation:(float)time 
{
    //提供了对单一动画的实现
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];//从真实的界面
    animation.toValue=[NSNumber numberWithFloat:0.0];//虚化度到0.0即0.0*100%
    animation.autoreverses=YES;
    animation.duration=time;
    animation.repeatCount=FLT_MAX;//1e100f   次数，最大
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}
/**有闪烁次数的动画:次数+动画时间（秒）
 
 *repeatTimes 重复的次数 time动画持续的时间
 */
+(CABasicAnimation *)fan_opacityTimes_Animation:(float)repeatTimes durTimes:(float)time; 
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:0.0];
    animation.repeatCount=repeatTimes;
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.autoreverses=YES;
    return  animation;
}
/**纵向移动:移动距离(fromX--toX)+动画时间（秒）
 
 *Y距离是原位置的偏移量可以为负
 */
+(CABasicAnimation *)fan_moveXWithTime:(float)time fromX:(float)fromX toX:(float)toX
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    [animation setFromValue:[NSNumber numberWithFloat:fromX]];
    animation.toValue=[NSNumber numberWithFloat:toX];
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}
/**纵向移动:移动距离(fromY--toY)+动画时间（秒）
 
 *Y距离是原位置的偏移量可以为负
 */
+(CABasicAnimation *)fan_moveYWithTime:(float)time fromY:(float)fromY toY:(float)toY
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
     [animation setFromValue:[NSNumber numberWithFloat:fromY]];
    animation.toValue=[NSNumber numberWithFloat:toY];
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}
/**点移动：偏移量*/
+(CABasicAnimation *)fan_movepoint:(CGPoint )point //点移动
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation"];
    animation.toValue=[NSValue valueWithCGPoint:point];
    animation.removedOnCompletion=NO;
    animation.duration = 1;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}
/**动画放大和缩小
 
 *
 *multiple 开始的倍数
 *toMultiple 结束的倍数
 *time 持续的时间
 *repeatTimes 重复的次数
 */
+(CABasicAnimation *)fan_scaleFrom:(float)multiple toMultiple:(float)toMultiple durTimes:(float)time Rep:(float)repeatTimes
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue=[NSNumber numberWithFloat:multiple];
    animation.toValue=[NSNumber numberWithFloat:toMultiple];
    animation.duration=time;
    animation.autoreverses=YES;//逆向动画，如果设置为NO,就不会逆向缩放回去了
    animation.repeatCount=repeatTimes;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}
/**组合动画:动画时间+动画次数 */
+(CAAnimationGroup *)fan_groupAnimation:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes //组合动画
{
    //CAAnimationGroup 允许多个动画同时播放
    CAAnimationGroup *animation=[CAAnimationGroup animation];
    animation.animations=animationAry;
    animation.duration=time;
    animation.repeatCount=repeatTimes;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}
/** 围绕Z轴旋转
 
 * dur 时间
 * degree旋转角度(逆时针旋转
 * direction方向
 * repeatCount次数
 */
+(CABasicAnimation *)fan_rotationTime:(float)dur degree:(float)degree directionZ:(float)directionZ repeatCount:(int)repeatCount
{
    //第一个参数是旋转角度，后面三个参数形成一个围绕其旋转的向量(x,y,z)，起点位置由UIView的center属性标识。
    CATransform3D rotationTransform  = CATransform3DMakeRotation(degree, 0, 0,directionZ);
    
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    animation.toValue= [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration= dur;
    animation.autoreverses= NO;
    animation.cumulative= YES;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.repeatCount= repeatCount;
//    animation.delegate = self;
    return animation;
}
/** 围绕三维坐标轴旋转（单个动画时间+3D)
 
 *第一个参数是旋转角度(pi/2正向，1.5pi逆向），后面三个参数形成一个围绕其旋转的向量((x,y,z):0-1)，起点位置由UIView的center属性标识。
 *CATransform3D t = CATransform3DMakeRotation(<#CGFloat angle#>, <#CGFloat x#>, <#CGFloat y#>, <#CGFloat z#>);
 */
+(CABasicAnimation *)fan_rotationTime:(float)dur transform3D:(CATransform3D)transform3D
{
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    animation.toValue= [NSValue valueWithCATransform3D:transform3D];
    animation.duration= dur;
    animation.autoreverses= NO;
    animation.cumulative= YES;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.repeatCount= INT_MAX;
//    animation.delegate= self;
    return animation;
}
/**左右晃动:是偏移量移动*/
+(CABasicAnimation *)fan_rockWithTime:(float)time fromX:(float)fromX toX:(float)toX repeatCount:(int)repeatCount
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    [animation setFromValue:[NSNumber numberWithFloat:fromX]];
    animation.toValue=[NSNumber numberWithFloat:toX];
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    
    animation.repeatCount=repeatCount;//动画重复次数
    animation.autoreverses=YES;//是否自动重复
    
    return animation;
}
/**上下晃动:是偏移量移动*/
+(CABasicAnimation *)fan_rockWithTime:(float)time fromY:(float)fromY toY:(float)toY repeatCount:(int)repeatCount
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animation setFromValue:[NSNumber numberWithFloat:fromY]];
    animation.toValue=[NSNumber numberWithFloat:toY];
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    
    animation.repeatCount=repeatCount;//动画重复次数
    animation.autoreverses=YES;//是否自动重复
    
    return animation;
}
/**点晃动:是点移动*/
+(CABasicAnimation *)fan_rockWithTime:(float)time fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint repeatCount:(int)repeatCount{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation"];
    [animation setFromValue:[NSValue valueWithCGPoint:fromPoint]];
    animation.toValue=[NSValue valueWithCGPoint:toPoint];
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    
    animation.repeatCount=repeatCount;//动画重复次数
    animation.autoreverses=YES;//是否自动重复
    return animation;
}
#pragma mark - CAKeyframeAnimation动画
/**左右摇晃,图标的抖动:抖动宽度(0-360)+强度(单次时间)*/
+(CAKeyframeAnimation * )fan_shakeAnimationDegress:(float)shakeDegress sigleDuration:(float)sigleDuration repeatCount:(float)repeatCount {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    [animation setDuration:sigleDuration];
    [animation setRepeatCount:repeatCount];
    float rand = (float)random();
    [animation setBeginTime:CACurrentMediaTime() + rand * .0000000001];
    NSMutableArray *values =[NSMutableArray array];
    [values addObject:[NSNumber numberWithFloat:0]];
    [values addObject:fan_DegreesToNumber(-shakeDegress)]; // Turn left
    [values addObject:fan_DegreesToNumber(shakeDegress)]; // Turn right
    [values addObject:fan_DegreesToNumber(0)];
    [animation setValues:values];
    return animation;
}
NSNumber*fan_DegreesToNumber(CGFloat degrees) {
    return [NSNumber numberWithFloat:degrees * M_PI / 180];
}
/**路径动画（点的移动，圆，曲线）
 
 *path 路径
 *time 持续的时间
 *repeatTimes 重复的次数
 */
+(CAKeyframeAnimation *)fan_keyframeAniamtion:(CGMutablePathRef)path durTimes:(float)time Rep:(float)repeatTimes //路径动画
{
    //CAKeyframeAnimation关键帧动画，可以定义行动的路线
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    //path demo1 4个角移动
    //    CGMutablePathRef path =CGPathCreateMutable();
    //    CGPathMoveToPoint(path,NULL,0, 64);
    //    CGPathAddLineToPoint(path,NULL, 320, 64);
    //    CGPathAddLineToPoint(path, NULL, 0, 480);
    //    CGPathAddLineToPoint(path, NULL, 320, 480);
    //    CGPathAddLineToPoint(path,NULL, 40, 40);
    //    CGPathCloseSubpath(path);
    
    //圆(路径，Null，圆心（x,y),半径，PI，NO）
    // CGPathAddArc(path, NULL, 100, 100, 100, 0, 6.28, NO);
    
    
    
    animation.path=path;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.autoreverses=NO;
    animation.duration=time;
    animation.repeatCount=repeatTimes;
    return animation;
}
//贝塞尔路径动画（曲线）
+(CAKeyframeAnimation *)fan_bezierPathAniamtion:(UIBezierPath *)bezierPath durTimes:(float)time Rep:(float)repeatTimes{
    //CAKeyframeAnimation关键帧动画，可以定义行动的路线
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.autoreverses=NO;
    animation.duration=time;
    animation.repeatCount=repeatTimes;
    animation.calculationMode = kCAAnimationPaced;
    //    CGMutablePathRef curvedPath = CGPathCreateMutable();
    //    CGPathAddPath(curvedPath, 0, bezierPath.CGPath);
    animation.path=bezierPath.CGPath;
    //    CGPathRelease(curvedPath);
    return animation;
}
#pragma mark - 其他辅助内容

//注意一：一个视图的layer添加动画后，必须移除动画后对视图的frame操作才会有效
//注意二：如何快速获得视图在屏幕上的相对坐标

/**
  *  计算一个view相对于屏幕(去除顶部statusbar的20像素)的坐标
  *  iOS7下UIViewController.view是默认全屏的，要把这20像素考虑进去
  */
+ (CGRect)fan_relativeFrameForScreenWithView:(UIView *)v
{
    BOOL iOS7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7;
    
    CGFloat screenHeight = [FanUIKit fan_mainScreen].bounds.size.height;
    if (!iOS7) {
        screenHeight -= 20;
    }
    UIView *view = v;
    CGFloat x = .0;
    CGFloat y = .0;
    while (view.frame.size.width != 320 || view.frame.size.height != screenHeight) {
        x += view.frame.origin.x;
        y += view.frame.origin.y;
        view = view.superview;
        if ([view isKindOfClass:[UIScrollView class]]) {
            x -= ((UIScrollView *) view).contentOffset.x;
            y -= ((UIScrollView *) view).contentOffset.y;
        }
    }
    return CGRectMake(x, y, v.frame.size.width, v.frame.size.height);
    
}

#pragma mark - 版本2.0动画
//+(CASpringAnimation *)fan_springAnimation{
//    
//    CASpringAnimation *springAnimation=[CASpringAnimation animationWithKeyPath:@"position"];
//    //springAnimation.mass=5;
//    springAnimation.duration=1;
//    springAnimation.stiffness=200;
//    springAnimation.damping=2;
//    //springAnimation.initialVelocity=20;
//    return springAnimation;
//}

@end
