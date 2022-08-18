//
//  FanProgressHUD.h
//  FanProgressHUD
//
//  Created by 向阳凡 on 2017/9/26.
//  Copyright © 2017年 向阳凡. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  显示风格
 */
typedef NS_ENUM(NSInteger,FanProgressHUDStyle) {
    /**
     *  Txt
     */
    FanProgressHUDStyleText=1,
    /**
     *  loding
     */
    FanProgressHUDStyleLoding,
   
    /**
     *  带字体的加载
     */
    FanProgressHUDStyleLodingText,
    /**
     *  alert
     */
    FanProgressHUDStyleAlert,
    /**
     *  alertIcon
     */
    FanProgressHUDStyleIconAlert,
    /**
     *  单行确认框
     */
    FanProgressHUDStyleShotAlert,
    /**
     *  单行输入框
     */
    FanProgressHUDStyleInput,
    /**
     *  倒计时
     */
    FanProgressHUDStyleCountdown,
    /**
     *  特殊
     */
    FanProgressHUDStyleTips,
    /**
     *  自定义view
     */
    FanProgressHUDStyleCustomeView
};


typedef void(^FanProgressHUDAlertBlock)(NSInteger index);
/// 返回回调 0-返回
typedef void(^FanProgressHUDBackBlock)(NSInteger backType);

@interface FanProgressHUD : UIView
#pragma mark - 外部不能修改或者不建议修改的，在继承类里面可以修改的
/** 内容View*/
@property(nullable,nonatomic,strong)UIView *fan_cententView;
@property(nullable,nonatomic,strong)UIImageView *cententBgmView;//中间区域背景
@property(nonatomic,assign)CGFloat contentWidth;
@property(nonatomic,assign)CGFloat contentHeight;

@property(nonatomic,assign)FanProgressHUDStyle progressHUDStyle;
/// 按钮回调
@property(nonatomic,nullable,copy)FanProgressHUDAlertBlock alertBlock;
///返回消失回调
@property(nonatomic,nullable,copy)FanProgressHUDBackBlock backBlock;
/** 显示几秒后，消失*/
@property (assign, nonatomic) NSTimeInterval showTime;
@property(nullable, nonatomic,strong)NSArray *buttonTitleArray;

#pragma mark - 外部可以修改属性
@property(nonatomic,nullable,strong)UIView * blackAlphaView;//修改背景颜色
@property(nonatomic,nullable,strong)NSMutableArray * dataArray;
/**是不是触摸其他区域，自动消失*/
@property(nonatomic,assign)BOOL isTouchRemove;

//
@property(nonatomic,nullable,copy)NSString * title;
@property(nonatomic,nullable,copy)NSString * subTitle;
@property(nonatomic,nullable,copy)NSString * iconName;
@property(nonatomic,nullable,strong)UILabel *textLabel;
@property(nonatomic,nullable,strong)UILabel *subTitleLabel;
@property(nonatomic,nullable,strong)UIImageView *iconImgView;
@property(nonatomic,nullable,strong)UITextField *textField;


//获取keywindow(后期如果适配UIScene需要改动)
+(nullable UIWindow *)showKeyWindow;

#pragma mark -  显示和隐藏的类方法
/**
 弹出提示对话框
 
 @param textStr 提示文本
 @return self
 */
+ (instancetype _Nullable)fan_showHUDWithStatus:(nullable NSString*)textStr;
+ (instancetype _Nullable)fan_showHUDWithStatus:(nullable NSString *)textStr afterDelay:(NSTimeInterval)seconds;

/**
 弹出加载等待框

 @return self
 */
+ (instancetype _Nullable)fan_showProgressHUD;
+ (instancetype _Nullable)fan_showProgressHUDToView:(nullable UIView *)view;
+ (instancetype _Nullable)fan_showProgressHUD:(nullable NSString *)textStr;
+ (instancetype _Nullable)fan_showProgressHUDToView:(nullable UIView *)view title:(nullable NSString *)textStr;
+ (instancetype _Nullable)fan_showProgressHUD:(nullable NSString *)textStr afterDelay:(NSTimeInterval)seconds;
/**
 隐藏弹窗

 @return YES
 */
+ (BOOL)fan_hideProgressHUD;
+ (BOOL)fan_hideAllProgressHUD;
+ (BOOL)fan_hideProgressHUDForView:(nullable UIView *)view;
+ (instancetype _Nullable )fan_progressHUDForView:(nullable UIView *)view;
+ (BOOL)fan_hideAllProgressHUDForView:(nullable UIView *)view;


/**
 弹窗类似系统对话框

 @param textStr 标题
 @param subTitle 文本内容
 @param btnTitleArray 按钮数组最多2个
 @param alertBlock 按钮回调
 @return self
 */
+ (instancetype _Nullable)fan_showAlertHUDTitle:(nullable NSString *)textStr subTitle:(nullable NSString *)subTitle buttonTitles:(nullable NSArray*)btnTitleArray  alertBlock:(nullable FanProgressHUDAlertBlock)alertBlock;
+ (instancetype _Nullable)fan_showAlertHUDTitle:(nullable NSString *)textStr subTitle:(nullable NSString * )subTitle buttonTitle:(nullable NSString *)buttonTitle alertBlock:(nullable FanProgressHUDAlertBlock)alertBlock;
/**
 弹窗类似系统对话框
 
 @param textStr 标题
 @param imageName 图标名称
 @param btnTitleArray 按钮数组最多2个
 @param alertBlock 按钮回调
 @return self
 */
+ (instancetype _Nullable )fan_showIconAlertHUDTitle:(nullable NSString *)textStr imageName:(nullable NSString *)imageName buttonTitles:(nullable NSArray*)btnTitleArray  alertBlock:(nullable FanProgressHUDAlertBlock  )alertBlock;
+ (instancetype _Nullable )fan_showIconAlertHUDTitle:(nullable NSString *)textStr imageName:(nullable NSString *)imageName buttonTitle:(nullable NSString *)buttonTitle alertBlock:(nullable FanProgressHUDAlertBlock)alertBlock;


///现在没有动画，不用考虑传值
-(void)fan_removeSelfView:(BOOL)animation;


-(void)fan_setTitleColor:(nullable UIColor *)titleColor subTitleColor:(nullable UIColor *)subTitleColor;

-(void)fan_setTitleColor:(nullable UIColor *)titleColor;

#pragma mark - 子类可以重写
///初始化类调用
-(void)configUIWithData;
///所有UI的实现
-(void)fan_configUI;//子类重写
-(void)fan_createTextUI;
-(void)fan_createLodingUI;
-(void)fan_createAlertUI;
-(void)fan_createIconAlertUI;

#pragma mark - 子类调用的方法
-(void)buttonClick:(nullable UIButton *)btn;
- (id _Nullable )initWithShowView:(nullable UIView *)view;
- (void)commonInit;//继承要执行父类方法
@end
