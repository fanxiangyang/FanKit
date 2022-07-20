//
//  FanAlertController.h
//  FanTest
//
//  Created by 向阳凡 on 2018/6/13.
//  Copyright © 2018年 向阳凡. All rights reserved.
//

//不支持多个提示覆盖的功能

#import <UIKit/UIKit.h>
/**
 *  显示风格
 */
typedef NS_ENUM(NSInteger,FanAlertControllerStyle) {
    /**
     *  Txt
     */
    FanAlertControllerStyleText=1,
    /**
     *  loding
     */
    FanAlertControllerStyleLoding,
    
    /**
     *  带字体的加载
     */
    FanAlertControllerStyleLodingText,
    /**
     *  alert
     */
    FanAlertControllerStyleAlert,
    /**
     *  alertIcon
     */
    FanAlertControllerStyleIconAlert,
    /**
     *  单行确认框
     */
    FanAlertControllerStyleShotAlert,
    /**
     *  单行输入框
     */
    FanAlertControllerStyleInput,
    /**
     *  倒计时
     */
    FanAlertControllerStyleCountdown,
    /**
     *  提示时使用
     */
    FanAlertControllerStyleTips
};

typedef void(^FanProgressHUDAlertBlock)(NSInteger index);

@interface FanAlertController : UIViewController
+(UIWindow *_Nullable)fan_alertWindow;
#pragma mark - 外部不能修改或者不建议修改的，在继承类里面可以修改的
/** 内容View*/
@property(nonatomic,strong)UIView * _Nullable fan_cententView;
@property(nullable,nonatomic,strong)UIImageView *cententBgmView;//中间区域背景
@property(nonatomic,assign)CGFloat contentWidth;
@property(nonatomic,assign)CGFloat contentHeight;

@property(nonatomic,assign)FanAlertControllerStyle progressHUDStyle;

@property(nonatomic,copy)FanProgressHUDAlertBlock _Nullable alertBlock;
/** 显示几秒后，消失*/
@property (assign, nonatomic) NSTimeInterval showTime;
@property(nonatomic,strong)NSArray * _Nullable buttonTitleArray;

#pragma mark - 外部可以修改属性
@property(nonatomic,strong)UIView * _Nullable blackAlphaView;
@property(nonatomic,strong)NSMutableArray * _Nullable dataArray;
/**是不是触摸其他区域，自动消失*/
@property(nonatomic,assign)BOOL isTouchRemove;

@property(nonatomic,assign)BOOL isAutoHidden;//是否自动隐藏界面 默认Yes

@property(nonatomic,copy)NSString * _Nullable alertTitle;
@property(nonatomic,copy)NSString * _Nullable subTitle;
@property(nonatomic,copy)NSString * _Nullable iconName;

#pragma mark -  显示和隐藏的类方法
/**
 弹出提示对话框
 
 @param textStr 提示文本
 @return self
 */
+ (instancetype _Nullable )fan_showHUDWithStatus:(NSString*_Nullable)textStr;
+ (instancetype _Nullable )fan_showHUDWithStatus:(NSString *_Nullable)textStr afterDelay:(NSTimeInterval)seconds;

/**
 弹出加载等待框
 
 @return self
 */
+ (instancetype _Nullable)fan_showProgressHUD;
+ (instancetype _Nullable)fan_showProgressHUD:(NSString *_Nullable)textStr;
+ (instancetype _Nullable)fan_showProgressHUD:(NSString *_Nullable)textStr afterDelay:(NSTimeInterval)seconds;
/**
 隐藏弹窗
 
 @return YES
 */
+ (BOOL)fan_hideProgressHUD;
//+ (BOOL)fan_hideAllProgressHUD;
//+ (BOOL)fan_hideAllProgressHUDForView:(UIView *)view;


/**
 弹窗类似系统对话框
 
 @param textStr 标题
 @param subTitle 文本内容
 @param btnTitleArray 按钮数组最多2个
 @param alertBlock 按钮回调
 @return self
 */
+ (instancetype _Nullable )fan_showAlertHUDTitle:(NSString *_Nullable)textStr subTitle:(NSString *_Nullable)subTitle buttonTitles:(NSArray*_Nullable)btnTitleArray  alertBlock:(FanProgressHUDAlertBlock _Nullable )alertBlock;
+ (instancetype _Nullable )fan_showAlertHUDTitle:(NSString *_Nullable)textStr subTitle:( NSString * _Nonnull )subTitle buttonTitle:(NSString *_Nullable)buttonTitle alertBlock:(FanProgressHUDAlertBlock _Nullable)alertBlock;
/**
 弹窗类似系统对话框
 
 @param textStr 标题
 @param imageName 图标名称
 @param btnTitleArray 按钮数组最多2个
 @param alertBlock 按钮回调
 @return self
 */
+ (instancetype _Nullable )fan_showIconAlertHUDTitle:(NSString *_Nullable)textStr imageName:(NSString *_Nonnull)imageName buttonTitles:(NSArray*_Nullable)btnTitleArray  alertBlock:(FanProgressHUDAlertBlock _Nullable )alertBlock;
+ (instancetype _Nullable )fan_showIconAlertHUDTitle:(NSString *_Nullable)textStr imageName:(NSString *_Nonnull)imageName buttonTitle:(NSString *_Nullable)buttonTitle alertBlock:(FanProgressHUDAlertBlock _Nullable)alertBlock;


-(void)fan_removeSelfView:(BOOL)animation;
#pragma mark - 修改内容属性
-(void)fan_setTitleColor:(UIColor *_Nullable)titleColor subTitleColor:(UIColor *_Nullable)subTitleColor;

-(void)fan_setTitleColor:(UIColor *_Nullable)titleColor;
#pragma mark - 子类可以重写
-(void)configUIWithData;
-(void)fan_configUI;//子类重写
-(void)fan_createTextUI;
-(void)fan_createLodingUI;
-(void)fan_createAlertUI;
-(void)fan_createIconAlertUI;


#pragma mark - 子类调用的方法

-(void)buttonClick:(UIButton *_Nullable)btn;
-(CGSize)fan_currentSizeWithContent:(NSString *_Nullable)content font:(UIFont *_Nullable)font cgSize:(CGSize)cgsize;
- (void)commonInit;//继承要执行父类方法

@end
