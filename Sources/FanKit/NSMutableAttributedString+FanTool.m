//
//  NSMutableAttributedString+FanTool.h
//  FanKit
//
//  Created by 向阳凡 on 2024/03/15.
//

#import "NSMutableAttributedString+FanTool.h"

@implementation NSMutableAttributedString (FanTool)


/// 添加字体
/// - Parameter font: 字体
-(instancetype)fan_addFont:(UIFont *)font{
    if(font){
        [self addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    }
    return self;
}
/// 添加字体颜色
/// - Parameter color: 字体颜色
-(instancetype)fan_addTextColor:(UIColor *)color{
    if(color){
        [self addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.length)];
    }
    return self;
}

/// 添加字体+颜色
/// - Parameters:
///   - font: 字体
///   - color: 颜色
-(instancetype)fan_addFont:(UIFont *)font textColor:(UIColor *)color{
    if(font&&color){
        [self addAttributes:@{NSForegroundColorAttributeName : color,NSFontAttributeName:font} range:NSMakeRange(0, self.length)];
    }
    return self;
}
///添加下划线
/// - Parameter lineStyle: 下划线风格 1=NSUnderlineStyleSingle
-(instancetype)fan_addUnderline:(NSUnderlineStyle)lineStyle{
    [self addAttribute:NSUnderlineStyleAttributeName value:@(lineStyle) range:NSMakeRange(0, self.length)];
    return self;
}
/// 添加段落格式
-(instancetype)fan_addParagraphStyle:(NSMutableParagraphStyle *)paragraphStyle{
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    return self;
}
/// 追加富文本
-(instancetype)fan_appendString:(NSString*)text textFont:(UIFont *)textFont textColor:(UIColor *)textColor{
    if(text){
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc]init];
        if(textFont){
            [mDic setObject:textFont forKey:NSFontAttributeName];
        }
        if(textColor){
            [mDic setObject:textColor forKey:NSForegroundColorAttributeName];
        }
        [self appendAttributedString:[[NSAttributedString alloc]initWithString:text attributes:mDic]];
    }
    return self;
}
@end

///段落格式
@implementation  NSMutableParagraphStyle (FanTool)
///或者居中，靠左等 默认段落格式
+(instancetype)fan_paragraphStyleWithTextAlignment:(NSTextAlignment)textAlignment{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = textAlignment;
    return style;
}

@end


@implementation NSAttributedString (FanTool)

///获取限定size的字符宽高
-(CGSize)fan_stringSizeWithMax:(CGSize)maxSize{
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
}

@end
