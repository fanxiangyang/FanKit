//
//  FanLockNodeView.h
//  
//
//  Created by 向阳凡 on 15/7/2.
//
//

#import <UIKit/UIKit.h>

/**
 *  界面状态
 */
typedef NS_ENUM(NSUInteger, FanLockNodeViewState) {
    /**
     *  正常
     */
    FanLockNodeViewStateNormal=1,
    /**
     *  错误警告
     */
    FanLockNodeViewStateWarning,
    /**
     *  被选中节点时
     */
    FanLockNodeViewStateSelected,
    /**
     *  选中成功时
     */
    FanLockNodeViewStateSuccess
};


@interface FanLockNodeView : UIView

/**
 *  节点状态
 */
@property(nonatomic,assign)FanLockNodeViewState nodeViewState;
/**
 *  外圈圆空心
 */
@property (nonatomic, strong)CAShapeLayer *outlineLayer;
/**
 *  内圈圆实心
 */
@property (nonatomic, strong)CAShapeLayer *innerCircleLayer;
/**
 *  圆圈线条颜色
 */
@property(nonatomic,strong)UIColor *strokeColor;

@end
