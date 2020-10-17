//
//  FanRgbView.m
//  FanPicture
//
//  Created by 向阳凡 on 2020/10/10.
//

#import "FanRgbView.h"
#import "UIView+FanAutoLayout.h"
#import "FanUIKit.h"

@interface FanRgbView()

@property(nonatomic,assign)CGFloat w;
@property(nonatomic,assign)CGFloat h;

@end

@implementation FanRgbView


-(void)awakeFromNib{
    [super awakeFromNib];
    [self initRgb];
}
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self initRgb];
    }
    return self;
}
-(void)initRgb{
    self.backgroundColor=[UIColor clearColor];
    _rgbColor=[UIColor redColor];
    self.padding=8;
    
}
-(FanHSVView *)hsvView{
    if (_hsvView==nil) {
        __weak typeof(self)weakSelf=self;
        _hsvView=[[FanHSVView alloc]init];
        [_hsvView setHsvBlock:^(UIColor * _Nullable hsvColor, FanHSVTouchType touchType) {
            weakSelf.panColor=hsvColor;
            if (weakSelf.rgbBlock) {
                weakSelf.rgbBlock(weakSelf, hsvColor,touchType);
            }
        }];
        [_hsvView setHsvTouchBlock:^(CGPoint touchPoint, FanHSVTouchType touchType) {
            [weakSelf fan_touchPoint:touchPoint touchType:touchType];
        }];
        [self addSubview:_hsvView];
    }
    return _hsvView;
}
-(UIImageView *)pointView{
    if (_pointView==nil) {
        _pointView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
        _pointView.layer.cornerRadius=16/2.0;
        _pointView.userInteractionEnabled=YES;
        _pointView.layer.borderWidth=3;
        _pointView.layer.borderColor=[UIColor whiteColor].CGColor;
        [FanUIKit fan_addShadowToView:_pointView shadowColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]shadowOpacity:1.0 shadowOffset:CGSizeZero];
        [self addSubview:_pointView];
        
        UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [_pointView addGestureRecognizer:pan];
    }
    return _pointView;
}
-(void)fan_drawStyle:(FanHSVType)hsvType{
    self.hsvType=hsvType;
    self.hsvView.hsvType=hsvType;
    self.hsvView.isVertical=self.isVertical;
        if (self.rgbColor) {
        self.hsvView.hsvColor=self.rgbColor;
    }
    [self fan_addConstraintsFormat:self.hsvView formatH:[NSString stringWithFormat:@"H:|-%f-[view]-%f-|",self.padding,self.padding] formatV:[NSString stringWithFormat:@"V:|-%f-[view]-%f-|",self.padding,self.padding] formatOptions:0];
    
    [self.hsvView fan_drawHsv];
}
-(void)fan_resetDraw{
    self.hsvView.hsvType=self.hsvType;
    [self.hsvView fan_drawHsv];
}

-(void)setRgbColor:(UIColor *)rgbColor{
    if (rgbColor) {
        _rgbColor=rgbColor;
        self.hsvView.hsvColor=rgbColor;
    }
}

#pragma mark - 手势处理

///0-Began 1-Moved 2-Ended 3-Cancelled
-(void)fan_touchPoint:(CGPoint)point touchType:(FanHSVTouchType)touchType{
    CGPoint cPoint=[self.hsvView convertPoint:point toView:self];
    
//    NSLog(@"坐标点%@===%f======%f=======%f======%f",self.hsvView,point.x,point.y,cPoint.x,cPoint.y);
    if (self.panCenter) {
        if (self.isVertical) {
            cPoint.x=self.hsvView.center.x;
        }else{
            cPoint.y=self.hsvView.center.y;
        }
        self.pointView.center=cPoint;
    }else{
        self.pointView.center=cPoint;
    }
    
}
-(void)pan:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan locationInView:self.hsvView];
    FanHSVTouchType touchType=FanHSVTouchTypeBegan;
    if (pan.state==UIGestureRecognizerStateBegan) {
        touchType=FanHSVTouchTypeBegan;
    }else if (pan.state==UIGestureRecognizerStateChanged) {
        touchType=FanHSVTouchTypeMoved;
    }else if (pan.state==UIGestureRecognizerStateEnded) {
        touchType=FanHSVTouchTypeEnded;
    }else if (pan.state==UIGestureRecognizerStateCancelled) {
        touchType=FanHSVTouchTypeCancelled;
    }else if (pan.state==UIGestureRecognizerStateFailed) {
        touchType=FanHSVTouchTypeCancelled;
    }
    [self.hsvView fan_touchPoint:point touchType:touchType];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.w=self.frame.size.width;
    self.h=self.frame.size.height;
}


@end


#pragma mark - FanHSVView


@interface FanHSVView()

@property(nonatomic,assign)CGFloat w;
@property(nonatomic,assign)CGFloat h;
@property(nonatomic,assign)CGFloat r;//圆形时半径

///坐标系圆点的x进度0-1   圆形时 表示Hue
@property(nonatomic,assign)CGFloat progressX;
///坐标系圆点的y进度0-1  圆形时 表示饱和度
@property(nonatomic,assign)CGFloat progressY;

@property(nonatomic,assign)CGFloat fan_hue;
///饱和是白色 0-白色 1-rgb
@property(nonatomic,assign)CGFloat fan_saturation;
///亮度是黑色 0-黑 1-rgb
@property(nonatomic,assign)CGFloat fan_brightness;
@property(nonatomic,assign)CGFloat fan_alpha;

//是否是第一次
@property(nonatomic,assign)BOOL fan_first;

@end

@implementation FanHSVView


-(void)awakeFromNib{
    [super awakeFromNib];
    [self initHsv];
}
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self initHsv];
    }
    return self;
}
-(void)initHsv{
    _hsvColor=[UIColor redColor];
    _resetPanPoint=YES;
    _progressX=1.0f;
    _progressY=0.0f;
    _fan_first=YES;
}


-(void)fan_drawHsv{
    if (self.hsvType==FanHSVTypeCicle_HS) {
        
        
    }else if(self.hsvType==FanHSVTypeRect_H){
        
    }else if(self.hsvType==FanHSVTypeRect_SL){
        
    }else if(self.hsvType==FanHSVTypeRect_S){
        
    }
    [self setNeedsDisplay];
}
///上个界面传过来的颜色转换全局HSV值并计算位置
-(void)initHSVLocation{
    if (self.hsvColor) {
        CGFloat hue;
        CGFloat saturation;//饱和是白色 0-rgb 1-白色
        CGFloat brightness;//亮度是黑色 0-黑 1-rgb
        CGFloat alpha;
        
        BOOL success = [self.hsvColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        if (success==NO) {
            return;
        }
        CGPoint point=CGPointZero;
        self.fan_hue=hue;
        self.fan_saturation=saturation;
        self.fan_brightness=brightness;
        self.fan_alpha=alpha;
        if (self.resetPanPoint||self.fan_first) {
            if (self.fan_first) {
                self.fan_first=NO;
            }
            if (self.hsvType==FanHSVTypeCicle_HS) {
                self.layer.cornerRadius=MIN(self.w/2.0f,self.h/2.0f);
                self.clipsToBounds=YES;
                
            }else if(self.hsvType==FanHSVTypeRect_H){
                if (self.isVertical) {
                    self.progressX=0.5;
                    self.progressY=1.0f-self.fan_hue;
                }else{
                    self.progressX=1.0f-self.fan_hue;
                    self.progressY=0.5;
                }
            }else if(self.hsvType==FanHSVTypeRect_SL){
                self.progressX=self.fan_saturation;
                self.progressY=1.0f-self.fan_brightness;
            }else if(self.hsvType==FanHSVTypeRect_S){
                if (self.isVertical) {
                    self.progressX=0.5;
                    self.progressY=self.fan_saturation;
                }else{
                    self.progressX=self.fan_saturation;
                    self.progressY=0.5;
                }
                
            }else if(self.hsvType==FanHSVTypeRect_L){
                if (self.isVertical) {
                    self.progressX=0.5;
                    self.progressY=1.0f-self.fan_brightness;
                }else{
                    self.progressX=1.0f-self.fan_brightness;
                    self.progressY=0.5;
                }
            }
            if (self.hsvType==FanHSVTypeCicle_HS) {
                CGPoint cPoint=CGPointMake(self.w/2.0f, self.h/2.0f);
                double dis =self.r * self.fan_saturation;//手指半径
                CGFloat at=self.fan_hue*(M_PI*2.0f);//0-180  0-(-180)
                point.x=cPoint.x + dis*cos(at);
                point.y=cPoint.y + dis*sin(at);
            }else{
                point=CGPointMake(self.progressX*self.w, self.progressY*self.h);
            }

            if (self.hsvTouchBlock) {
                self.hsvTouchBlock(point, FanHSVTouchTypeInit);
            }
        }else{
            if (self.hsvType==FanHSVTypeCicle_HS) {
                CGPoint cPoint=CGPointMake(self.w/2.0f, self.h/2.0f);
                double dis =self.r * self.fan_saturation;//手指半径
                CGFloat at=self.fan_hue*(M_PI*2.0f);//0-180  0-(-180)
                point.x=cPoint.x + dis*cos(at);
                point.y=cPoint.y + dis*sin(at);
            }else{
                point=CGPointMake(self.progressX*self.w, self.progressY*self.h);
            }

            if (self.hsvTouchBlock) {
                self.hsvTouchBlock(point, FanHSVTouchTypeInit);
            }
            //不重置拖动点时初始化回调颜色
            [self getPanRgbTouchType:FanHSVTouchTypeInit];
        }
    }
}
-(void)setHsvColor:(UIColor *)hsvColor{
    if (hsvColor) {
        _hsvColor=hsvColor;
    }
}
#pragma mark - 手势处理

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint=[[touches anyObject]locationInView:self];
    [self fan_touchPoint:touchPoint touchType:FanHSVTouchTypeBegan];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint=[[touches anyObject]locationInView:self];
    [self fan_touchPoint:touchPoint touchType:FanHSVTouchTypeMoved];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint=[[touches anyObject]locationInView:self];
    [self fan_touchPoint:touchPoint touchType:FanHSVTouchTypeEnded];
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint=[[touches anyObject]locationInView:self];
    [self fan_touchPoint:touchPoint touchType:FanHSVTouchTypeCancelled];
}
///0-Began 1-Moved 2-Ended 3-Cancelled
-(void)fan_touchPoint:(CGPoint)point touchType:(FanHSVTouchType)touchType{
    if (point.x<0) {
        point.x=0;
    }else if(point.x>self.w){
        point.x=self.w;
    }
    if (point.y<0) {
        point.y=0;
    }else if(point.y>self.h){
        point.y=self.h;
    }
    if (self.hsvType==FanHSVTypeCicle_HS) {
        CGPoint cPoint=CGPointMake(self.w/2.0f, self.h/2.0f);
        double x=point.x-cPoint.x;
        double y=point.y-cPoint.y;
        double dis = hypot(x, y);//手指半径
        CGFloat at=atan2(y, x);//0-180  0-(-180)
        if (dis>self.r) {
            point.x=cPoint.x + self.r*cos(at);
            point.y=cPoint.y + self.r*sin(at);
        }
        //转换成0-360
        if (at<0) {
            at+=M_PI*2.0f;
        }
        double realAngle=at*180.0f/M_PI;//0-360;
        self.progressX=(realAngle)/360.0f;
        self.progressY=(dis)/self.r;
        
    }else{
        self.progressX=(point.x)/self.w;
        self.progressY=(point.y)/self.h;
    }
    
    self.touchPoint=point;
    //拖动结束
    if (self.hsvTouchBlock) {
        self.hsvTouchBlock(point, touchType);
    }
//    NSLog(@"饱和度%f=========亮度%f",self.progressX,self.progressY);
  
    [self getPanRgbTouchType:touchType];
}
- (void)getPanRgbTouchType:(FanHSVTouchType)touchType{
    if (self.hsvType==FanHSVTypeCicle_HS) {
        self.panColor = [UIColor colorWithHue:self.progressX saturation:self.progressY brightness:1.0 alpha:1.0];
        
    }else if(self.hsvType==FanHSVTypeRect_H){
        if (self.isVertical) {
            //垂直
            self.panColor = [UIColor colorWithHue:(1.0f-self.progressY) saturation:1.0 brightness:1.0 alpha:1.0];
        }else{
            //水平
            self.panColor = [UIColor colorWithHue:(1.0f-self.progressX) saturation:1.0 brightness:1.0 alpha:1.0];
        }
    }else if(self.hsvType==FanHSVTypeRect_SL){
        //HSV的亮度和饱和度
        self.panColor = [UIColor colorWithHue:self.fan_hue saturation:self.progressX brightness:(1.0-self.progressY) alpha:self.fan_alpha];
       
    }else if(self.hsvType==FanHSVTypeRect_S){
        if (self.isVertical) {
            //垂直
            self.panColor = [UIColor colorWithHue:self.fan_hue saturation:self.progressY brightness:1.0 alpha:1.0];
        }else{
            //水平
            self.panColor = [UIColor colorWithHue:self.fan_hue saturation:self.progressX brightness:1.0 alpha:1.0];
        }
    }else if(self.hsvType==FanHSVTypeRect_L){
        if (self.isVertical) {
            //垂直
            self.panColor = [UIColor colorWithHue:self.fan_hue saturation:1.0 brightness:(1.0f-self.progressY) alpha:1.0];
        }else{
            //水平
            self.panColor = [UIColor colorWithHue:self.fan_hue saturation:1.0 brightness:(1.0f-self.progressX) alpha:1.0];
        }
    }
    
    if (self.hsvBlock) {
        self.hsvBlock(self.panColor,touchType);
    }
}
#pragma mark - draw 画图
- (void)drawRect:(CGRect)rect {
    self.w=rect.size.width;
    self.h=rect.size.height;
    self.r=MIN(self.w/2.0f, self.h/2.0f);;
    [self initHSVLocation];

    if (self.hsvType==FanHSVTypeCicle_HS) {
        //白色外部发散
        [self drawOval];
    }else if(self.hsvType==FanHSVTypeRect_H){
        [self drawRound];
    }else if(self.hsvType==FanHSVTypeRect_SL){
        [self drawLinght];
    }else if(self.hsvType==FanHSVTypeRect_S){
        [self drawCenterLinght];
    }else if(self.hsvType==FanHSVTypeRect_L){
        [self drawCenterLinght];
    }
}
///画左中右的饱和度
-(void)drawCenterLinght{
    int count=360;
    CGFloat d=(CGFloat)count;
    CGFloat p = (self.w)/d;
    CGFloat p2 = (self.h)/d;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    for (int i = 0; i < count; i++){
        if (self.isVertical) {
            if (self.hsvType==FanHSVTypeRect_S) {
                UIColor* c = [UIColor colorWithHue:self.fan_hue saturation:((CGFloat)(i))/d brightness:1.0 alpha:1.0];
                CGContextSetFillColorWithColor(ctx, c.CGColor);
                CGContextFillRect(ctx,CGRectMake(0,p2*i, self.w, p2*10.0));//填充框
            }else if (self.hsvType==FanHSVTypeRect_L){
                UIColor* c = [UIColor colorWithHue:self.fan_hue saturation:1.0 brightness:1.0f-((CGFloat)(i))/d alpha:1.0];
                CGContextSetFillColorWithColor(ctx, c.CGColor);
                CGContextFillRect(ctx,CGRectMake(0,p2*i, self.w, p2*10.0));//填充框
            }
        }else{
            if (self.hsvType==FanHSVTypeRect_S) {
                UIColor* c = [UIColor colorWithHue:self.fan_hue saturation:((CGFloat)(i))/d brightness:1.0 alpha:1.0];
                CGContextSetFillColorWithColor(ctx, c.CGColor);
                CGContextFillRect(ctx,CGRectMake(i*p,0, p*10.0f, self.h));//填充框
            }else if (self.hsvType==FanHSVTypeRect_L){
                UIColor* c = [UIColor colorWithHue:self.fan_hue saturation:1.0 brightness:1.0f-((CGFloat)(i))/d alpha:1.0];
                CGContextSetFillColorWithColor(ctx, c.CGColor);
                CGContextFillRect(ctx,CGRectMake(i*p,0, p*10.0f, self.h));//填充框
            }
            
            //左中右，不太好，不能完美
//            if (i<count/2) {
//                UIColor* c = [UIColor colorWithHue:self.fan_hue saturation:(((CGFloat)(i))/(d*0.5)) brightness:1.0 alpha:1.0];
//                CGContextSetFillColorWithColor(ctx, c.CGColor);
//                CGContextFillRect(ctx,CGRectMake(i*p,0, p*10.0f, self.h));//填充框
//            }else if (i==count/2){
//                UIColor* c = [UIColor colorWithHue:self.fan_hue saturation:1.0 brightness:1.0 alpha:1.0];
//                CGContextSetFillColorWithColor(ctx, c.CGColor);
//                CGContextFillRect(ctx,CGRectMake(i*p,0, p*10.0f, self.h));//填充框
//            }else if (i>count/2){
//                UIColor* c = [UIColor colorWithHue:self.fan_hue saturation:1.0 brightness:1.0-(((CGFloat)(i-count/2))/(d*0.5)) alpha:1.0];
//                CGContextSetFillColorWithColor(ctx, c.CGColor);
//                CGContextFillRect(ctx,CGRectMake(i*p,0, p*10.0f, self.h));//填充框
//            }
            
        }
        
    }
}
///画亮度和饱和度
-(void)drawLinght{
    int xIndex=100;
    int yIndex=100;//应该是360个色域
    CGFloat xp = (self.w)/(CGFloat)(xIndex);
    CGFloat yp = (self.h)/(CGFloat)(yIndex);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(ctx, xp*10.0);
    for (int i = 0; i < xIndex; i++){
        //i是X饱和度
        for (int j = 0; j < yIndex; j++){
            //j是Y亮度
            UIColor* c = [UIColor colorWithHue:self.fan_hue saturation:((CGFloat)(i))/(CGFloat)(xIndex) brightness:((CGFloat)(yIndex-j))/(CGFloat)(yIndex) alpha:self.fan_alpha];
            CGContextSetFillColorWithColor(ctx, c.CGColor);
            CGContextFillRect(ctx,CGRectMake(i*xp,j*yp, xp*3.0f, yp*3.0));//填充框

            //有线框矩形，效果没有矩形好
//            CGContextSetStrokeColorWithColor(ctx, c.CGColor);
//            //画方框
//            CGContextStrokeRect(ctx,CGRectMake(i*xp,j*yp, xp*5.0f, yp*5.0));
//            //画方框
//            CGContextStrokePath(ctx);
        }
    }
}
-(void)drawRound{
    CGRect rect=self.frame;
    CGFloat w = CGRectGetWidth(rect);
    CGFloat h = CGRectGetHeight(rect);
    int count=360;
    CGFloat d=(CGFloat)count;
    CGFloat p = w/d;
    if (self.isVertical) {
        p = h/d;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置线宽方法二
//    CGContextSetLineWidth(ctx, p*10.0);
    for (int i = 0; i < count; i++){
        UIColor* c = [UIColor colorWithHue:((CGFloat)(count-i))/d saturation:1. brightness:1. alpha:1];
        //画矩形填充(方法一)
        CGContextSetFillColorWithColor(ctx, c.CGColor);
        if (self.isVertical) {
            CGContextFillRect(ctx,CGRectMake(0, i*p, w, p*10.0));//填充框
        }else{
            CGContextFillRect(ctx,CGRectMake(i*p, 0, p*10.0, h));//填充框
        }

        //设置描边颜色(方法二)
//        CGContextSetStrokeColorWithColor(ctx, c.CGColor);
//        //画方框
////        CGContextStrokeRect(ctx,CGRectMake(i*p, 0, p*10.0, h));
//        //画方框
//        CGContextAddRect(ctx, CGRectMake(i*p, 0, p*10.0, h));
//        CGContextStrokePath(ctx);
    }
}
///画圆形
-(void)drawOval{
    CGRect rect=self.frame;
    CGFloat arcStep = (M_PI *2.0f) / 360.0f;
    BOOL clocklwise = NO;
    CGFloat cX = CGRectGetWidth(rect) / 2.0f;
    CGFloat cY = CGRectGetHeight(rect) / 2.0f;
    CGFloat radius = MIN(cX, cY);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置圆环线宽
    CGContextSetLineWidth(ctx, radius*2.0f);
    for (int i = 0; i < 360; i++){
        UIColor* c = [UIColor colorWithHue:i/360.0f saturation:1. brightness:1. alpha:1];
        CGContextSetStrokeColorWithColor(ctx, c.CGColor);
        CGFloat startAngle = i * arcStep;
        CGFloat endAngle = startAngle + arcStep + 0.02;
        CGContextAddArc(ctx, cX, cY, radius, startAngle, endAngle, clocklwise);
        CGContextStrokePath(ctx);
    }

    
    // 创建色彩空间对象
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    // 创建起点和终点颜色分量的数组
    CGFloat colors[] =
    {
        255, 255, 255, 1.00,//start color(r,g,b,alpha)
        255, 255, 255, 0.00,//end color
    };
    // 圆环渐变色的颜色
//    NSArray *colorArr = @[
//        (id)[UIColor blueColor].CGColor,
//        (id)[UIColor yellowColor].CGColor
//    ];
//    CGGradientRef gradient=CGGradientCreateWithColors(rgb, (__bridge CFArrayRef)&colorArr, NULL);

    //形成梯形，渐变的效果 可以增加数组颜色个数 等分的
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, 2);
    // 起点颜色起始圆心
    CGPoint start = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    // 终点颜色起始圆心
    CGPoint end = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    // 起点颜色圆形半径
    CGFloat startRadius = 0.0f;
    // 终点颜色圆形半径
    CGFloat endRadius = self.frame.size.width/2;
    // 获取上下文
    CGContextRef graCtx = UIGraphicsGetCurrentContext();
    // 创建一个径向渐变
    CGContextDrawRadialGradient(graCtx, gradient, start, startRadius, end, endRadius, 0);
 
    //releas
    CGGradientRelease(gradient);
    gradient=NULL;
    CGColorSpaceRelease(rgb);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
