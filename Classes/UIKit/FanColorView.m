//
//  FanColorView.m
//  Brain
//
//  Created by 向阳凡 on 2019/4/28.
//  Copyright © 2019 向阳凡. All rights reserved.
//

#import "FanColorView.h"
#import "FanUIKit.h"
#import "NSBundle+FanKit.h"


@interface FanColorView ()


@end


@implementation FanColorView{
    CGFloat fan_r;
    CGFloat fan_g;
    CGFloat fan_b;
    CGFloat fan_a;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    self.userInteractionEnabled = YES;
    self.isVertical=NO;
    _startDepthColor=[UIColor redColor];
    
}

-(void)initWithColorType:(NSInteger)colorType{
    _colorType=colorType;
    if (colorType==0) {
        [self addCircleColor];
    }else if(colorType==1){
        [self addRectColor];
    }else if(colorType==2){
        [self addDepthColor];
    }
}
-(void)setStartDepthColor:(UIColor *)startDepthColor{
    _startDepthColor=startDepthColor;
    [self addDepthColor];
}
-(void)addSliderView:(UIImageView *)sliderView{
    _sliderView=sliderView;
    [self addSubview:self.sliderView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint pointL = [touch locationInView:self];
    [self refreshTouchPoint:pointL];
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint pointL = [touch locationInView:self];
    [self refreshTouchPoint:pointL];
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint pointL = [touch locationInView:self];
    [self refreshTouchPoint:pointL];
}
-(void)refreshTouchPoint:(CGPoint)touchPoint{
    if (self.colorType==0) {
        if (pow(touchPoint.x - self.bounds.size.width/2, 2)+pow(touchPoint.y-self.bounds.size.width/2, 2) > pow(self.bounds.size.width/2, 2)) {
            return;
        }
    }else if(self.colorType==1||self.colorType==2){
        if (self.isVertical) {
            if (touchPoint.y<1||touchPoint.y>self.bounds.size.height-1) {
                return;
            }
            touchPoint=CGPointMake(self.bounds.size.width/2.0, touchPoint.y);
        }else{
            if (touchPoint.x<1||touchPoint.x>self.bounds.size.width-1) {
                return;
            }
            touchPoint=CGPointMake(touchPoint.x, self.bounds.size.height/2.0);
        }
        if (self.sliderView) {
            self.sliderView.center=touchPoint;
        }
    }
    UIColor *color = [self colorAtPixel:touchPoint];
    if (self.colorBlock) {
        self.colorBlock(color,fan_r,fan_g,fan_b,fan_a);
    }
    if (self.moveBlock) {
        self.moveBlock(touchPoint,color);
    }
}


//获取图片某一点的颜色
- (UIColor *)colorAtPixel:(CGPoint)point {
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.image.size.width, self.image.size.height), point)) {
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.image.CGImage;
    NSUInteger width = self.image.size.width;
    NSUInteger height = self.image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    
    fan_r=red;
    fan_g=green;
    fan_b=blue;
    fan_a=alpha;
    
//    NSLog(@"%f***%f***%f***%f",red,green,blue,alpha);
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)setImage:(UIImage *)image {
    UIImage *contextImage=[self fan_scalImage:image scalSize:CGSizeMake(self.frame.size.width, self.frame.size.width)];

    [super setImage:contextImage];
}
- (UIImage *)fan_scalImage:(UIImage *)image scalSize:(CGSize)scalSize {
    CGSize imageSize = scalSize;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
    [image drawInRect:imageRect];
    UIImage *scalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scalImage;
}
#pragma mark - 颜色选择器Layer和图片赋值
-(void)addGradientLayerWithColors:(NSArray*)colors{
    NSMutableArray *colorArray = [NSMutableArray array];
    for(UIColor * color in colors)
    {
        [colorArray addObject:(id)color.CGColor];
    }
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
    gradient.colors = colorArray;
    for (CAGradientLayer * p in self.layer.sublayers) {
        [p removeFromSuperlayer];
    }
    [self.layer insertSublayer:gradient atIndex:0];
}

//添加深度颜色
-(void)addDepthColor{
    [self.layer.sublayers enumerateObjectsUsingBlock:^(__kindof CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    
    
//    [self.layer insertSublayer:[FanDrawLayer fan_gradientLayerFrame:self.bounds startColor:self.startDepthColor endColor:[UIColor blackColor] isVertical:self.isVertical locations:@[@(0),@(1)]] atIndex:0];

    [self addGradientLayerWithColors:@[[UIColor whiteColor],self.startDepthColor,[UIColor blackColor]]];
    self.image=[FanUIKit fan_beginImageContext:self.bounds fromView:self];
}
-(void)addRectColor{
    [self addGradientLayerWithColors:@[[UIColor redColor],[UIColor magentaColor],[UIColor blueColor],[UIColor cyanColor],[UIColor greenColor],[UIColor yellowColor],[UIColor redColor]]];
    self.image=[FanUIKit fan_beginImageContext:self.bounds fromView:self];
    self.layer.cornerRadius=self.frame.size.height/2.0f;
}
-(void)addCircleColor{
    [self.layer.sublayers enumerateObjectsUsingBlock:^(__kindof CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    self.layer.cornerRadius = self.frame.size.width/2.0;
    self.layer.masksToBounds = YES;
    self.image = [NSBundle fan_bundleImageName:@"FanKit_palette.png"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
