//
//  FanShowView.h
//  FanShowView
//
//  Created by 向阳凡 on 16/1/13.
//  Copyright © 2016年 凡向阳. All rights reserved.
//



/**
 
 *  注意：可以重写此类，自定义显示和动画
    1.需重写文本区域self.fan_contentView: -(void)configUIWithData（包含动画）
    3.重写消失动画方法 : -(void)removeSelfView;
    4.事件响应代理要调用：-(void)showViewDidSeletedIndex:(NSInteger)seletedIndex;
    5.最后一点，别忘记执行:[super **];
 
 *
 *
 *
 *
 */


#import <UIKit/UIKit.h>

/**屏幕宽*/
#define kFanScreenWidth_Show ([UIScreen mainScreen].bounds.size.width)
/**屏幕高*/
#define kFanScreenHeight_Show ([UIScreen mainScreen].bounds.size.height)

/**
 *  显示风格
 */
typedef NS_ENUM(NSInteger,FanShowViewStyle) {
    /**
     *  none
     */
    FanShowViewStyleNone=1,
    /**
     *  alert
     */
    FanShowViewStyleAlert,
    /**
     *  actionSheet
     */
    FanShowViewStyleActionSheet,
    /**
     *  底部分享
     */
    FanShowViewStyleShare
};


@class FanShowView;
@protocol FanShowViewDelegate <NSObject>

@optional
-(void)fanShowView:(FanShowView *) showView buttonIndex:(NSInteger)buttonIndex viewStyle:(FanShowViewStyle)viewStyle;

//@optional
//-(void)fanShowView:(FanShowView *) showView cancle:(NSInteger)cancle viewStyle:(FanShowViewStyle)viewStyle;

@end

@interface FanShowView : UIView

/** 内容View*/
@property(nonatomic,strong)UIView *fan_cententView;
/**黑色背景透明度 默认0.5  default translucent(0.5)*/
@property(nonatomic,assign)CGFloat blackAlpha;//不要设置为>0.1，不立即释放

@property(nonatomic,assign)FanShowViewStyle showViewStyle;

//@property(nonatomic,weak)id /*<FanShowViewDelegate>*/ delegate;
@property(nonatomic,weak)id delegate;

@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,assign)CGFloat contentHeight;
/**是不是触摸其他区域，自动消失*/
@property(nonatomic,assign)BOOL isTouchRemove;

#pragma mark - 外部调用方法
//弹出界面
//+(instancetype)showViewWithStyle:(FanShowViewStyle)style dataArray:(id)dataArray delegate:(id<FanShowViewDelegate>)delegate;
//+(instancetype)createShowViewWithStyle:(FanShowViewStyle)style;
-(instancetype)initWithStyle:(FanShowViewStyle)style;
-(void)show;

#pragma mark - 一般内部调用方法（或子类重写）
-(void)configUIWithData;//创建UI,需要重写
-(void)removeSelfView;//移除View，可以加动画移除
-(void)refreshUIWithData:(id)data;//暂时没有用（空方法）


-(void)showViewDidSeletedIndex:(NSInteger)seletedIndex;//用来选中按钮回调
-(void)shareBtnClick:(UIButton*)btn;//按钮单击事件，tag-100


#pragma mark - 辅助方法
/** 根据换行方式和字体的大小，已经计算的范围来确定字符串的size */
+(CGSize)currentSizeWithContent:(NSString *)content attributes:(NSDictionary *)attributes cgSize:(CGSize)cgsize;
/**动画切换页面的效果(CATransition)
 *subType 方向 kCATransitionFromBottom ....
 *subtypes: kCAAnimationCubic迅速透明移动,cube 3D立方体翻页 pageCurl从一个角翻页，
 *          pageUnCurl反翻页，rippleEffect水波效果，suckEffect缩放到一个角,oglFlip中心立体翻转
 *          (kCATransitionFade淡出，kCATransitionMoveIn覆盖原图，kCATransitionPush推出，kCATransitionReveal卷轴效果)
 */
+(CATransition *)fan_transitionAnimationWithSubType:(NSString *)subType withType:(NSString *)xiaoguo duration:(CGFloat)duration;
@end
