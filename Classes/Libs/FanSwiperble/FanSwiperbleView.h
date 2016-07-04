//
//  FanSwiperbleView.h
//  
//
//  Created by 向阳凡 on 15/8/24.
//
//

#import <UIKit/UIKit.h>

#define kFanWidth  ([UIScreen mainScreen].bounds.size.width)
#define kFanHeight ([UIScreen mainScreen].bounds.size.height)

typedef NS_ENUM(NSUInteger, FanSwipeableViewDirection) {
    FanSwipeableViewDirectionNone = 0,
    FanSwipeableViewDirectionLeft = (1 << 0),
    FanSwipeableViewDirectionRight = (1 << 1),
    FanSwipeableViewDirectionHorizontal = FanSwipeableViewDirectionLeft |
    FanSwipeableViewDirectionRight,
    FanSwipeableViewDirectionUp = (1 << 2),
    FanSwipeableViewDirectionDown = (1 << 3),
    FanSwipeableViewDirectionVertical = FanSwipeableViewDirectionUp |
    FanSwipeableViewDirectionDown,
    FanSwipeableViewDirectionAll = FanSwipeableViewDirectionHorizontal |
    FanSwipeableViewDirectionVertical,
};
@class FanSwiperbleView;

@protocol FanSwipeableViewDelegate <NSObject>
@optional
-(void)fan_swipeableView:(FanSwiperbleView *)swiperbleView leaveView:(id<UIDynamicItem>)leaveView;
@end

@protocol FanSwipeableViewDataSource <NSObject>

@required
- (UIView *)nextViewForSwipeableView:(FanSwiperbleView *)swipeableView;

@end

@interface FanSwiperbleView : UIView
@property (nonatomic, weak) IBOutlet id<FanSwipeableViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<FanSwipeableViewDelegate> delegate;
/**
 *  方向
 */ 
@property (nonatomic,assign) FanSwipeableViewDirection direction;
/**
 *  推出速度的幅度
 */
@property (nonatomic,assign) CGFloat pushVelocityMagnitude;
/**
 *  视图开始的中心坐标（用于动画效果）
 */
@property(nonatomic,assign)CGPoint beginCenter;
/**
 *  旋转角度（默认5）
 */
@property (nonatomic) float rotationDegree;
/**
 *  view 滚动边界
 */
@property (nonatomic) CGRect collisionRect;


/**
 *  重新刷新数据
 */
-(void)fan_reloadData;
/**
 *  移除所有View
 */
- (void)fan_discardAllSwipeableViews;
//离开方向
- (void)fan_swipeTopViewToLeft ;
- (void)fan_swipeTopViewToRight ;
- (void)fan_swipeTopViewToUp ;
- (void)fan_swipeTopViewToDown ;
@end
