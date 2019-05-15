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
#pragma mark - 字节个数
/** 字节个数 */
+(NSUInteger) fan_unicodeLengthOfString: (NSString *) text;
#pragma mark - 颜色转化From:#FD87ED To:UIColor
/** 颜色转化From:#FD87ED To:UIColor */
+ (UIColor *)fan_colorFromHexColor:(NSString *)hexColor;
#pragma mark - 图片的处理
/** 等比例缩放图片到指定大小
 *  CGSize  :   缩放后的大小
 *  return  :   更改后的图片对象
 */
+(UIImage*)fan_scalImage:(UIImage *)sourceImage scalingForSize:(CGSize)targetSize;
/** 通过UIcolor获取一张图片 */
+ (UIImage *)fan_ImageWithColor:(UIColor *)color frame:(CGRect)rect;
/** 通过UIcolor获取一张图片圆角 */
+ (UIImage *)fan_ImageWithColor:(UIColor *)color frame:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;
/** 截屏*/
+(UIImage*)fan_beginImageContext:(CGRect)rect fromView:(UIView*)view;
/** OpenGL截图*/
+ (UIImage *)fan_openglSnapshotImage:(UIView *)openGLView;
/** 高斯模糊*/
+ (UIImage *)fan_gaussianBlurImage:(UIImage *)image;
/** 没有白边的高斯模糊 blur 1-100 */
+(UIImage *)fan_accelerateBlurWithImage:(UIImage *)image blurNumber:(CGFloat)blur;
/** 没有白边的高斯模糊（解决发红情况） blur 1-100 (最好1-25)*/
+(UIImage *)fan_accelerateBlurShortWithImage:(UIImage *)image blurNumber:(CGFloat)blur;
+(void)fan_addBlurEffectToView:(UIView *)toView;//添加毛玻璃
/** 拉伸图片，边缘不拉伸，图片的一半*/
+(UIImage *)fan_stretchableImage:(UIImage *)image;
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
+(UIViewController *)fan_viewControllerFrom:(UIView *)view;
//移除tag值的View
+(void)fan_removeViewTag:(NSInteger)tag fromeView:(UIView *)view;
+(id)fan_classFromName:(NSString *)aClassName;
#pragma mark 创建手势和其他
+(void)fan_addTapGestureTarget:(id)target action:(SEL)action toView:(UIView *)tapView;
/***************************************创建UI  End******************************************/

#pragma mark 返回设备类型

+(NSString *)fan_platformString;
@end
