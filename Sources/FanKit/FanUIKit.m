//
//  FanUIKit.m
//  FanKit
//
//  Created by 向阳凡 on 16/7/4.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import "FanUIKit.h"
#import <Accelerate/Accelerate.h>

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
        //        paragraphStyle.lineSpacing=lineSpace;
        //考虑换行的影响(以后待修改）
        //[paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];//考虑换行的影响
        [paragraphStyle setLineBreakMode:textView.textContainer.lineBreakMode];
        if (lineSpace) {
            paragraphStyle.maximumLineHeight = textView.font.pointSize+lineSpace;
            paragraphStyle.minimumLineHeight = textView.font.pointSize+lineSpace;
        }
        
        NSDictionary *attributes = @{ NSFontAttributeName: textView.font,NSForegroundColorAttributeName:textView.textColor, NSParagraphStyleAttributeName : paragraphStyle };
        
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
+(CGSize)fan_textSizeWithMaxSize:(CGSize)maxSize text:(NSString *)text font:(UIFont *)font{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size=[text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}
+(CGSize)fan_textSizeWithMaxSize:(CGSize)maxSize text:(NSString *)text font:(UIFont *)font lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace{
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    
    if (lineSpace>0.0f) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing=lineSpace;
        //考虑换行的影响(以后待修改）
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];//考虑换行的影响
        [dic setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    }
    if (wordSpace>0.0f) {
        //字间距
        [dic setObject:@(wordSpace) forKey:NSKernAttributeName];
    }
    CGSize size=[text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    return size;
}
+(void)fan_changeSpaceFromlabel:(UILabel *)label lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace{
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString=[label.attributedText mutableCopy];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    if (lineSpace>0.0f) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing=lineSpace;
        //考虑换行的影响(以后待修改）
        //        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];//考虑换行的影响
        [paragraphStyle setLineBreakMode:label.lineBreakMode];
        
        [dic setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    }
    if (wordSpace>0.0f) {
        //字间距
        [dic setObject:@(wordSpace) forKey:NSKernAttributeName];
    }
    [attributedString addAttributes:dic range:NSMakeRange(0, labelText.length)];
    
    label.attributedText = attributedString;
    [label sizeToFit];
}
+(NSMutableAttributedString*)fan_htmlAttributedString:(NSString *)htmlStr font:(UIFont *)font lineSpace:(CGFloat)lineSpace{
    NSMutableAttributedString *htmlString =[[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:NULL error:nil];
    [htmlString addAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0, htmlString.length)];
    //设置行间距
    if (lineSpace>0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];
        [htmlString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [htmlString length])];
    }
    return htmlString;
}
+(CGSize)fan_htmlTextSizeWithMaxSize:(CGSize)maxSize html:(NSString *)htmlStr font:(UIFont *)font lineSpace:(CGFloat)lineSpace{
    NSMutableAttributedString *htmlString =[[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:NULL error:nil];
    [htmlString addAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0, htmlString.length)];
    //设置行间距
    if (lineSpace>0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];
        [htmlString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [htmlString length])];
    }
    //NSStringDrawingTruncatesLastVisibleLine
    CGSize size = [htmlString boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return size;
}
+(CGSize)fan_attributTextSizeWithMaxSize:(CGSize)maxSize attributedString:(NSAttributedString *)attributedString{
    //NSStringDrawingTruncatesLastVisibleLine
    CGSize size = [attributedString boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
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
///color转换成hex字符串'ff0088'没有 alpha
+(NSString *)fan_hexFromColor:(UIColor *)rgbColor{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    BOOL success = [rgbColor getRed:&red green:&green blue:&blue alpha:&alpha];
    if (success) {
        NSString *rgb=[NSString stringWithFormat:@"#%02x%02x%02x",(int)(red*255.0),(int)(green*255.0),(int)(blue*255.0)];
        return rgb;
    }
    return @"ffffff";
}
///color转换成rgb字典 @{@"r":@(1.0),@"g":@(1.0),@"b":@(1.0),@"a":@(1.0)}
+(NSDictionary *)fan_rgbDicFromColor:(UIColor *)rgbColor{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    BOOL success = [rgbColor getRed:&red green:&green blue:&blue alpha:&alpha];
    if (success) {
        return @{@"r":@(red),@"g":@(green),@"b":@(blue),@"a":@(alpha)};
    }
    return @{@"r":@(1.0),@"g":@(1.0),@"b":@(1.0),@"a":@(1.0)};
}
/** 等比例缩放图片到指定大小
 
 *  CGSize  :   缩放后的大小
 *  return  :   更改后的图片对象
 */
+(UIImage*)fan_scalImage:(UIImage *)sourceImage scalingForSize:(CGSize)targetSize{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scaledWidth = targetSize.width;
    CGFloat scaledHeight = targetSize.height;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO){
        CGFloat targetWidth = targetSize.width;
        CGFloat targetHeight = targetSize.height;
        CGFloat scaleFactor = 0.0;
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
///等比适配到固定大小里面(图片不超过maxsize)
/// @param sourceImage 图片
/// @param maxSize 最大边的尺寸
+(UIImage*)fan_scalImage:(UIImage *)sourceImage scaleAspectFitSize:(CGSize)maxSize{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scaledWidth = maxSize.width;
    CGFloat scaledHeight = maxSize.height;
    if (CGSizeEqualToSize(imageSize, maxSize) == NO){
        CGFloat scaleFactor = 0.0;
        CGFloat widthFactor = scaledWidth / width;
        CGFloat heightFactor = scaledHeight / height;
        if (widthFactor > heightFactor){
            scaleFactor = heightFactor;
        }else{
            scaleFactor = widthFactor;
        }
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
    }
    CGRect contextFrame = CGRectMake(0, 0, scaledWidth, scaledHeight);
    //把图片画在等比例的区域内
    UIGraphicsBeginImageContext(contextFrame.size);
    [sourceImage drawInRect:contextFrame];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    if ( scaledImage == nil ){
        NSLog(@"UIImageRetinal:could not scale image!!!");
        return nil;
    }
    UIGraphicsEndImageContext();
    return scaledImage;
}
/// 不变形裁剪图片
/// @param image 图片
/// @param size 图片View的控件大小
/// @param rect 相对于图片View的裁剪框尺寸
/// @param isOval 是否是圆形
+(UIImage *)fan_clipImage:(UIImage *)image imageViewSize:(CGSize)size clipRect:(CGRect)rect isOval:(BOOL)isOval{
    CGFloat wScale=image.size.width/size.width;
    CGFloat hScale=image.size.height/size.height;

    CGRect rec = CGRectMake(rect.origin.x*wScale, rect.origin.y*hScale,rect.size.width*wScale,rect.size.height*hScale);
    //竖屏照片有偏移，而且方向也是错的
//    CGImageRef imageRef =CGImageCreateWithImageInRect([image CGImage],rec);
//    UIImage * image = [[UIImage alloc]initWithCGImage:imageRef];
//    CGImageRelease(imageRef);
    
    //把图片画在等比例的区域内
    UIGraphicsBeginImageContext(rec.size); // this will crop
    if (isOval) {
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, rec.size.width, rec.size.height)];
        //把圆形的路径设置在指定区域 超过裁剪区域以外的内容都给裁剪掉
        [path addClip];
    }
    [image drawAtPoint:CGPointMake(-rec.origin.x, -rec.origin.y)];
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return clipImage;
}
/** 通过UIcolor获取一张图片 */
+ (UIImage *)fan_imageWithColor:(UIColor *)color frame:(CGRect)rect{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
/** 通过UIcolor获取一张图片圆角 */
+ (UIImage *)fan_imageWithColor:(UIColor *)color frame:(CGRect)rect cornerRadius:(CGFloat)cornerRadius{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    int w  = rect.size.width;
    int h = rect.size.height;
    int c = cornerRadius;
    CGContextMoveToPoint(context, 0, c);
    CGContextAddArcToPoint(context, 0, 0, c, 0, c);
    CGContextAddLineToPoint(context, w-c, 0);
    CGContextAddArcToPoint(context, w, 0, w, c, c);
    CGContextAddLineToPoint(context, w, h-c);
    CGContextAddArcToPoint(context, w, h, w-c, h, c);
    CGContextAddLineToPoint(context, c, h);
    CGContextAddArcToPoint(context, 0, h, 0, h-c, c);
    CGContextAddLineToPoint(context, 0, c);
    CGContextClosePath(context);
    // 先裁剪 context，再画图，就会在裁剪后的 path 中画
    CGContextClip(context);
    CGContextDrawPath(context, kCGPathFill);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
/** 截屏View*/
+(UIImage*)fan_beginImageContextView:(UIView*)view
{
    //currentView 当前的view
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [FanUIKit fan_mainScreen].scale);
    //取得当前画布的上下文UIGraphicsGetCurrentContext  render渲染
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}
/** 一倍截屏*/
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
    //    CGImageRelease(imageRef);//加入这个会崩溃，不知道为什么
    CGImageRelease(imageRefRect);
    
    return sendImage;
}
+ (UIImage *)fan_snapshotLayerImage:(UIView *)view{
    //图片位图的大小
    CGSize size = view.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [FanUIKit fan_mainScreen].scale);
    //View 内的图像放到size位图的位置
    CGRect rect = view.bounds;
    //  自iOS7开始它允许你截取一个UIView或者其子类中的内容，并且以位图的形式（bitmap）保存到UIImage中
    [view drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
    //AVCaptureVideoPreviewLayer 和 AVSampleBufferDisplayLayer可以用这个获取一个View，但是能添加，不能再截图
    //    UIView *snapView = [self snapshotViewAfterScreenUpdates:YES];
    
}
+ (UIImage *)fan_gaussianBlurImage:(UIImage *)image
{
    CIImage *ciImage = [[CIImage alloc]initWithImage:image];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    [filter setValue:@0.3f forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef outImage = [context createCGImage: result fromRect:[result extent]];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    
    return blurImage;
}

/**
 高斯模糊（对用content截图，opengl截图的图片发红处理高斯模糊）
 
 @param image 图片
 @param blur 1-100（最好是1-25）
 @return 高斯模糊图片
 */
+(UIImage *)fan_accelerateBlurWithImage:(UIImage *)image blurNumber:(CGFloat)blur
{
    if(image==nil){
        return nil;
    }
    int boxSize = blur;
    if (blur<1) {
        boxSize=1;
    }
    if (blur>100) {
        boxSize=100;
    }
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer, rgbOutBuffer;
    vImage_Error error;
    
    void *pixelBuffer, *convertBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    convertBuffer = malloc( CGImageGetBytesPerRow(img) * CGImageGetHeight(img) );
    rgbOutBuffer.width = CGImageGetWidth(img);
    rgbOutBuffer.height = CGImageGetHeight(img);
    rgbOutBuffer.rowBytes = CGImageGetBytesPerRow(img);
    rgbOutBuffer.data = convertBuffer;
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc( CGImageGetBytesPerRow(img) * CGImageGetHeight(img) );
    
    if (pixelBuffer == NULL) {
        NSLog(@"No pixelbuffer");
    }
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    void *rgbConvertBuffer = malloc( CGImageGetBytesPerRow(img) * CGImageGetHeight(img) );
    vImage_Buffer outRGBBuffer;
    outRGBBuffer.width = CGImageGetWidth(img);
    outRGBBuffer.height = CGImageGetHeight(img);
    outRGBBuffer.rowBytes = CGImageGetBytesPerRow(img);//3
    outRGBBuffer.data = rgbConvertBuffer;
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    //    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    const uint8_t mask[] = {2, 1, 0, 3};
    
    vImagePermuteChannels_ARGB8888(&outBuffer, &rgbOutBuffer, mask, kvImageNoFlags);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(rgbOutBuffer.data,
                                             rgbOutBuffer.width,
                                             rgbOutBuffer.height,
                                             8,
                                             rgbOutBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    
    free(pixelBuffer);
    free(convertBuffer);
    free(rgbConvertBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}
/**
 高斯模糊（直接对原图片高斯模糊）
 
 @param image 图片
 @param blur 1-100（最好是1-25）
 @return 高斯模糊图片
 */
+(UIImage *)fan_accelerateBlurShortWithImage:(UIImage *)image blurNumber:(CGFloat)blur
{
    if(image==nil){
        return nil;
    }
    int boxSize = blur;
    if (blur<1||blur>100) {
        boxSize=25;
    }
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
//    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}
+(UIVisualEffectView *)fan_addBlurEffectToView:(UIView *)toView{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, toView.frame.size.width, toView.frame.size.height);
    [toView addSubview:effectView];
    return effectView;
}

+(UIVisualEffectView *)fan_addBlurEffectWithStyle:(UIBlurEffectStyle)style toView:(UIView *)toView effectCornerRadius:(CGFloat)cornerRadius{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.layer.masksToBounds=YES;
    effectView.layer.cornerRadius=cornerRadius;
    effectView.frame = CGRectMake(0, 0, toView.frame.size.width, toView.frame.size.height);
    [toView addSubview:effectView];
    return effectView;
}
+(UIImage *)fan_stretchableImage:(UIImage *)image{
    UIImage *returnImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height/3), floorf(image.size.width/3), floorf(image.size.height/3), floorf(image.size.width/3)) resizingMode:UIImageResizingModeStretch];
    
    image=nil;
    return returnImage;
}
+(UIImage *)fan_stretchableImage:(UIImage *)image edgeInset:(UIEdgeInsets)edgeInset{
    UIImage *returnImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height)*edgeInset.top, floorf(image.size.width)*edgeInset.left, floorf(image.size.height)*edgeInset.bottom, floorf(image.size.width)*edgeInset.right) resizingMode:UIImageResizingModeStretch];
    image=nil;
    return returnImage;
}
+(void)fan_addShadowToView:(UIView *)shadowView shadowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowOffset:(CGSize)shadowOffset{
    shadowView.layer.shadowColor =shadowColor.CGColor;
    //阴影透明度，默认为0，如果不设置的话看不到阴影，切记，这是个大坑
    shadowView.layer.shadowOpacity = shadowOpacity;
    shadowView.layer.shadowOffset=shadowOffset;
}
+(void)fan_addShadowToView:(UIView *)shadowView shadowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowOffset:(CGSize)shadowOffset shadowBounds:(CGRect)shadowBounds{
    shadowView.layer.shadowColor =shadowColor.CGColor;
    //阴影透明度，默认为0，如果不设置的话看不到阴影，切记，这是个大坑
    shadowView.layer.shadowOpacity = shadowOpacity;
    shadowView.layer.shadowOffset=shadowOffset;
    //阴影路径设置好后，会加快渲染
    shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowBounds].CGPath;
}
+(void)fan_addShadowToView:(UIView *)shadowView shadowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius byRoundingCorners:(UIRectCorner)corners{
    shadowView.layer.shadowColor =shadowColor.CGColor;
    //阴影透明度，默认为0，如果不设置的话看不到阴影，切记，这是个大坑
    shadowView.layer.shadowOpacity = shadowOpacity;
    shadowView.layer.shadowOffset=shadowOffset;
    shadowView.layer.shadowRadius=shadowRadius;
    //参数依次为大小，设置四个角圆角状态，圆角曲度
    shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:shadowView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(shadowRadius, shadowRadius)].CGPath;
}

/***************************************创建UI******************************************/
+(UILabel*)fan_createLabelWithFrame:(CGRect)frame text:(NSString*)text textColor:(UIColor *)textColor
{
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    //限制行数
    //    label.numberOfLines=0;
    //对齐方式
    label.textAlignment=NSTextAlignmentLeft;
    label.backgroundColor=[UIColor clearColor];
    //    label.font=[UIFont systemFontOfSize:font];
    //单词折行
    //    label.lineBreakMode=NSLineBreakByWordWrapping;
    //默认字体颜色是白色
    label.textColor=textColor;
    //自适应（行数~字体大小按照设置大小进行设置）
    //label.adjustsFontSizeToFitWidth=YES;
    label.text=text;
    return label;
}

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
    //    button.tintColor=[UIColor grayColor];
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
+(UIImageView*)fan_createImageViewWithBundleFrame:(CGRect)frame imageBundleName:(NSString*)imageName{
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:frame];
    if (imageName) {
        NSString *imgPath=[[NSBundle mainBundle]pathForResource:[imageName stringByDeletingPathExtension] ofType:[imageName pathExtension]];
        imageView.image=[UIImage imageWithContentsOfFile:imgPath];
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
+(UIViewController *)fan_viewControllerFrom:(UIView *)view{
    UIResponder *responder = view;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}
+(UIViewController *)fan_presentedViewController:(UIViewController *)viewController{
    while (viewController.presentedViewController)
    {
        viewController = viewController.presentedViewController;
    }
    return viewController;
}
+(void)fan_removeViewTag:(NSInteger)tag fromeView:(UIView *)view{
    UIView *removeView=[view viewWithTag:tag];
    if (removeView) {
        [removeView removeFromSuperview];
        removeView = nil;
    }
}
+(id)fan_classFromName:(NSString *)aClassName{
    Class cl=NSClassFromString(aClassName);
    if (cl) {
        id cls=[[cl alloc]init];
        return cls;
    }
    return nil;
}
+(void)fan_addTapGestureTarget:(id)target action:(SEL)action toView:(UIView *)tapView{
    UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapView.userInteractionEnabled=YES;
    [tapView addGestureRecognizer:imageTapGesture];
}
#pragma mark UIWindow相关
/// 获取keywindow
+(nullable UIWindow *)fan_keyWindow{
    UIWindow *kWindow = nil;
    if (@available(iOS 13.0, *)) {
        if (@available(iOS 15.0, *)) {
            kWindow=[FanUIKit fan_activeWindowScene].keyWindow;
        } else {
            kWindow=[FanUIKit fan_activeWindowScene].windows.firstObject;
        }
    } else {
        kWindow = [UIApplication sharedApplication].keyWindow;
        if (kWindow == nil) {
            if([[UIApplication sharedApplication] windows].count>0){
                kWindow=[[[UIApplication sharedApplication] windows] objectAtIndex:0];
            }
        }
    }
    if (kWindow==nil) {
        if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(window)]) {
            kWindow = [[[UIApplication sharedApplication] delegate] window];
        }
    }
    return kWindow;
}
///获取活跃的windowScene
+(nullable UIWindowScene*)fan_activeWindowScene API_AVAILABLE(ios(13.0)){
    if (@available(iOS 13.0, *)) {
        UIWindowScene *actWindowScene;
        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                actWindowScene = windowScene;
                break;
            }
        }
        if (actWindowScene==nil) {
            for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
                if ([windowScene isKindOfClass:[UIWindowScene class]]) {
                    actWindowScene = windowScene;
                    break;
                }
            }
        }
        return actWindowScene;
    }
    return nil;
}
/// 适配screen
+(nullable UIScreen *)fan_mainScreen{
    if (@available(iOS 13.0, *)) {
        UIWindowScene *wScene = [FanUIKit fan_activeWindowScene];
        if(wScene){
            return wScene.screen;
        }else{
            return [UIScreen mainScreen];
        }
    }else{
        return [UIScreen mainScreen];
    }
}
@end

