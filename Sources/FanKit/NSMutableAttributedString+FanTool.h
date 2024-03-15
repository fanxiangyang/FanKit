//
//  NSMutableAttributedString+FanTool.h
//  FanKit
//
//  Created by 向阳凡 on 2024/03/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (FanTool)

/// 添加字体
/// - Parameter font: 字体
-(instancetype)fan_addFont:(UIFont *)font;
/// 添加字体颜色
/// - Parameter color: 字体颜色
-(instancetype)fan_addTextColor:(UIColor *)color;
/// 添加字体+颜色
/// - Parameters:
///   - font: 字体
///   - color: 颜色
-(instancetype)fan_addFont:(UIFont *)font textColor:(UIColor *)color;
///添加下划线
/// - Parameter lineStyle: 下划线风格 1=NSUnderlineStyleSingle
-(instancetype)fan_addUnderline:(NSUnderlineStyle)lineStyle;
/// 添加段落格式
-(instancetype)fan_addParagraphStyle:(NSMutableParagraphStyle *)paragraphStyle;

/// 追加富文本
-(instancetype)fan_appendString:(NSString*)text textFont:(UIFont *)textFont textColor:(UIColor *)textColor;

@end
///段落格式
@interface NSMutableParagraphStyle (CRTool)
///或者居中，靠左等 默认段落格式
+(instancetype)fan_paragraphStyleWithTextAlignment:(NSTextAlignment)textAlignment;

@end

@interface NSAttributedString (CRTool)
///获取限定size的字符宽高
-(CGSize)fan_stringSizeWithMax:(CGSize)maxSize;

@end

NS_ASSUME_NONNULL_END
