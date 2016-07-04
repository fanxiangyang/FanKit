//
//  FanSideslipManager.m
//  QQSlide
//
//  Created by 向阳凡 on 15/6/6.
//  Copyright (c) 2015年 向阳凡. All rights reserved.
//

#import "FanSideslipManager.h"

@implementation FanSideslipManager

static FanSideslipManager *manager=nil;
+(FanSideslipManager *)shareInstance{
    if (manager==nil) {
        manager=[[FanSideslipManager alloc]init];
    }
    return manager;
}

-(instancetype)init{
    self=[super init];
    if (self) {
        _fan_leftOffSet=0.0;
        _fan_rightOffSet=0.0;
        _fan_distance=0.0;
        _fan_proportion=0.77;
        _fan_fullDistance=0.78;
        _fan_proportionOfLeftView=1.0;
        _fan_sideslipDerection=FanSideslipDirectionAll;
        _fan_distanceOfLeftView=ScreenWidth_Sides*(1-self.fan_fullDistance);
        _fan_panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(fan_pan:)];
        _fan_tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fan_showHome)];
    }
    return self;
}
-(void)fan_sideslipInitWithRootView:(UIView *)rootView leftViewcontroller:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController mainViewController:(UIViewController *)mainViewController{
    self.fan_leftViewController=leftViewController;
    self.fan_rightViewController=rightViewController;
    self.fan_rootView=rootView;
    self.fan_mainViewController=mainViewController;
    
    //    if (ScreenWidth_Sides>320) {
    //        self.fan_proportionOfLeftView=ScreenWidth_Sides/320.0;
    //        self.fan_distanceOfLeftView=(ScreenWidth_Sides-320.0)*self.fan_fullDistance/2;
    //    }
    if(leftViewController){
        leftViewController.view.center=CGPointMake(leftViewController.view.center.x-self.fan_distanceOfLeftView, leftViewController.view.center.y);
        //    leftViewController.view.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.fan_fullDistance,self.fan_fullDistance);
        self.fan_centerOfLeftViewAtBeginning=leftViewController.view.center;
        [rootView addSubview:leftViewController.view];
    }
    if(rightViewController){
        rightViewController.view.center=CGPointMake(rightViewController.view.center.x+self.fan_distanceOfLeftView, rightViewController.view.center.y);
        //    rightViewController.view.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        rightViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.fan_fullDistance,self.fan_fullDistance);
        self.fan_centerOfRightViewAtBeginning=rightViewController.view.center;
        [rootView addSubview:rightViewController.view];
    }
    // 增加黑色遮罩层，实现视差特效
    self.fan_blackCoverView=[[UIView alloc]initWithFrame:rootView.frame];
    self.fan_blackCoverView.backgroundColor=[UIColor blackColor];
    [rootView addSubview:self.fan_blackCoverView];
    self.fan_mainView=[[UIView alloc]initWithFrame:rootView.frame];
    [self.fan_mainView addSubview:mainViewController.view];
    if ([mainViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController=(UITabBarController *)mainViewController;
        [mainViewController.view bringSubviewToFront:tabBarController.tabBar];
    }
    [rootView addSubview:self.fan_mainView];
    [self.fan_mainView addGestureRecognizer:_fan_panGesture];
    
}

-(void)fan_sideslipInitWithRootView:(UIView *)rootView leftViewcontroller:(UIViewController *)leftViewController mainViewController:(UIViewController *)mainViewController{
    self.fan_leftViewController=leftViewController;
    self.fan_rootView=rootView;
    self.fan_mainViewController=mainViewController;
    
    //    if (ScreenWidth_Sides>320) {
    //        self.fan_proportionOfLeftView=ScreenWidth_Sides/320.0;
    //        self.fan_distanceOfLeftView=(ScreenWidth_Sides-320.0)*self.fan_fullDistance/2;
    //    }
    if(leftViewController){
        leftViewController.view.center=CGPointMake(leftViewController.view.center.x-self.fan_distanceOfLeftView, leftViewController.view.center.y);
        //    leftViewController.view.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.fan_fullDistance,self.fan_fullDistance);
        self.fan_centerOfLeftViewAtBeginning=leftViewController.view.center;
        [rootView addSubview:leftViewController.view];
    }
    
    // 增加黑色遮罩层，实现视差特效
    self.fan_blackCoverView=[[UIView alloc]initWithFrame:rootView.frame];
    self.fan_blackCoverView.backgroundColor=[UIColor blackColor];
    [rootView addSubview:self.fan_blackCoverView];
    self.fan_mainView=[[UIView alloc]initWithFrame:rootView.frame];
    [self.fan_mainView addSubview:mainViewController.view];
    if ([mainViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController=(UITabBarController *)mainViewController;
        [mainViewController.view bringSubviewToFront:tabBarController.tabBar];
    }
    [rootView addSubview:self.fan_mainView];
    [self.fan_mainView addGestureRecognizer:_fan_panGesture];
    
}

-(void)fan_pan:(UIPanGestureRecognizer *)pan{
    if (self.fan_sideslipDerection==FanSideslipDirectionCetenr) {
        return;
    }
    
    CGFloat x=[pan translationInView:self.fan_rootView].x;
    if(self.fan_mainView.center.x<self.fan_rootView.center.x){
        //向左滑动(只能右滑动时）
        if (self.fan_sideslipDerection==FanSideslipDirectionLeft) {
            [self fan_showHomeNOAnimation];
            return;
        }
    }else if(self.fan_mainView.center.x>self.fan_rootView.center.x){
        //向右滑动（只能左滑动时）
        if (self.fan_sideslipDerection==FanSideslipDirectonRight) {
            [self fan_showHomeNOAnimation];
            return;
        }        
    }else{
        if (self.fan_sideslipDerection==FanSideslipDirectionLeft&&x<0) {
            [self fan_showHomeNOAnimation];
            return;
        }
        if (self.fan_sideslipDerection==FanSideslipDirectonRight&&x>0) {
            [self fan_showHomeNOAnimation];
            return;
        }
        
    }
    //调用代理
    if (_delegate&&[_delegate respondsToSelector:@selector(fanSideslipManager:panGuesture:)]) {
        [_delegate fanSideslipManager:self panGuesture:pan];
    }
    
    //处理左右滑动时界面透明效果，取消重叠
    self.fan_leftViewController.view.alpha = self.fan_mainView.center.x<self.fan_rootView.center.x ? 0 : 1;
    self.fan_rightViewController.view.alpha = self.fan_mainView.center.x>self.fan_rootView.center.x ? 0 : 1;
//    NSLog(@"-----[距离：%f----%f]------", self.fan_mainView.center.x,self.fan_rootView.center.x);
//    CGFloat x=[pan translationInView:self.fan_rootView].x;
//    NSLog(@"-----[距离：%f]------",x);
    CGFloat trueDistance=self.fan_distance+x;//实时距离
    CGFloat trueProportion=trueDistance/(ScreenWidth_Sides*self.fan_fullDistance);
    // 如果 UIPanGestureRecognizer 结束，则激活自动停靠
    if (pan.state == UIGestureRecognizerStateEnded ){
        
        if (trueDistance > ScreenWidth_Sides* (self.fan_proportion / 3)) {
            [self fan_showLeft];
        }else if (trueDistance < ScreenWidth_Sides * -(self.fan_proportion / 3)) {
            [self fan_showRight];
        } else {
            [self fan_showHome];
        }
        return;
    }
    
    // 计算缩放比例
    CGFloat proportion= pan.view.frame.origin.x >= 0 ? -1 : 1;
    proportion *=trueDistance /ScreenWidth_Sides;
//     NSLog(@"-----[比例1：%f]------",proportion);
    proportion *= 1 - self.fan_proportion ;
    proportion /= self.fan_fullDistance + self.fan_proportion /2 - 0.5;
    proportion += 1.0;
    if (proportion <= self.fan_proportion) { // 若比例已经达到最小，则不再继续动画
        return;
    }
//    NSLog(@"-----[比例：%f]------",proportion);
   
    // 执行视差特效
    self.fan_blackCoverView.alpha = (proportion - self.fan_proportion) / (1 - self.fan_proportion);
//    // 执行平移和缩放动画
    pan.view.center = CGPointMake(self.fan_rootView.center.x + trueDistance, self.fan_rootView.center.y);
    pan.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
    
    // 执行左视图动画
    CGFloat pro = self.fan_fullDistance + (self.fan_proportionOfLeftView - self.fan_fullDistance) * trueProportion;
//    NSLog(@"-----[比例：%f]------",pro);
    if (self.fan_leftViewController) {
        self.fan_leftViewController.view.center = CGPointMake(self.fan_centerOfLeftViewAtBeginning.x + self.fan_distanceOfLeftView * trueProportion, self.fan_centerOfLeftViewAtBeginning.y - (self.fan_proportionOfLeftView - 1) * self.fan_leftViewController.view.frame.size.height * trueProportion / 2 );
        self.fan_leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, pro, pro);
    }
    if(self.fan_rightViewController){
        self.fan_rightViewController.view.center=CGPointMake(self.fan_centerOfRightViewAtBeginning.x - self.fan_distanceOfLeftView * trueProportion, self.fan_centerOfRightViewAtBeginning.y - (self.fan_proportionOfLeftView - 1) * self.fan_rightViewController.view.frame.size.height * trueProportion / 2);
        self.fan_rightViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.fan_proportion+self.fan_proportion*(1-pro),self.fan_proportion+self.fan_proportion*(1-pro));
    }

}
//展示左视图
-(void)fan_showLeft{
    [self.fan_mainView addGestureRecognizer:self.fan_tapGesture];
    self.fan_distance=self.fan_rootView.center.x*(self.fan_fullDistance*2+self.fan_proportion-1)+self.fan_leftOffSet;
    [self fan_sideslipAnimateScaleProportion:self.fan_proportion direction:FanSideslipDirectionLeft];
}
//展示右视图
-(void)fan_showRight{
    [self.fan_mainView addGestureRecognizer:self.fan_tapGesture];
    self.fan_distance=self.fan_rootView.center.x*(1-(self.fan_fullDistance*2+self.fan_proportion-1))+self.fan_rightOffSet;
    [self fan_sideslipAnimateScaleProportion:self.fan_proportion direction:FanSideslipDirectonRight];
}
//展示主视图
-(void)fan_showHome{
    [self.fan_mainView removeGestureRecognizer:self.fan_tapGesture];
    self.fan_distance=0.0;
    [self fan_sideslipAnimateScaleProportion:1.0 direction:FanSideslipDirectionLeft];
}

-(void)fan_sideslipAnimateScaleProportion:(CGFloat)scaleProportion direction:(FanSideslipDirection)direction{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.fan_mainView.center=CGPointMake(self.fan_rootView.center.x+self.fan_distance, self.fan_rootView.center.y);
        self.fan_mainView.transform= CGAffineTransformScale(CGAffineTransformIdentity, scaleProportion, scaleProportion);
        if (direction == FanSideslipDirectionLeft) {
            if (self.fan_leftViewController) {
                self.fan_leftViewController.view.center = CGPointMake(self.fan_centerOfLeftViewAtBeginning.x + self.fan_distanceOfLeftView, self.fan_leftViewController.view.center.y);
                self.fan_leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.fan_proportionOfLeftView, self.fan_proportionOfLeftView);
            }
        }
        else if(direction==FanSideslipDirectonRight){
            self.fan_rightViewController.view.center = CGPointMake(self.fan_centerOfRightViewAtBeginning.x + self.fan_distanceOfLeftView, self.fan_rightViewController.view.center.y);
            self.fan_rightViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.fan_proportionOfLeftView, self.fan_proportionOfLeftView);
        }
        self.fan_blackCoverView.alpha = direction == FanSideslipDirectionCetenr ? 1 : 0;
        self.fan_leftViewController.view.alpha = direction == FanSideslipDirectonRight ? 0 : 1;
        self.fan_rightViewController.view.alpha = direction == FanSideslipDirectionLeft ? 0 : 1;

        
    } completion:nil];
}
-(void)fan_showHomeNOAnimation{
    [self.fan_mainView removeGestureRecognizer:self.fan_tapGesture];
    self.fan_distance=0.0;
    self.fan_mainView.center=CGPointMake(self.fan_rootView.center.x+self.fan_distance, self.fan_rootView.center.y);
    self.fan_mainView.transform= CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    if (self.fan_sideslipDerection == FanSideslipDirectionLeft) {
        if (self.fan_leftViewController) {
            self.fan_leftViewController.view.center = CGPointMake(self.fan_centerOfLeftViewAtBeginning.x + self.fan_distanceOfLeftView, self.fan_leftViewController.view.center.y);
            self.fan_leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.fan_proportionOfLeftView, self.fan_proportionOfLeftView);
        }
    }
    else if(self.fan_sideslipDerection==FanSideslipDirectonRight){
        self.fan_rightViewController.view.center = CGPointMake(self.fan_centerOfRightViewAtBeginning.x + self.fan_distanceOfLeftView, self.fan_rightViewController.view.center.y);
        self.fan_rightViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.fan_proportionOfLeftView, self.fan_proportionOfLeftView);
    }
    self.fan_blackCoverView.alpha = self.fan_sideslipDerection == FanSideslipDirectionCetenr ? 1 : 0;
    self.fan_leftViewController.view.alpha = self.fan_sideslipDerection == FanSideslipDirectonRight ? 0 : 1;
    self.fan_rightViewController.view.alpha = self.fan_sideslipDerection == FanSideslipDirectionLeft ? 0 : 1;
}
-(void)fan_removePanGesture{
    [self.fan_mainView removeGestureRecognizer:self.fan_panGesture];
}
-(void)fan_addPanGesture{
    [self.fan_mainView addGestureRecognizer:self.fan_panGesture];
}
#pragma mark - get set
-(void)setFan_fullDistance:(CGFloat)fan_fullDistance{
    if (fan_fullDistance>0.6) {
        _fan_fullDistance=fan_fullDistance;
        if (fan_fullDistance<_fan_proportion) {
            _fan_fullDistance=_fan_proportion+0.01;
        }
    }else{
        _fan_fullDistance=0.78;
    }
}
-(void)setFan_proportion:(CGFloat)fan_proportion{
    if (fan_proportion>0.6) {
        _fan_proportion=fan_proportion;
    }else{
        _fan_proportion=0.77;
    }

}
-(void)setFan_sideslipDerection:(FanSideslipDirection)fan_sideslipDerection{
    if (fan_sideslipDerection==FanSideslipDirectionCetenr) {
        [self fan_removePanGesture];
    }
    _fan_sideslipDerection=fan_sideslipDerection;
}
@end
