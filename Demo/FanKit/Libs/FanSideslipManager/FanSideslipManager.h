//
//  FanSideslipManager.h
//  QQSlide
//
//  Created by 向阳凡 on 15/6/6.
//  Copyright (c) 2015年 向阳凡. All rights reserved.
//



/** 类似QQ的侧滑
 
 *介绍： 本侧滑用单例类封装，可以传人任意你想传的RootView上面，甚至是Window，使用及其简单，只有一个函数就可以搞定
        其中添加与移除手势是为了实现只在主界面侧滑，二级push页面关闭侧滑使用
 *用法： FanLeftViewController *leftVC=[FanLeftViewController new];
        FanTabBarController *tabBarVC=[FanTabBarController new];
        [[FanSideslipManager shareInstance]fan_sideslipInitWithRootView:self.view leftViewcontroller:leftVC rightViewController:rightVC mainViewController:tabBarVC];
 *手势：-(void)viewDidAppear:(BOOL)animated{
            [super viewDidAppear:animated];
            [[FanSideslipManager shareInstance] fan_addPanGesture];
        }
        -(void)viewWillDisappear:(BOOL)animated{
            [super viewWillDisappear:animated];
            [[FanSideslipManager shareInstance] fan_removePanGesture];
        }
 *
 *注意： 1.fan_fullDistance要大于fan_proportion，且设置比例最好大于0.6，建议在0.7以上
        2.如果主视图是导航视图，记得隐藏主导航的navgationBar,不然会有距离偏差
 *更新1.0：添加右视图及代理
        1.添加右视图，及右视图的优化
        2.左右视图可以根据需要传入，不需要时传入nil，
        3.添加delegate，如果不想使用左右视图，直接使用底层视图时，可以用代理控制底层View上控件的显隐与移动
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FanUIKit.h"

#define ScreenWidth_Sides ([[FanUIKit fan_mainScreen] bounds].size.width)
#define ScreenHeight_Sides ([[FanUIKit fan_mainScreen] bounds].size.height)

/** 1.表示滑动的方向 2.表示只是左滑动，右滑动，不滑动 */
typedef NS_ENUM(NSInteger, FanSideslipDirection) {
    FanSideslipDirectionLeft = 0,//只支持左滑动
    FanSideslipDirectonRight,    //只支持右滑动
    FanSideslipDirectionCetenr,  //不支持滑动
    FanSideslipDirectionAll      //左右滑动
};
#pragma mark - 添加滑动的代理，在滑动过程中可以回调给界面，处理其他
@class FanSideslipManager;
@protocol FanSideslipManagerDelegate <NSObject>

@optional
-(void)fanSideslipManager:(FanSideslipManager *)sideslipManager panGuesture:(UIPanGestureRecognizer *)pan;

@end

@interface FanSideslipManager : NSObject<UIGestureRecognizerDelegate>

#pragma mark - 外界传过来的视图及view
/** 侧滑的底RootView 不可为nil*/
@property(nonatomic,strong)UIView *fan_rootView;
/** 左视图控制器 可以为nil */
@property(nonatomic,strong)UIViewController *fan_leftViewController;
/** 右视图控制器 可以为nil */
@property(nonatomic,strong)UIViewController *fan_rightViewController;
/** 主视图控制器 (可以是viewController,navgationController,tabBarController) 不能为空 */
@property(nonatomic,strong)UIViewController *fan_mainViewController;



#pragma mark - 可选修改的属性
/** 左视图偏移量，默认0  可以为负 */
@property(nonatomic,assign)CGFloat fan_leftOffSet;
/** 右视图偏移量，默认0 可以为负 */
@property(nonatomic,assign)CGFloat fan_rightOffSet;
/** 中心视图缩放比例最小值,默认0.77 */
@property(nonatomic,assign)CGFloat fan_proportion;
/** 满屏视图缩放比例最小值,默认0.78 */
@property(nonatomic,assign)CGFloat fan_fullDistance;
/** 左视图缩放比例显示时,默认1.0 */
@property(nonatomic,assign)CGFloat fan_proportionOfLeftView;
/** 支持的滑动方向,默认左右都滑动 */
@property(nonatomic,assign)FanSideslipDirection fan_sideslipDerection;




#pragma mark - 内部使用属性（最好不要修改）
/** 底部的view，所有view都在他上面 */
@property(nonatomic,strong)UIView *fan_mainView;
/** 背景黑色遮盖层，增强视觉效果 */
@property(nonatomic,strong)UIView *fan_blackCoverView;
/** 滑动的实时距离,默认0.0 */
@property(nonatomic,assign)CGFloat fan_distance;
/** 左视图中心坐标 */
@property(nonatomic,assign)CGPoint fan_centerOfLeftViewAtBeginning;
/** 右视图中心坐标 */
@property(nonatomic,assign)CGPoint fan_centerOfRightViewAtBeginning;
/** 左视图偏移量，默认通过fan_fullDistance的缩放比例计算 */
@property(nonatomic,assign)CGFloat fan_distanceOfLeftView;
/** 单击手势 */
@property(nonatomic,strong)UITapGestureRecognizer *fan_tapGesture;
/** 侧滑手势 */
@property(nonatomic,strong)UIPanGestureRecognizer *fan_panGesture;
#pragma mark - 代理属性
@property(nonatomic,weak)id<FanSideslipManagerDelegate>delegate;


#pragma mark - FanSideslipManager方法
//MARK:- 单例
/** 侧滑手势的单例 */
+(FanSideslipManager *)shareInstance;
//MARK:- 实现侧滑的初始化方法
/** 初始化侧滑手势 */
-(void)fan_sideslipInitWithRootView:(UIView *)rootView leftViewcontroller:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController mainViewController:(UIViewController *)mainViewController;
/** 移除侧滑手势 */
-(void)fan_removePanGesture;
/** 添加侧滑手势 */
-(void)fan_addPanGesture;
//MARK:- 外部按钮控制侧滑
/** 展示左视图 */
-(void)fan_showLeft;
/** 展示右视图 */
-(void)fan_showRight;
/** 展示主视图 */
-(void)fan_showHome;
@end
