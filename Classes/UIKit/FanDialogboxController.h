//
//  FanDialogboxController.h
//  Brain
//
//  Created by 向阳凡 on 2020/6/15.
//  Copyright © 2020 向阳凡. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  显示风格
 */
typedef NS_ENUM(NSInteger,FanDialogboxStyle) {
    /**
     *  Txt
     */
    FanDialogboxStyleText=1,
    /**
     *  loding
     */
    FanDialogboxStyleLoding,
    
    /**
     *  带字体的加载
     */
    FanDialogboxStyleLodingText,
    /**
     *  alert
     */
    FanDialogboxStyleAlert,
    /**
     *  alertIcon
     */
    FanDialogboxStyleIconAlert,
    /**
     *  单行确认框
     */
    FanDialogboxStyleShotAlert,
    /**
     *  单行输入框
     */
    FanDialogboxStyleInput,
    /**
     *  倒计时
     */
    FanDialogboxStyleCountdown,
    /**
     *  提示时使用
     */
    FanDialogboxStyleTips
};

typedef void(^FanDialogboxAlertBlock)(NSInteger index);


@interface FanDialogboxController : UIViewController
//+(UIWindow *_Nullable)fan_alertWindow;
#pragma mark - 外部不能修改或者不建议修改的，在继承类里面可以修改的
/** 内容View*/
@property(nullable,nonatomic,strong)UIView * fan_cententView;//弹窗内容View
@property(nullable,nonatomic,strong)UIImageView *cententBgmView;//中间区域背景
@property(nonatomic,assign)CGFloat contentWidth;
@property(nonatomic,assign)CGFloat contentHeight;

@property(nonatomic,assign)FanDialogboxStyle dialogboxStyle;

@property(nullable,nonatomic,copy)FanDialogboxAlertBlock alertBlock;
@property(nonatomic,assign)NSInteger showType;//0-确认 1-错误
///按钮数组标题
@property(nullable,nonatomic,strong)NSArray * buttonTitleArray;
//这三个还没有改变值
@property(nullable,nonatomic,copy)NSString * alertTitle;
@property(nullable,nonatomic,copy)NSString * subTitle;
@property(nullable,nonatomic,copy)NSString * iconName;
//UI
@property(nullable,nonatomic,strong)UILabel *textLabel;//主要一个Label
@property(nullable,nonatomic,strong)UILabel *subTextLabel;//子label
@property(nullable,nonatomic,strong)UIButton *cancleButton;//取消按钮
@property(nullable,nonatomic,strong)UIButton *confirmButton;//确认按钮

#pragma mark - 外部可以修改属性
@property(nullable,nonatomic,strong)UIView * blackAlphaView;//黑色背景透明遮罩(黑色半透明默认)
/**是不是触摸其他区域，自动消失 默认NO */
@property(nonatomic,assign)BOOL isTouchRemove;
///是否主动触发按钮移除(默认=YES)
@property(nonatomic,assign)BOOL isAutoRemove;

@property(nonatomic,assign)BOOL isAnimation;//废弃：是否渐进动画出现和消失
///弹窗本身的key值，用来移除弹窗用
@property(nullable,nonatomic,copy)NSString *numKey;




#pragma mark - 做一些函数响应式编程处理属性更快捷

-(instancetype)addTouchRemove:(BOOL)isRemove;
-(instancetype)addAutoRemove:(BOOL)isAuto;
-(instancetype)addNumKey:(nullable NSString *)numKey;


///存放弹窗，加入key值才能添加进去，添加后可以通过key值移除
+(nullable NSMutableDictionary<NSString*,FanDialogboxController*> * )fan_dialogDictionary;


#pragma mark -  显示和隐藏的类方法
/**
 弹出提示对话框

 @param message 提示文本
 @return self
 */
+ (instancetype)fan_showDialogMessage:(nullable NSString*)message  fromVC:(nullable UIViewController*)vc;
+ (instancetype)fan_showDialogMessage:(nullable NSString *)message afterDelay:(NSTimeInterval)seconds  fromVC:(nullable UIViewController*)vc;

/**
 弹出加载等待框

 @return self
 */
+ (instancetype)fan_showDialogLodingFromVC:(nullable UIViewController*)vc;
+ (instancetype)fan_showDialogLodingText:(nullable NSString *)textStr fromVC:(nullable UIViewController*)vc;
+ (instancetype)fan_showDialogLodingText:(nullable NSString *)textStr afterDelay:(NSTimeInterval)seconds fromVC:(nullable UIViewController*)vc;
/**
 隐藏弹窗

 @return YES
 */
+ (BOOL)fan_hideDialogWithKey:(nullable NSString*)key;
+ (BOOL)fan_hideAllDialog;


/**
 弹窗类似系统对话框-双按钮

 @param textStr 标题
 @param subTitle 文本内容
 @param btnTitleArray 按钮数组最多2个
 @param alertBlock 按钮回调
 @return self
 */
+ (instancetype)fan_showAlertTitle:(nullable NSString *)textStr subTitle:(nullable NSString *)subTitle buttonTitles:(nullable NSArray*)btnTitleArray fromVC:(nullable UIViewController*)vc alertBlock:(nullable FanDialogboxAlertBlock)alertBlock;
///弹窗对话框，单按钮
+ (instancetype)fan_showAlertTitle:(nullable NSString *)textStr subTitle:(nullable NSString *)subTitle buttonTitle:(nullable NSString *)buttonTitle fromVC:(nullable UIViewController*)vc alertBlock:(nullable FanDialogboxAlertBlock)alertBlock;
/**
 弹窗Icon类似系统对话框-多按钮

 @param textStr 标题
 @param imageName 图标名称
 @param btnTitleArray 按钮数组最多2个
 @param alertBlock 按钮回调
 @return self
 */
+ (instancetype )fan_showIconAlertTitle:(nullable NSString *)textStr imageName:(nullable NSString *)imageName buttonTitles:(nullable NSArray*)btnTitleArray fromVC:(nullable UIViewController*)vc alertBlock:(nullable FanDialogboxAlertBlock)alertBlock;
///弹窗icon对话框，单按钮
+ (instancetype)fan_showIconAlertTitle:(nullable NSString *)textStr imageName:(nullable NSString *)imageName buttonTitle:(nullable NSString *)buttonTitle fromVC:(nullable UIViewController*)vc alertBlock:(nullable FanDialogboxAlertBlock)alertBlock;


#pragma mark - 修改内容属性
-(void)fan_setTitleColor:(nullable UIColor *)titleColor subTitleColor:(nullable UIColor *)subTitleColor;

-(void)fan_setTitleColor:(nullable UIColor *)titleColor;
#pragma mark - 子类可以重写
- (void)commonInit;//继承要执行父类方法
-(void)configUIWithData;
-(void)fan_configUI;//子类重写
-(void)fan_createTextUI;
-(void)fan_createLodingUI;
-(void)fan_createAlertUI;
-(void)fan_createIconAlertUI;


#pragma mark - 子类调用的方法
+(UIViewController *)fan_presentedViewController:(UIViewController *)viewController;
-(CGSize)fan_currentSizeWithContent:(nullable NSString *)content font:(nullable UIFont *)font cgSize:(CGSize)cgsize;


@end

NS_ASSUME_NONNULL_END
