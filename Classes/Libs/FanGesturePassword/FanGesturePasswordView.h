//
//  FanGestureView.h
//  
//
//  Created by 向阳凡 on 15/7/2.
//
//

#import <UIKit/UIKit.h>
#import "FanLockNodeView.h"

@class FanGesturePasswordView;

@protocol FanGesturePasswordViewDelegate <NSObject>

@optional
-(void)fanGesturePasswordView:(FanGesturePasswordView *)gesturePasswordView didEndDragWithPassword:(NSString *)password;

@end

#define iOS7_8_GP [[[UIDevice currentDevice] systemVersion]floatValue]>=7
#define kWidth_GP ([UIScreen mainScreen].bounds.size.width)
#define kHeight_GP ([UIScreen mainScreen].bounds.size.height)

@interface FanGesturePasswordView : UIView
/**
 *  存放节点的view数组
 */
@property(nonatomic,strong)NSMutableArray *nodeViewArray;
/**
 *  选中节点数组
 */
@property(nonatomic,strong)NSMutableArray *selectedNodeViewArray;
/**
 *  多边形线layer
 */
@property(nonatomic,strong)CAShapeLayer *polygonalLineLayer;
/**
 *  多边行的贝塞尔路径
 */
@property(nonatomic,strong)UIBezierPath *polygonalLinePath;
/**
 *  点数组
 */
@property(nonatomic,strong)NSMutableArray *pointArray;


/**
 *  手势密码的拖拽状态
 */
@property(nonatomic,assign)FanLockNodeViewState viewState;


@property(nonatomic,weak)id<FanGesturePasswordViewDelegate>delegate;

#pragma mark - 外部可修改的辅助属性
@property(nonatomic,strong)UIColor *fan_LineColor;


@end
