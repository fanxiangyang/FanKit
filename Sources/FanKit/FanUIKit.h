//
//  FanUIKit.h
//  FanKit
//
//  Created by 向阳凡 on 16/7/4.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FanUIKit : NSObject


#pragma mark - UITextView,Label文本高度
/** 根据TextView动态控制高度并返回高度
 *  lineSpace:行间距
 */
+ (CGFloat)fan_measureHeightOfUITextView:(nullable UITextView *)fanTextView andLineSpace:(NSInteger)lineSpace;
/** 根据文本的内容，计算字符串的大小
 *  根据换行方式和字体的大小，已经计算的范围来确定字符串的size
 */
+(CGSize)fan_textSizeWithMaxSize:(CGSize)maxSize text:(nullable NSString *)text font:(nullable UIFont *)font;
/**
 返回限定内的字体宽高
 
 @param maxSize 限定宽高
 @param text 文本
 @param font 字体
 @param lineSpace 行间距
 @param wordSpace 字间距
 @return 文本宽高
 */
+(CGSize)fan_textSizeWithMaxSize:(CGSize)maxSize text:(nullable NSString *)text font:(nullable UIFont *)font lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace;

/**
 修改Label的行间距和字间距
 
 @param label label
 @param lineSpace 行间距,<=0 不设置
 @param wordSpace 字间距,<=0 不设置
 */
+(void)fan_changeSpaceFromlabel:(nullable UILabel *)label lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace;
/// 获取HTML富文本
/// @param htmlStr html
/// @param font 字体
/// @param lineSpace 行间距
+(nullable NSMutableAttributedString*)fan_htmlAttributedString:(nullable NSString *)htmlStr font:(nullable UIFont *)font lineSpace:(CGFloat)lineSpace;
/// 计算HTML文本的宽高
/// @param maxSize 限定Size
/// @param htmlStr HTML字符串
/// @param font 字体
/// @param lineSpace 行间距 <0不设置默认好像大概10
+(CGSize)fan_htmlTextSizeWithMaxSize:(CGSize)maxSize html:(nullable NSString *)htmlStr font:(nullable UIFont *)font lineSpace:(CGFloat)lineSpace;

/// 根据HTML富文本获取宽高
/// @param maxSize 限定宽高
/// @param attributedString 富文本
+(CGSize)fan_attributTextSizeWithMaxSize:(CGSize)maxSize attributedString:(nullable NSAttributedString *)attributedString;
#pragma mark - 字节个数
/** 字节个数 */
+(NSUInteger) fan_unicodeLengthOfString: (nullable NSString *) text;
#pragma mark - 颜色转化From:#FD87ED To:UIColor
/** 颜色转化From:#FD87ED To:UIColor */
+ (nullable UIColor *)fan_colorFromHexColor:(nullable NSString *)hexColor;
///color转换成hex字符串'ff0088'没有 alpha
+(nullable NSString *)fan_hexFromColor:(nullable UIColor *)rgbColor;
///color转换成rgb字典 @{@"r":@(1.0),@"g":@(1.0),@"b":@(1.0),@"a":@(1.0)}
+(nullable NSDictionary *)fan_rgbDicFromColor:(nullable UIColor *)rgbColor;
#pragma mark - 图片的处理
/** 等比例缩放图片到指定大小
 *  CGSize  :   缩放后的大小
 *  return  :   更改后的图片对象
 */
+(nullable UIImage*)fan_scalImage:(nullable UIImage *)sourceImage scalingForSize:(CGSize)targetSize;
///等比适配到固定大小里面(图片不超过maxsize)
/// @param sourceImage 图片
/// @param maxSize 最大边的尺寸
+(nullable UIImage*)fan_scalImage:(nullable UIImage *)sourceImage scaleAspectFitSize:(CGSize)maxSize;
/// 不变形裁剪图片
/// @param image 图片
/// @param size 图片View的控件大小
/// @param rect 相对于图片View的裁剪框尺寸
/// @param isOval 是否是圆形
+(nullable UIImage *)fan_clipImage:(nullable UIImage *)image imageViewSize:(CGSize)size clipRect:(CGRect)rect isOval:(BOOL)isOval;
/** 通过UIcolor获取一张图片 */
+ (nullable UIImage *)fan_imageWithColor:(nullable UIColor *)color frame:(CGRect)rect;
/** 通过UIcolor获取一张图片圆角 */
+ (nullable UIImage *)fan_imageWithColor:(nullable UIColor *)color frame:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;
/** 截屏View*/
+(nullable UIImage*)fan_beginImageContextView:(nullable UIView*)view;
/** 一倍截屏*/
+(nullable UIImage*)fan_beginImageContext:(CGRect)rect fromView:(nullable UIView*)view;
/** Layer动画的View或者Metal渲染的，或者视频播放器截图*/
+ (nullable UIImage *)fan_snapshotLayerImage:(nullable UIView *)view;
/** 高斯模糊*/
+ (nullable UIImage *)fan_gaussianBlurImage:(nullable UIImage *)image;
/** 没有白边的高斯模糊 blur 1-100 */
+(nullable UIImage *)fan_accelerateBlurWithImage:(nullable UIImage *)image blurNumber:(CGFloat)blur;
/** 没有白边的高斯模糊（解决发红情况） blur 1-100 (最好1-25)*/
+(nullable UIImage *)fan_accelerateBlurShortWithImage:(nullable UIImage *)image blurNumber:(CGFloat)blur;
+(nullable UIVisualEffectView *)fan_addBlurEffectToView:(nullable UIView *)toView;//添加毛玻璃
+(nullable UIVisualEffectView *)fan_addBlurEffectWithStyle:(UIBlurEffectStyle)style toView:(nullable UIView *)toView effectCornerRadius:(CGFloat)cornerRadius;
/** 拉伸图片，边缘不拉伸，图片的一半*/
+(nullable UIImage *)fan_stretchableImage:(nullable UIImage *)image;
/// 拉伸最好
/// @param image 图片
/// @param edgeInset 占长宽的百分比
+(nullable UIImage *)fan_stretchableImage:(nullable UIImage *)image edgeInset:(UIEdgeInsets)edgeInset;
/** 添加阴影*/
+(void)fan_addShadowToView:(nullable UIView *)shadowView shadowColor:(nullable UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowOffset:(CGSize)shadowOffset;
///添加阴影，路径，注意frame
+(void)fan_addShadowToView:(nullable UIView *)shadowView shadowColor:(nullable UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowOffset:(CGSize)shadowOffset shadowBounds:(CGRect)shadowBounds;
/**
 添加阴影
 
 @param shadowView shadowView
 @param shadowColor 阴影颜色
 @param shadowOpacity 阴影透明度最好0.5+(建议1.0)
 @param shadowOffset 偏移量
 @param shadowRadius 圆角
 @param corners 圆角类型
 */
+(void)fan_addShadowToView:(nullable UIView *)shadowView shadowColor:(nullable UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius byRoundingCorners:(UIRectCorner)corners;
/***************************************创建UI******************************************/
#pragma mark --创建Label
+(nullable UILabel*)fan_createLabelWithFrame:(CGRect)frame text:(nullable NSString*)text textColor:(nullable UIColor *)textColor;
+(nullable UILabel*)fan_createLabelWithFrame:(CGRect)frame Font:(int)font Text:(nullable NSString*)text;
#pragma mark --创建imageView
+(nullable UIImageView*)fan_createImageViewWithFrame:(CGRect)frame ImageName:(nullable NSString*)imageName;
//主要图片
+(nullable UIImageView*)fan_createImageViewWithBundleFrame:(CGRect)frame imageBundleName:(nullable NSString*)imageName;

#pragma mark --创建button
+(nullable UIButton*)fan_createButtonWithFrame:(CGRect)frame imageName:(nullable NSString*)imageName target:(nullable id)target action:(nullable SEL)action;
+(nullable UIButton*)fan_createButtonWithFrame:(CGRect)frame target:(nullable id)target action:(nullable SEL)action title:(nullable NSString*)title titleColor:(nullable UIColor *)titleColor;
+(nullable UIButton*)fan_createButtonWithFrame:(CGRect)frame imageName:(nullable NSString*)imageName target:(nullable id)target action:(nullable SEL)action title:(nullable NSString*)title titleColor:(nullable UIColor *)titleColor;
#pragma mark --创建UITextField
+(nullable UITextField*)fan_createTextFieldWithFrame:(CGRect)frame placeholder:(nullable NSString*)placeholder Font:(float)font backgoundColor:(nullable UIColor*)bgColor;
+(nullable UITextField*)fan_createTextFieldWithFrame:(CGRect)frame placeholder:(nullable NSString*)placeholder leftImageView:(nullable UIView*)imageView rightImageView:(nullable UIView*)rightImageView Font:(float)font;

#pragma mark 创建UIScrollView
+(nullable UIScrollView*)fan_createScrollViewWithFrame:(CGRect)frame contentSize:(CGSize)size;
#pragma mark 创建UIPageControl
+(nullable UIPageControl*)fan_createPageControlWithFram:(CGRect)frame;
#pragma mark 创建UISlider
+(nullable UISlider*)fan_createSliderWithFrame:(CGRect)rect thumbImage:(nullable NSString*)imageName;
+(nullable UISlider*)fan_createSliderWithFrame:(CGRect)rect thumbImage:(nullable NSString*)imageName target:(nullable id)target action:(nullable SEL)action;
#pragma mark 创建UISwitch
+(nullable UISwitch *)fan_createSwitchWithFrame:(CGRect)rect target:(nullable id)target action:(nullable SEL)action;

#pragma mark 创建UIViewController
///根据view取到父类VC
+(nullable UIViewController *)fan_viewControllerFrom:(nullable UIView *)view;
///取到最顶层present的VC
+(nullable UIViewController *)fan_presentedViewController:(nullable UIViewController *)viewController;
//移除tag值的View
+(void)fan_removeViewTag:(NSInteger)tag fromeView:(nullable UIView *)view;
+(nullable id)fan_classFromName:(nullable NSString *)aClassName;
#pragma mark 创建手势和其他
+(void)fan_addTapGestureTarget:(nullable id)target action:(nullable SEL)action toView:(nullable UIView *)tapView;

#pragma mark UIWindow相关
/// 获取keywindow
+(nullable UIWindow *)fan_keyWindow;
///获取活跃的windowScene
+(nullable UIWindowScene*)fan_activeWindowScene API_AVAILABLE(ios(13.0));
/// 适配screen
+(nullable UIScreen *)fan_mainScreen;


/***************************************创建UI  End******************************************/
@end
