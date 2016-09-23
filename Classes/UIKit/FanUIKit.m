//
//  FanUIKit.m
//  FanKit
//
//  Created by 向阳凡 on 16/7/4.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import "FanUIKit.h"

@implementation FanUIKit


#pragma mark - UITextView,Label文本高度
+ (CGFloat)fan_measureHeightOfUITextView:(UITextView *)fanTextView andLineSpace:(NSInteger)lineSpace{
    if (!fanTextView.text.length) {
        return 0;
    }
    __weak UITextView *textView = fanTextView;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        CGRect frame = textView.bounds;
        
        // Take account of the padding added around the text.
        
        UIEdgeInsets textContainerInsets = textView.textContainerInset;
        UIEdgeInsets contentInsets = textView.contentInset;
        //除去左右边框的值，lineFragmentPadding左右边距，其他是contentSize的内容偏移量
        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
        
        frame.size.width -= leftRightPadding;
        frame.size.height -= topBottomPadding;
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //考虑换行的影响(以后待修改）
        //[paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];//考虑换行的影响
        [paragraphStyle setLineBreakMode:textView.textContainer.lineBreakMode];
        if (lineSpace) {
            paragraphStyle.maximumLineHeight = textView.font.pointSize+lineSpace;
            paragraphStyle.minimumLineHeight = textView.font.pointSize+lineSpace;
        }
        
        NSDictionary *attributes = @{ NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle };
        
        textView.attributedText=[[NSAttributedString alloc]initWithString:textView.text attributes:attributes];
        
        CGRect size = [textView.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        
        return ceilf(CGRectGetHeight(size) + topBottomPadding);
    }else{
        return textView.contentSize.height;
    }
}
/** 根据文本的内容，计算字符串的大小
 *  根据换行方式和字体的大小，已经计算的范围来确定字符串的size
 */
+(CGSize)fan_currentSizeWithContent:(NSString *)content font:(UIFont *)font cgSize:(CGSize)cgsize{
//    CGFloat version=[[UIDevice currentDevice].systemVersion floatValue];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];

    CGSize size=[content boundingRectWithSize:cgsize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    //计算size， 7之后有新的方法
//    if (version>=7.0) {
//        //得到一个设置字体属性的字典
//        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
//        //optinos 前两个参数是匹配换行方式去计算，最后一个参数是匹配字体去计算
//        //attributes 传入的字体
//        //boundingRectWithSize 计算的范围
//        size=[content boundingRectWithSize:cgsize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
//    }else{
//        //ios7以前
//        //根据字号和限定范围还有换行方式计算字符串的size，label中的font 和linbreak要与此一致
//        //CGSizeMake(215, 999) 横向最大计算到215，纵向Max999
//        size=[content sizeWithFont:font constrainedToSize:cgsize lineBreakMode:NSLineBreakByCharWrapping];
//    }
    return size;
}
#pragma mark - 字节个数
+(NSUInteger) fan_unicodeLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}
#pragma mark - 颜色转化From:#FD87ED To:UIColor
+ (UIColor *)fan_colorFromHexColor:(NSString *)hexColor{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}
/** 等比例缩放图片到指定大小
 
 *  CGSize  :   缩放后的大小
 *  return  :   更改后的图片对象
 */
+(UIImage*)fan_scalImage:(UIImage *)sourceImage scalingForSize:(CGSize)targetSize{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor){
            scaleFactor = widthFactor; // scale to fit height
        }else{
            scaleFactor = heightFactor; // scale to fit width
        }
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if (widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    //把图片画在等比例的区域内
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    if ( scaledImage == nil ){
        NSLog(@"UIImageRetinal:could not scale image!!!");
        return nil;
    }
    UIGraphicsEndImageContext();
    return scaledImage;
}
/** 通过UIcolor获取一张图片 */
+ (UIImage *)fan_ImageWithColor:(UIColor *)color frame:(CGRect)rect{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
/** 截屏*/
+(UIImage*)fan_beginImageContext:(CGRect)rect fromView:(UIView*)view
{
    
    UIGraphicsBeginImageContext(view.frame.size); //currentView 当前的view
    //取得当前画布的上下文UIGraphicsGetCurrentContext  render渲染
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //从全屏中截取指定的范围
    CGImageRef imageRef = viewImage.CGImage;
    
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    
    /******截取图片保存的位置，如果想要保存，请把return向后移动*********/
    //    UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);
    //    CGImageRelease(imageRefRect);
    /***************/
    
    return sendImage;
}





/***************************************创建UI******************************************/

+(UILabel*)fan_createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text
{
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    //限制行数
    label.numberOfLines=0;
    //对齐方式
    label.textAlignment=NSTextAlignmentLeft;
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:font];
    //单词折行
    //    label.lineBreakMode=NSLineBreakByWordWrapping;
    //默认字体颜色是白色
    //    label.textColor=[UIColor blackColor];
    //自适应（行数~字体大小按照设置大小进行设置）
    //label.adjustsFontSizeToFitWidth=YES;
    label.text=text;
    return label;
}
+(UIButton*)fan_createButtonWithFrame:(CGRect)frame imageName:(NSString*)imageName target:(id)target action:(SEL)action title:(NSString*)title titleColor:(UIColor *)titleColor
{
    UIButton*button=[UIButton buttonWithType:UIButtonTypeSystem];
    button.frame=frame;
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    //设置背景图片，可以使文字与图片共存
    if (imageName) {
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    //图片与文字如果需要同时存在，就需要图片足够小 详见人人项目按钮设置
    // [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
+(UIButton*)fan_createButtonWithFrame:(CGRect)frame imageName:(NSString*)imageName target:(id)target action:(SEL)action
{
    return  [[self class] fan_createButtonWithFrame:frame imageName:imageName target:target action:action title:nil titleColor:nil];
}
+(UIButton*)fan_createButtonWithFrame:(CGRect)frame target:(id)target action:(SEL)action title:(NSString*)title titleColor:(UIColor *)titleColor
{
    return  [[self class] fan_createButtonWithFrame:frame imageName:nil target:target action:action title:title titleColor:titleColor];
}
+(UIImageView*)fan_createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName
{
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:frame];
    if (imageName) {
        imageView.image=[UIImage imageNamed:imageName];
    }
    imageView.userInteractionEnabled=YES;
    return imageView ;
}

+(UITextField*)fan_createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder leftImageView:(UIView*)imageView rightImageView:(UIView*)rightImageView Font:(float)font
{
    UITextField*textField=[[UITextField alloc]initWithFrame:frame];
    //灰色提示框
    textField.placeholder=placeholder;
    //文字对齐方式
    textField.textAlignment=NSTextAlignmentLeft;
    //    textField.secureTextEntry=YES;
    //边框
    //textField.borderStyle=UITextBorderStyleLine;
    //键盘类型
    textField.keyboardType=UIKeyboardTypeDefault;
    //关闭首字母大写
    textField.autocapitalizationType=NO;
    //清除按钮
    textField.clearButtonMode=YES;
    //左图片
    textField.leftView=imageView;
    textField.leftViewMode=UITextFieldViewModeAlways;
    //右图片
    textField.rightView=rightImageView;
    //编辑状态下一直存在
    textField.rightViewMode=UITextFieldViewModeWhileEditing;
    //自定义键盘
    //textField.inputView
    //字体
    textField.font=[UIFont systemFontOfSize:font];
    //字体颜色
    textField.textColor=[UIColor blackColor];
    return textField ;
}
+(UITextField*)fan_createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder Font:(float)font backgoundColor:(UIColor*)bgColor;
{
    UITextField*textField=[[UITextField alloc]initWithFrame:frame];
    //灰色提示框
    textField.placeholder=placeholder;
    //文字对齐方式
    textField.textAlignment=NSTextAlignmentLeft;
    //    textField.secureTextEntry=YES;
    //边框
    textField.borderStyle=UITextBorderStyleRoundedRect;
    //键盘类型
    textField.keyboardType=UIKeyboardTypeDefault;
    //关闭首字母大写
    textField.autocapitalizationType=NO;
    //清除按钮
    textField.clearButtonMode=YES;
    //自定义键盘
    //textField.inputView
    //字体
    textField.font=[UIFont systemFontOfSize:font];
    //字体颜色
    textField.textColor=[UIColor blackColor];
    if (bgColor) {
        textField.backgroundColor=bgColor;
    }
    return textField ;
}

+(UIScrollView*)fan_createScrollViewWithFrame:(CGRect)frame contentSize:(CGSize)size
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = size;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    return scrollView ;
}
+(UIPageControl*)fan_createPageControlWithFram:(CGRect)frame
{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:frame];
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    return pageControl;
}
+(UISlider*)fan_createSliderWithFrame:(CGRect)rect thumbImage:(NSString*)imageName
{
    UISlider *slider = [[UISlider alloc]initWithFrame:rect];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    [slider setThumbImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //    slider.maximumTrackTintColor = [UIColor grayColor];
    //    slider.minimumTrackTintColor = [UIColor blueColor];
    slider.continuous = YES;
    slider.enabled = YES;
    return slider ;
}
+(UISlider*)fan_createSliderWithFrame:(CGRect)rect thumbImage:(NSString*)imageName target:(id)target action:(SEL)action
{
    UISlider *slider = [[UISlider alloc]initWithFrame:rect];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    [slider setThumbImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [slider addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    slider.continuous = YES;
    slider.enabled = YES;
    return slider ;
}
+(UISwitch *)fan_createSwitchWithFrame:(CGRect)rect target:(nullable id)target action:(SEL)action{
    UISwitch *st=[[UISwitch alloc]initWithFrame:rect];
    [st addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    return st;
}

//+(NSString *)platformString{
//    // Gets a string with the device model
//    size_t size;
//    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
//    char *machine = malloc(size);
//    sysctlbyname("hw.machine", machine, &size, NULL, 0);
//    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
//    free(machine);
//    NSDictionary* d = nil;
//    if (d == nil)
//    {
//        d = @{
//              @"iPhone1,1": @"iPhone 2G",
//              @"iPhone1,2": @"iPhone 3G",
//              @"iPhone2,1": @"iPhone 3GS",
//              @"iPhone3,1": @"iPhone 4",
//              @"iPhone3,2": @"iPhone 4",
//              @"iPhone3,3": @"iPhone 4 (CDMA)",
//              @"iPhone4,1": @"iPhone 4S",
//              @"iPhone5,1": @"iPhone 5",
//              @"iPhone5,2": @"iPhone 5 (GSM+CDMA)",
//
//              @"iPod1,1": @"iPod Touch (1 Gen)",
//              @"iPod2,1": @"iPod Touch (2 Gen)",
//              @"iPod3,1": @"iPod Touch (3 Gen)",
//              @"iPod4,1": @"iPod Touch (4 Gen)",
//              @"iPod5,1": @"iPod Touch (5 Gen)",
//
//              @"iPad1,1": @"iPad",
//              @"iPad1,2": @"iPad 3G",
//              @"iPad2,1": @"iPad 2 (WiFi)",
//              @"iPad2,2": @"iPad 2",
//              @"iPad2,3": @"iPad 2 (CDMA)",
//              @"iPad2,4": @"iPad 2",
//              @"iPad2,5": @"iPad Mini (WiFi)",
//              @"iPad2,6": @"iPad Mini",
//              @"iPad2,7": @"iPad Mini (GSM+CDMA)",
//              @"iPad3,1": @"iPad 3 (WiFi)",
//              @"iPad3,2": @"iPad 3 (GSM+CDMA)",
//              @"iPad3,3": @"iPad 3",
//              @"iPad3,4": @"iPad 4 (WiFi)",
//              @"iPad3,5": @"iPad 4",
//              @"iPad3,6": @"iPad 4 (GSM+CDMA)",
//
//              @"i386": @"Simulator",
//              @"x86_64": @"Simulator"
//              };
//    }
//    NSString* ret = [d objectForKey: platform];
//
//    if (ret == nil)
//    {
//        return platform;
//    }
//    return ret;
//}

@end
