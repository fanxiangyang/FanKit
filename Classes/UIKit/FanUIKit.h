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
+ (CGFloat)fan_measureHeightOfUITextView:(UITextView *)fanTextView andLineSpace:(NSInteger)lineSpace;
/** 根据文本的内容，计算字符串的大小
 *  根据换行方式和字体的大小，已经计算的范围来确定字符串的size
 */
+(CGSize)fan_textSizeWithMaxSize:(CGSize)maxSize text:(NSString *)text font:(UIFont *)font;
/**
 返回限定内的字体宽高
 
 @param maxSize 限定宽高
 @param text 文本
 @param font 字体
 @param lineSpace 行间距
 @param wordSpace 字间距
 @return 文本宽高
 */
+(CGSize)fan_textSizeWithMaxSize:(CGSize)maxSize text:(NSString *)text font:(UIFont *)font lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace;

/**
 修改Label的行间距和字间距
 
 @param label label
 @param lineSpace 行间距,<=0 不设置
 @param wordSpace 字间距,<=0 不设置
 */
+(void)fan_changeSpaceFromlabel:(UILabel *)label lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace;
/// 获取HTML富文本
/// @param htmlStr html
/// @param font 字体
/// @param lineSpace 行间距
+(NSMutableAttributedString*)fan_htmlAttributedString:(NSString *)htmlStr font:(UIFont *)font lineSpace:(CGFloat)lineSpace;
/// 计算HTML文本的宽高
/// @param maxSize 限定Size
/// @param htmlStr HTML字符串
/// @param font 字体
/// @param lineSpace 行间距 <0不设置默认好像大概10
+(CGSize)fan_htmlTextSizeWithMaxSize:(CGSize)maxSize html:(NSString *)htmlStr font:(UIFont *)font lineSpace:(CGFloat)lineSpace;

/// 根据HTML富文本获取宽高
/// @param maxSize 限定宽高
/// @param attributedString 富文本
+(CGSize)fan_attributTextSizeWithMaxSize:(CGSize)maxSize attributedString:(NSAttributedString *)attributedString;
#pragma mark - 字节个数
/** 字节个数 */
+(NSUInteger) fan_unicodeLengthOfString: (NSString *) text;
#pragma mark - 颜色转化From:#FD87ED To:UIColor
/** 颜色转化From:#FD87ED To:UIColor */
+ (UIColor *)fan_colorFromHexColor:(NSString *)hexColor;
///color转换成hex字符串'ff0088'没有 alpha
+(NSString *)fan_hexFromColor:(UIColor *)rgbColor;
///color转换成rgb字典 @{@"r":@(1.0),@"g":@(1.0),@"b":@(1.0),@"a":@(1.0)}
+(NSDictionary *)fan_rgbDicFromColor:(UIColor *)rgbColor;
#pragma mark - 图片的处理
/** 等比例缩放图片到指定大小
 *  CGSize  :   缩放后的大小
 *  return  :   更改后的图片对象
 */
+(UIImage*)fan_scalImage:(UIImage *)sourceImage scalingForSize:(CGSize)targetSize;
/// 不变形裁剪图片
/// @param image 图片
/// @param size 图片View的控件大小
/// @param rect 相对于图片View的裁剪框尺寸
/// @param isOval 是否是圆形
+(UIImage *)fan_clipImage:(UIImage *)image imageViewSize:(CGSize)size clipRect:(CGRect)rect isOval:(BOOL)isOval;
/** 通过UIcolor获取一张图片 */
+ (UIImage *)fan_imageWithColor:(UIColor *)color frame:(CGRect)rect;
/** 通过UIcolor获取一张图片圆角 */
+ (UIImage *)fan_imageWithColor:(UIColor *)color frame:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;
/** 截屏*/
+(UIImage*)fan_beginImageContext:(CGRect)rect fromView:(UIView*)view;
/** OpenGL的View或者Metal渲染的，或者视频播放器截图*/
+ (UIImage *)fan_openglSnapshotImage:(UIView *)openGLView;
/** 高斯模糊*/
+ (UIImage *)fan_gaussianBlurImage:(UIImage *)image;
/** 没有白边的高斯模糊 blur 1-100 */
+(UIImage *)fan_accelerateBlurWithImage:(UIImage *)image blurNumber:(CGFloat)blur;
/** 没有白边的高斯模糊（解决发红情况） blur 1-100 (最好1-25)*/
+(UIImage *)fan_accelerateBlurShortWithImage:(UIImage *)image blurNumber:(CGFloat)blur;
+(UIVisualEffectView *)fan_addBlurEffectToView:(UIView *)toView;//添加毛玻璃
+(UIVisualEffectView *)fan_addBlurEffectWithStyle:(UIBlurEffectStyle)style toView:(UIView *)toView effectCornerRadius:(CGFloat)cornerRadius;
/** 拉伸图片，边缘不拉伸，图片的一半*/
+(UIImage *)fan_stretchableImage:(UIImage *)image;
/// 拉伸最好
/// @param image 图片
/// @param edgeInset 占长宽的百分比
+(UIImage *)fan_stretchableImage:(UIImage *)image edgeInset:(UIEdgeInsets)edgeInset;
/** 添加阴影*/
+(void)fan_addShadowToView:(UIView *)shadowView shadowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowOffset:(CGSize)shadowOffset;
///添加阴影，路径，注意frame
+(void)fan_addShadowToView:(UIView *)shadowView shadowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowOffset:(CGSize)shadowOffset shadowBounds:(CGRect)shadowBounds;
/**
 添加阴影
 
 @param shadowView shadowView
 @param shadowColor 阴影颜色
 @param shadowOpacity 阴影透明度最好0.5+(建议1.0)
 @param shadowOffset 偏移量
 @param shadowRadius 圆角
 @param corners 圆角类型
 */
+(void)fan_addShadowToView:(UIView *)shadowView shadowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius byRoundingCorners:(UIRectCorner)corners;
/***************************************创建UI******************************************/
#pragma mark --创建Label
+(UILabel*)fan_createLabelWithFrame:(CGRect)frame text:(NSString*)text textColor:(UIColor *)textColor;
+(UILabel*)fan_createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text;
#pragma mark --创建imageView
+(UIImageView*)fan_createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName;
//主要图片
+(UIImageView*)fan_createImageViewWithBundleFrame:(CGRect)frame imageBundleName:(NSString*)imageName;

#pragma mark --创建button
+(UIButton*)fan_createButtonWithFrame:(CGRect)frame imageName:(NSString*)imageName target:(id)target action:(SEL)action;
+(UIButton*)fan_createButtonWithFrame:(CGRect)frame target:(id)target action:(SEL)action title:(NSString*)title titleColor:(UIColor *)titleColor;
+(UIButton*)fan_createButtonWithFrame:(CGRect)frame imageName:(NSString*)imageName target:(id)target action:(SEL)action title:(NSString*)title titleColor:(UIColor *)titleColor;
#pragma mark --创建UITextField
+(UITextField*)fan_createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder Font:(float)font backgoundColor:(UIColor*)bgColor;
+(UITextField*)fan_createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder leftImageView:(UIView*)imageView rightImageView:(UIView*)rightImageView Font:(float)font;

#pragma mark 创建UIScrollView
+(UIScrollView*)fan_createScrollViewWithFrame:(CGRect)frame contentSize:(CGSize)size;
#pragma mark 创建UIPageControl
+(UIPageControl*)fan_createPageControlWithFram:(CGRect)frame;
#pragma mark 创建UISlider
+(UISlider*)fan_createSliderWithFrame:(CGRect)rect thumbImage:(NSString*)imageName;
+(UISlider*)fan_createSliderWithFrame:(CGRect)rect thumbImage:(NSString*)imageName target:(id)target action:(SEL)action;
#pragma mark 创建UISwitch
+(UISwitch *)fan_createSwitchWithFrame:(CGRect)rect target:(id)target action:(SEL)action;

#pragma mark 创建UIViewController
///根据view取到父类VC
+(UIViewController *)fan_viewControllerFrom:(UIView *)view;
///取到最顶层present的VC
+(UIViewController *)fan_presentedViewController:(UIViewController *)viewController;
//移除tag值的View
+(void)fan_removeViewTag:(NSInteger)tag fromeView:(UIView *)view;
+(id)fan_classFromName:(NSString *)aClassName;
#pragma mark 创建手势和其他
+(void)fan_addTapGestureTarget:(id)target action:(SEL)action toView:(UIView *)tapView;
/***************************************创建UI  End******************************************/
@end
