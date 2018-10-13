//
//  FanAlertController.m
//  FanTest
//
//  Created by 向阳凡 on 2018/6/13.
//  Copyright © 2018年 向阳凡. All rights reserved.
//

#import "FanAlertController.h"

@interface FanAlertController ()
@property(nonatomic,strong)NSTimer *afterTimer;
@end

@implementation FanAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor redColor];
    [self commonInit];
}
/**
 弹出提示对话框
 
 @param textStr 提示文本
 @return self
 */
+ (instancetype)fan_showHUDWithStatus:(NSString*)textStr{
    
    return  [FanAlertController fan_showHUDWithStatus:textStr afterDelay:1.5f];
    
}
+ (instancetype)fan_showHUDWithStatus:(NSString *)textStr afterDelay:(NSTimeInterval)seconds{
    FanAlertController *hud = [[FanAlertController alloc]init];
    //    hud.isAnimation = YES;
    hud.view.frame=[[UIScreen mainScreen]bounds];
    hud.alertTitle=textStr;
    
    hud.showTime=seconds;
    
    [hud configUIWithData];
    
    if (fanAlertWindow==nil) {
        fanAlertWindow=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        fanAlertWindow.windowLevel=UIWindowLevelAlert;
    }
    fanAlertWindow.rootViewController=hud;
    [fanAlertWindow makeKeyAndVisible];

    return hud;
}
+ (instancetype)fan_showProgressHUD{
    FanAlertController *hud = [[FanAlertController alloc]init];
    hud.view.frame=[[UIScreen mainScreen]bounds];
    hud.progressHUDStyle=FanAlertControllerStyleLoding;
    [hud configUIWithData];
    
    if (fanAlertWindow==nil) {
        fanAlertWindow=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        fanAlertWindow.windowLevel=UIWindowLevelAlert;
    }
    fanAlertWindow.rootViewController=hud;
    [fanAlertWindow makeKeyAndVisible];
    
    return hud;
}


+ (instancetype)fan_showProgressHUD:(NSString *)textStr{
    return [FanAlertController fan_showProgressHUD:textStr afterDelay:-1];
}

+ (instancetype)fan_showProgressHUD:(NSString *)textStr afterDelay:(NSTimeInterval)seconds{
    FanAlertController *hud = [[FanAlertController alloc]init];
    hud.view.frame=[[UIScreen mainScreen]bounds];
    hud.showTime=seconds;
    hud.alertTitle=textStr;
    hud.progressHUDStyle=FanAlertControllerStyleLodingText;
    [hud configUIWithData];
    
    if (fanAlertWindow==nil) {
        fanAlertWindow=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        fanAlertWindow.windowLevel=UIWindowLevelAlert;
    }
    fanAlertWindow.rootViewController=hud;
    [fanAlertWindow makeKeyAndVisible];
    
    return hud;
}


+ (instancetype _Nullable )fan_showAlertHUDTitle:(NSString *_Nullable)textStr subTitle:( NSString * _Nonnull )subTitle buttonTitle:(NSString *_Nullable)buttonTitle alertBlock:(FanProgressHUDAlertBlock _Nullable)alertBlock{
    return [self fan_showAlertHUDTitle:textStr subTitle:subTitle buttonTitles:@[buttonTitle] alertBlock:alertBlock];
}
+ (instancetype)fan_showAlertHUDTitle:(NSString *)textStr subTitle:(NSString *_Nonnull)subTitle buttonTitles:(NSArray*_Nullable)btnTitleArray  alertBlock:(FanProgressHUDAlertBlock _Nullable)alertBlock{
    FanAlertController *hud = [[FanAlertController alloc]init];
    hud.view.frame=[[UIScreen mainScreen]bounds];
    hud.alertTitle=textStr;
    hud.subTitle=subTitle;
    hud.buttonTitleArray=btnTitleArray;
    hud.alertBlock = alertBlock;
    hud.progressHUDStyle=FanAlertControllerStyleAlert;
    [hud configUIWithData];
    
    if (fanAlertWindow==nil) {
        fanAlertWindow=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        fanAlertWindow.windowLevel=UIWindowLevelAlert;
    }
    fanAlertWindow.rootViewController=hud;
    [fanAlertWindow makeKeyAndVisible];
    return hud;
}
+ (instancetype _Nullable )fan_showIconAlertHUDTitle:(NSString *_Nullable)textStr imageName:(NSString *_Nonnull)imageName buttonTitle:(NSString *_Nullable)buttonTitle alertBlock:(FanProgressHUDAlertBlock _Nullable)alertBlock{
    return [self fan_showIconAlertHUDTitle:textStr imageName:imageName buttonTitles:@[buttonTitle] alertBlock:alertBlock];
    
}
+ (instancetype _Nullable )fan_showIconAlertHUDTitle:(NSString *_Nullable)textStr imageName:(NSString *_Nonnull)imageName buttonTitles:(NSArray*_Nullable)btnTitleArray  alertBlock:(FanProgressHUDAlertBlock _Nullable )alertBlock{
    FanAlertController *hud = [[FanAlertController alloc]init];
    hud.view.frame=[[UIScreen mainScreen]bounds];
    hud.alertTitle=textStr;
    hud.iconName=imageName;
    hud.buttonTitleArray=btnTitleArray;
    hud.alertBlock = alertBlock;
    hud.progressHUDStyle=FanAlertControllerStyleIconAlert;
    [hud configUIWithData];
    if (fanAlertWindow==nil) {
        fanAlertWindow=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        fanAlertWindow.windowLevel=UIWindowLevelAlert;
    }
    fanAlertWindow.rootViewController=hud;
    [fanAlertWindow makeKeyAndVisible];
    return hud;
}


+ (BOOL)fan_hideProgressHUD{
    if (fanAlertWindow) {
        fanAlertWindow.rootViewController=nil;
        fanAlertWindow.hidden=YES;
    }
    return YES;
}


//+(BOOL)fan_hideAllProgressHUD{
//    return [self fan_hideAllProgressHUDForView:[UIApplication sharedApplication].keyWindow];
//}
//+(BOOL)fan_hideAllProgressHUDForView:(UIView *)view{
//    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
//    for (UIView *subview in subviewsEnum) {
//        if ([subview isKindOfClass:self]) {
//            FanAlertController *hud = (FanAlertController *)subview ;
//            [hud fan_removeSelfView:NO];
//        }
//    }
//    return YES;
//}
#pragma mark - 初始化

- (void)commonInit {
    self.view.backgroundColor=[UIColor clearColor];
    _showTime=-1;
    _isAnimation=YES;
    _blackAlpha=0.0;//空白区域黑色，半透明
    _isTouchRemove=YES;//是否支持触摸空白区域消失
    _progressHUDStyle=FanAlertControllerStyleText;
    
    
}

//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    if ((self = [super initWithCoder:aDecoder])) {
//        [self commonInit];
//    }
//    return self;
//}


- (void)dealloc {
    [_afterTimer setFireDate:[NSDate distantFuture]];
    [_afterTimer invalidate];
    _afterTimer=nil;
    
    NSLog(@"%s",__func__);
    
}
#pragma mark - 创建UI
-(void)configUIWithData{
    if(self.showTime>0){
        self.afterTimer=[NSTimer scheduledTimerWithTimeInterval:self.showTime target:self selector:@selector(hiddenTimer) userInfo:nil repeats:NO];
    }
    
//    self.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    
    self.blackAlphaView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.blackAlphaView.backgroundColor=[UIColor blackColor];
    self.blackAlphaView.clipsToBounds=YES;
    self.blackAlphaView.alpha=self.blackAlpha;
    [self.view addSubview:self.blackAlphaView];
    
    self.blackAlphaView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    
    [self fan_configUI];
    
    
    
    //    [self.blackAlphaView.layer addAnimation:[[self class] fan_transitionAnimationWithSubType:kCATransitionFromBottom withType:kCATransitionFade duration:0.3f] forKey:@"alpha.animation"];
    
    [self.fan_cententView.layer addAnimation:[[self class] fan_transitionAnimationWithSubType:kCATransitionFromTop withType:kCATransitionFade duration:0.3f] forKey:@"animation"];
    
}
-(void)fan_configUI{
    switch (self.progressHUDStyle) {
        case FanAlertControllerStyleText:
        {
            self.contentHeight=64;//(kFanScreenWidth_Show*0.8*128)/508;
            self.contentWidth=254;//kFanScreenWidth_Show*0.8;
            self.isTouchRemove=NO;
        }
            break;
        case FanAlertControllerStyleLoding:
        {
            self.contentHeight=64;
            self.contentWidth=94;
            self.isTouchRemove=NO;
        }
            break;
        case FanAlertControllerStyleLodingText:
        {
            self.contentHeight=64;
            self.contentWidth=94;
            self.isTouchRemove=NO;
        }
            break;
        case FanAlertControllerStyleAlert:
        {
            self.contentHeight=145;
            self.contentWidth=254;
            self.isTouchRemove=NO;
        }
            break;
        case FanAlertControllerStyleIconAlert:
        {
            self.contentHeight=145;
            self.contentWidth=254;
            self.isTouchRemove=NO;
        }
            break;
        default:
            break;
    }
    
    CGFloat leftSpace=(self.view.frame.size.width-self.contentWidth)/2.0;
    CGFloat topSpace=( self.view.frame.size.height-self.contentHeight)/2.0;
    
    
    self.fan_cententView=[[UIView alloc]initWithFrame:CGRectMake(leftSpace, topSpace, self.contentWidth, self.contentHeight)];
    [self.view addSubview:self.fan_cententView];
    self.fan_cententView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    
    
    self.fan_cententView.clipsToBounds=YES;
    
    _cententBgmView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentWidth, self.contentHeight)];
    _cententBgmView.layer.cornerRadius=10;
    _cententBgmView.userInteractionEnabled=YES;
    _cententBgmView.backgroundColor=[UIColor colorWithWhite:0.2 alpha:0.7];
    [self.fan_cententView addSubview:_cententBgmView];
    
    switch (self.progressHUDStyle) {
        case FanAlertControllerStyleText:
        {
            [self fan_createTextUI];
        }
            break;
        case FanAlertControllerStyleLoding:
        {
            [self fan_createLodingUI];
        }
            break;
        case FanAlertControllerStyleLodingText:
        {
            [self fan_createLodingUI];
        }
            break;
        case FanAlertControllerStyleAlert:
        {
            [self fan_createAlertUI];
        }
            break;
        case FanAlertControllerStyleIconAlert:
        {
            [self fan_createIconAlertUI];
        }
            break;
        default:
            break;
    }
    
}
-(CGSize)fan_currentSizeWithContent:(NSString *)content font:(UIFont *)font cgSize:(CGSize)cgsize{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size=[content boundingRectWithSize:cgsize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}
-(void)fan_createTextUI{
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.contentWidth-20, self.contentHeight-20)];
    titleLabel.text=self.alertTitle;
    titleLabel.tag=1000;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:17];
    titleLabel.numberOfLines=0;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth=YES;
    [self.fan_cententView addSubview:titleLabel];
}
-(void)fan_createLodingUI{
//    UIImageView *lodingImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
//    lodingImgView.image=[UIImage imageNamed:@"fan_loding"];
    
    UIActivityIndicatorView *lodingImgView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    [lodingImgView startAnimating];
    [self.fan_cententView addSubview:lodingImgView];
    
    if (self.alertTitle.length>0) {
        lodingImgView.center=CGPointMake(self.contentWidth/2.0f, self.contentHeight/2.0f-10);
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(3, self.contentHeight-25, self.contentWidth-6, 20)];
        titleLabel.text=self.alertTitle;
        titleLabel.tag=1000;
        titleLabel.textColor=[UIColor whiteColor];
        //        titleLabel.numberOfLines=0;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.adjustsFontSizeToFitWidth=YES;
        titleLabel.font=[UIFont systemFontOfSize:12];
        
        [self.fan_cententView addSubview:titleLabel];
    }else{
        lodingImgView.center=CGPointMake(self.contentWidth/2.0f, self.contentHeight/2.0f);
    }
//    [lodingImgView.layer addAnimation:[[self class] fan_rotationTime:0.2 degree:M_PI/2.0 directionZ:0.5 repeatCount:INT_MAX]forKey:@"rotation"];
    
}
-(void)fan_createAlertUI{
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, self.contentWidth-40, 20)];
    titleLabel.text=self.alertTitle;
    titleLabel.tag=1000;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth=YES;
    [self.fan_cententView addSubview:titleLabel];
    
    UILabel *subLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 40, self.contentWidth-40, 60)];
    subLabel.text=self.subTitle;
    subLabel.tag=1001;
    subLabel.textColor=[UIColor whiteColor];
    subLabel.font=[UIFont systemFontOfSize:14];
    subLabel.textAlignment=NSTextAlignmentCenter;
    subLabel.numberOfLines=0;
    subLabel.adjustsFontSizeToFitWidth=YES;
    [self.fan_cententView addSubview:subLabel];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(2, 100, self.contentWidth-4, 1)];
    lineView.backgroundColor=[UIColor grayColor];
    [self.fan_cententView addSubview:lineView];
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(self.contentWidth/2.0f, 100, 1, self.contentHeight-100-2)];
    lineView1.backgroundColor=[UIColor grayColor];
    [self.fan_cententView addSubview:lineView1];
    
    for (int i=0; i<self.buttonTitleArray.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
        if(self.buttonTitleArray.count>1){
            CGFloat left=0;
            if (i==1) {
                left=self.contentWidth/2.0f;
            }
            [btn setFrame:CGRectMake(left, self.contentHeight-40, self.contentWidth/2.0f, 35)];
        }else{
            [lineView1 removeFromSuperview];
            [btn setFrame:CGRectMake(self.contentWidth/4.0f, self.contentHeight-40, self.contentWidth/2.0f, 35)];
        }
        
        btn.titleLabel.font=[UIFont boldSystemFontOfSize:17];
        btn.titleLabel.adjustsFontSizeToFitWidth=YES;
        UIColor *themeColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:232/255.0 alpha:1];
        [btn setTitleColor:themeColor forState:UIControlStateNormal];
        
        btn.tag=100+i;
        [btn setTitle:self.buttonTitleArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.fan_cententView addSubview:btn];
    }
    
    if(self.alertTitle.length<=0){
        subLabel.frame=CGRectMake(20, 20, self.contentWidth-40, 80);
    }
    
    
}

-(void)fan_createIconAlertUI{
    UIImageView *iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.contentWidth/2.0f-30, 10, 60, 60)];
    iconImageView.image=[UIImage imageNamed:self.iconName];
    [self.fan_cententView addSubview:iconImageView];
    
    UILabel *subLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 68, self.contentWidth-40, 40)];
    subLabel.text=self.alertTitle;
    subLabel.tag=1000;
    subLabel.textColor=[UIColor whiteColor];
    subLabel.font=[UIFont systemFontOfSize:12];
    subLabel.textAlignment=NSTextAlignmentCenter;
    subLabel.numberOfLines=0;
    subLabel.adjustsFontSizeToFitWidth=YES;
    [self.fan_cententView addSubview:subLabel];
    
    
    for (int i=0; i<self.buttonTitleArray.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
        if(self.buttonTitleArray.count>1){
            CGFloat space=(self.contentWidth-68*2.0f)/3.0f;
            
            [btn setFrame:CGRectMake(space+i*(space+68), self.contentHeight-34, 68, 24)];
        }else{
            [btn setFrame:CGRectMake(self.contentWidth/2.0f-34, self.contentHeight-34, 68, 24)];
        }
        
        btn.titleLabel.font=[UIFont boldSystemFontOfSize:12];
        btn.titleLabel.adjustsFontSizeToFitWidth=YES;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"fan_bg_btn"] forState:UIControlStateNormal];
        
        btn.tag=100+i;
        [btn setTitle:self.buttonTitleArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.fan_cententView addSubview:btn];
    }
}
-(void)fan_setTitleColor:(UIColor *_Nullable)titleColor subTitleColor:(UIColor *_Nullable)subTitleColor{
    if (titleColor) {
        UILabel *titleLabel=(UILabel *)[self.fan_cententView viewWithTag:1000];
        titleLabel.textColor=titleColor;
    }
    if (subTitleColor) {
        UILabel *subTitleLabel=(UILabel *)[self.fan_cententView viewWithTag:1001];
        subTitleLabel.textColor=subTitleColor;
    }
    
}
-(void)fan_setTitleColor:(UIColor *_Nullable)titleColor{
    [self fan_setTitleColor:titleColor subTitleColor:nil];
}
#pragma mark - get set

-(void)setBlackAlpha:(CGFloat)blackAlpha{
    _blackAlpha=blackAlpha;
    _blackAlphaView.alpha=blackAlpha;
}

#pragma mark - 移除View
-(void)buttonClick:(UIButton *)btn{
    if (self.alertBlock) {
        self.alertBlock(btn.tag-100);
    }
    [self fan_removeSelfView:NO];
}
-(void)hiddenTimer{
    //时间结束自动移除
    [_afterTimer setFireDate:[NSDate distantFuture]];
    [_afterTimer invalidate];
    _afterTimer=nil;
    
    
    [self removeSelfView];
}

-(void)fan_removeSelfView:(BOOL)animation{
    if (animation) {
        [self removeSelfView];
    }else{
        [self.blackAlphaView.layer removeAllAnimations];
        [self.fan_cententView.layer removeAllAnimations];
        [self performSelector:@selector(removeFromWindow) withObject:nil afterDelay:0.01f];
    }
}
-(void)removeSelfView{
    [self.fan_cententView.layer removeAllAnimations];
    self.blackAlphaView.alpha=0;
    [self.blackAlphaView.layer addAnimation:[[self class] fan_transitionAnimationWithSubType:kCATransitionFromBottom withType:kCATransitionFade duration:0.3] forKey:@"alpha.animation.no"];
    
    self.fan_cententView.alpha=0;
    [self.fan_cententView.layer addAnimation:[[self class] fan_transitionAnimationWithSubType:nil withType:kCATransitionFade duration:0.3f] forKey:@"animation.no"];
    
    [self performSelector:@selector(removeFromWindow) withObject:nil afterDelay:0.3f];
}
-(void)removeFromWindow{
    if (fanAlertWindow) {
        fanAlertWindow.rootViewController=nil;
        fanAlertWindow.hidden=YES;
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.isTouchRemove) {
        CGPoint touchPoint=[[touches anyObject]locationInView:self.view];
        if (touchPoint.y<self.fan_cententView.frame.origin.y||touchPoint.x<self.fan_cententView.frame.origin.x||touchPoint.y>self.fan_cententView.frame.origin.y+self.fan_cententView.frame.size.height||touchPoint.x>self.fan_cententView.frame.origin.x+self.fan_cententView.frame.size.width) {
            [self removeSelfView];
        }
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


#pragma mark - CATransition基本动画
/**动画切换页面的效果(CATransition)
 *subType 方向 kCATransitionFromBottom ....
 *subtypes: kCAAnimationCubic迅速透明移动,cube 3D立方体翻页 pageCurl从一个角翻页，
 *          pageUnCurl反翻页，rippleEffect水波效果，suckEffect缩放到一个角,oglFlip中心立体翻转
 *          (kCATransitionFade淡出，kCATransitionMoveIn覆盖原图，kCATransitionPush推出，kCATransitionReveal卷轴效果)
 */
+(CATransition *)fan_transitionAnimationWithSubType:(NSString *)subType withType:(NSString *)xiaoguo duration:(CGFloat)duration
{
    CATransition *animation=[CATransition animation];
    //立体翻转的效果cube ,rippleEffect,(水波）
    [animation setType:xiaoguo];
    //设置动画方向
    [animation setSubtype:subType];
    //设置动画的动作时长
    [animation setDuration:duration];
    //均匀的作用效果
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    return animation;
}
/** 围绕Z轴旋转
 
 * dur 时间
 * degree旋转角度(逆时针旋转
 * direction方向
 * repeatCount次数
 */
+(CABasicAnimation *)fan_rotationTime:(float)dur degree:(float)degree directionZ:(float)directionZ repeatCount:(int)repeatCount
{
    //第一个参数是旋转角度，后面三个参数形成一个围绕其旋转的向量(x,y,z)，起点位置由UIView的center属性标识。
    CATransform3D rotationTransform  = CATransform3DMakeRotation(degree, 0, 0,directionZ);
    
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    animation.toValue= [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration= dur;
    animation.autoreverses= NO;
    animation.cumulative= YES;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.repeatCount= repeatCount;
    //    animation.delegate = self;
    return animation;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
