//
//  FanDialogboxController.m
//  Brain
//
//  Created by 向阳凡 on 2020/6/15.
//  Copyright © 2020 向阳凡. All rights reserved.
//

#import "FanDialogboxController.h"
#import "FanUIKit.h"

@interface FanDialogboxController ()

@property(nonatomic,strong)NSTimer *afterTimer;
/** 显示几秒后，消失*/
@property (assign, nonatomic) NSTimeInterval showTime;




//默认字体颜色
@property(nullable,nonatomic,strong)UIColor *textColor;

@end

@implementation FanDialogboxController
//底部小白条
- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures
{
    return UIRectEdgeAll;
}
#pragma mark - 做一些函数响应式编程处理属性更快捷

-(instancetype)addTouchRemove:(BOOL)isRemove{
    _isTouchRemove=isRemove;
    return self;
}
-(instancetype)addAutoRemove:(BOOL)isAuto{
    _isAutoRemove=isAuto;
    return self;
}
-(instancetype)addNumKey:(nullable NSString *)numKey{
    if (numKey) {
        _numKey=numKey;
        [[FanDialogboxController fan_dialogDictionary]setObject:self forKey:numKey];
    }
    return self;
}
///存放弹窗，加入key值才能添加进去，添加后可以通过key值移除
+(nullable NSMutableDictionary<NSString*,FanDialogboxController*> * )fan_dialogDictionary{
    static NSMutableDictionary<NSString*,FanDialogboxController*> *fan_dialogDictionary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (fan_dialogDictionary==nil) {
            fan_dialogDictionary=[[NSMutableDictionary alloc]init];
        }
    });
    return fan_dialogDictionary;
}

-(void)setNumKey:(NSString *)numKey{
    _numKey=numKey;
    if (numKey) {
        [[FanDialogboxController fan_dialogDictionary]setObject:self forKey:numKey];
    }
}

#pragma mark -  显示和隐藏的类方法

///弹出提示对话框
+ (instancetype)fan_showDialogMessage:(nullable NSString*)message  fromVC:(nullable UIViewController*)vc{
    return [FanDialogboxController fan_showDialogMessage:message afterDelay:1.5 fromVC:vc];
}

+ (instancetype)fan_showDialogMessage:(nullable NSString *)message afterDelay:(NSTimeInterval)seconds  fromVC:(nullable UIViewController*)vc{
    FanDialogboxController *hud = [[self alloc]init];
    hud.alertTitle=message;
    hud.showTime=seconds;
    [hud configUIWithData];
    hud.definesPresentationContext=NO;
    hud.modalPresentationStyle=UIModalPresentationOverFullScreen;
    [[self fan_presentedViewController:vc] presentViewController:hud animated:NO completion:nil];
    return hud;
}
+ (instancetype)fan_showDialogLodingFromVC:(nullable UIViewController*)vc{
    FanDialogboxController *hud = [[self alloc]init];
    hud.dialogboxStyle=FanDialogboxStyleLoding;
    [hud configUIWithData];
    hud.definesPresentationContext=NO;
    hud.modalPresentationStyle=UIModalPresentationOverFullScreen;
    [[self fan_presentedViewController:vc] presentViewController:hud animated:NO completion:nil];
    return hud;
}
+ (instancetype)fan_showDialogLodingText:(nullable NSString *)textStr fromVC:(nullable UIViewController*)vc{
    return [FanDialogboxController fan_showDialogLodingText:textStr afterDelay:-1 fromVC:vc];
}
+ (instancetype)fan_showDialogLodingText:(nullable NSString *)textStr afterDelay:(NSTimeInterval)seconds fromVC:(nullable UIViewController*)vc{
    FanDialogboxController *hud = [[self alloc]init];
    hud.showTime=seconds;
    hud.alertTitle=textStr;
    hud.dialogboxStyle=FanDialogboxStyleLodingText;
    [hud configUIWithData];
    hud.definesPresentationContext=NO;
    hud.modalPresentationStyle=UIModalPresentationOverFullScreen;
    [[self fan_presentedViewController:vc] presentViewController:hud animated:NO completion:nil];
    return hud;
}

///弹窗对话框，单按钮
+ (instancetype)fan_showAlertTitle:(nullable NSString *)textStr subTitle:(nullable NSString *)subTitle buttonTitle:(nullable NSString *)buttonTitle fromVC:(nullable UIViewController*)vc alertBlock:(nullable FanDialogboxAlertBlock)alertBlock{
    return [self fan_showAlertTitle:textStr subTitle:subTitle buttonTitles:@[buttonTitle] fromVC:vc alertBlock:alertBlock];
}
+ (instancetype)fan_showAlertTitle:(nullable NSString *)textStr subTitle:(nullable NSString *)subTitle buttonTitles:(nullable NSArray*)btnTitleArray fromVC:(nullable UIViewController*)vc alertBlock:(nullable FanDialogboxAlertBlock)alertBlock{
    FanDialogboxController *hud = [[self alloc]init];
    hud.alertTitle=textStr;
    hud.subTitle=subTitle;
    hud.buttonTitleArray=btnTitleArray;
    hud.alertBlock = alertBlock;
    hud.dialogboxStyle=FanDialogboxStyleAlert;
    [hud configUIWithData];
    hud.definesPresentationContext=NO;
    hud.modalPresentationStyle=UIModalPresentationOverFullScreen;
    [[self fan_presentedViewController:vc] presentViewController:hud animated:NO completion:nil];
    return hud;
}
///弹窗icon对话框，单按钮
+ (instancetype)fan_showIconAlertTitle:(nullable NSString *)textStr imageName:(nullable NSString *)imageName buttonTitle:(nullable NSString *)buttonTitle fromVC:(nullable UIViewController*)vc alertBlock:(nullable FanDialogboxAlertBlock)alertBlock{
    return [self fan_showIconAlertTitle:textStr imageName:imageName buttonTitles:@[buttonTitle] fromVC:vc alertBlock:alertBlock];
}

+ (instancetype )fan_showIconAlertTitle:(nullable NSString *)textStr imageName:(nullable NSString *)imageName buttonTitles:(nullable NSArray*)btnTitleArray fromVC:(nullable UIViewController*)vc alertBlock:(nullable FanDialogboxAlertBlock)alertBlock{
    FanDialogboxController *hud = [[self alloc]init];
    hud.alertTitle=textStr;
    hud.iconName=imageName;
    hud.buttonTitleArray=btnTitleArray;
    hud.alertBlock = alertBlock;
    hud.dialogboxStyle=FanDialogboxStyleIconAlert;
    [hud configUIWithData];
    hud.definesPresentationContext=NO;
    hud.modalPresentationStyle=UIModalPresentationOverFullScreen;
    [[self fan_presentedViewController:vc] presentViewController:hud animated:NO completion:nil];
    return hud;
}


+ (BOOL)fan_hideDialogWithKey:(nullable NSString*)key{
    FanDialogboxController *vc=[[FanDialogboxController fan_dialogDictionary]objectForKey:key];
    if (vc) {
        [vc removeSelfView];
        [[FanDialogboxController fan_dialogDictionary]removeObjectForKey:key];
        return YES;
    }
    return NO;
}
+ (BOOL)fan_hideAllDialog{
    [[FanDialogboxController fan_dialogDictionary]enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, FanDialogboxController * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj removeSelfView];
    }];
    [[FanDialogboxController fan_dialogDictionary]removeAllObjects];
    return YES;
}
#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(instancetype)init{
    self=[super init];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit {
    self.view.backgroundColor=[UIColor clearColor];
    _showTime=-1;
    _isAnimation=YES;
    _isTouchRemove=YES;//是否支持触摸空白区域消失
    _isAutoRemove=YES;
    _dialogboxStyle=FanDialogboxStyleText;
    _textColor=[UIColor colorWithRed:120/255.0 green:124/255.0 blue:176/255.0 alpha:1];
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
        if (@available(iOS 10.0, *)) {
            __weak typeof(self)weakSelf=self;
            self.afterTimer = [NSTimer scheduledTimerWithTimeInterval:weakSelf.showTime repeats:NO block:^(NSTimer * _Nonnull timer) {
                __strong typeof(self)strongSelf=weakSelf;
                [strongSelf hiddenTimer];
            }];
        }else{
            self.afterTimer = [NSTimer scheduledTimerWithTimeInterval:self.showTime target:self selector:@selector(hiddenTimer) userInfo:nil repeats:NO];
        }
    }
    self.blackAlphaView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.blackAlphaView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
    self.blackAlphaView.clipsToBounds=YES;
    [self.view addSubview:self.blackAlphaView];
    
    self.blackAlphaView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
 
    [self fan_configUI];
    

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.view.alpha=0;
//        [UIView animateWithDuration:0.3 animations:^{
//            self.view.alpha=1;
//        }];
//    });
}
-(void)fan_configUI{
    switch (self.dialogboxStyle) {
        case FanDialogboxStyleText:
        {
            self.contentHeight=64;
            self.contentWidth=254;
            self.isTouchRemove=NO;
        }
            break;
        case FanDialogboxStyleLoding:
        {
            self.contentHeight=64;
            self.contentWidth=94;
            self.isTouchRemove=NO;
        }
            break;
        case FanDialogboxStyleLodingText:
        {
            self.contentHeight=64*1.5;
            self.contentWidth=94*1.5;
            self.isTouchRemove=NO;
        }
            break;
        case FanDialogboxStyleAlert:
        {
            self.contentHeight=145;
            self.contentWidth=254;
            self.isTouchRemove=NO;
        }
            break;
        case FanDialogboxStyleIconAlert:
        {
            self.contentHeight=145;
            self.contentWidth=254;
            self.isTouchRemove=NO;
        }
            break;
        default:
        {
            self.contentHeight=[FanUIKit fan_mainScreen].bounds.size.height;
            self.contentWidth=[FanUIKit fan_mainScreen].bounds.size.width;
            self.isTouchRemove=NO;
        }
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
    _cententBgmView.backgroundColor=[UIColor colorWithWhite:1.0 alpha:1.0];
    [self.fan_cententView addSubview:_cententBgmView];
    
    switch (self.dialogboxStyle) {
        case FanDialogboxStyleText:
        {
            [self fan_createTextUI];
        }
            break;
        case FanDialogboxStyleLoding:
        {
            [self fan_createLodingUI];
        }
            break;
        case FanDialogboxStyleLodingText:
        {
            [self fan_createLodingUI];
        }
            break;
        case FanDialogboxStyleAlert:
        {
            [self fan_createAlertUI];
        }
            break;
        case FanDialogboxStyleIconAlert:
        {
            [self fan_createIconAlertUI];
        }
            break;
        default:
            break;
    }
    
}

-(void)fan_createTextUI{
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, 8, self.contentWidth-16, self.contentHeight-16)];
    titleLabel.text=self.alertTitle;
    titleLabel.textColor=self.textColor;
    titleLabel.font=[UIFont systemFontOfSize:17];
    titleLabel.numberOfLines=0;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth=YES;
    [self.fan_cententView addSubview:titleLabel];
    _textLabel=titleLabel;
}
-(void)fan_createLodingUI{
    UIActivityIndicatorView *lodingImgView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    [lodingImgView startAnimating];
    [self.fan_cententView addSubview:lodingImgView];
    
    if (self.alertTitle.length>0) {
        lodingImgView.transform=CGAffineTransformMakeScale(1.5f, 1.5f);
        lodingImgView.center=CGPointMake(self.contentWidth/2.0f, self.contentHeight/2.0f-10);
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(3, self.contentHeight-35, self.contentWidth-6, 30)];
        titleLabel.text=self.alertTitle;
        titleLabel.textColor=self.textColor;
        titleLabel.numberOfLines=0;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.adjustsFontSizeToFitWidth=YES;
        titleLabel.font=[UIFont systemFontOfSize:12];
        [self.fan_cententView addSubview:titleLabel];
        _textLabel=titleLabel;
    }else{
        lodingImgView.center=CGPointMake(self.contentWidth/2.0f, self.contentHeight/2.0f);
    }
}
-(void)fan_createAlertUI{
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, self.contentWidth-40, 20)];
    titleLabel.text=self.alertTitle;
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.font=[UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth=YES;
    [self.fan_cententView addSubview:titleLabel];
    _textLabel=titleLabel;
    
    UILabel *subLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 35, self.contentWidth-40, 60)];
    subLabel.text=self.subTitle;
    subLabel.textColor=self.textColor;
    subLabel.font=[UIFont systemFontOfSize:14];
    subLabel.textAlignment=NSTextAlignmentCenter;
    subLabel.numberOfLines=0;
    subLabel.adjustsFontSizeToFitWidth=YES;
    [self.fan_cententView addSubview:subLabel];
    _subTextLabel=subLabel;
    
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
    subLabel.textColor=self.textColor;
    subLabel.font=[UIFont systemFontOfSize:12];
    subLabel.textAlignment=NSTextAlignmentCenter;
    subLabel.numberOfLines=0;
    subLabel.adjustsFontSizeToFitWidth=YES;
    [self.fan_cententView addSubview:subLabel];
    _textLabel=subLabel;
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
        UIColor *themeColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:232/255.0 alpha:1];
        [btn setTitleColor:themeColor forState:UIControlStateNormal];
        btn.tag=100+i;
        [btn setTitle:self.buttonTitleArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.fan_cententView addSubview:btn];
    }
}
#pragma mark - 修改内容属性
-(void)fan_setTitleColor:(nullable UIColor *)titleColor subTitleColor:(nullable UIColor *)subTitleColor{
    if (titleColor) {
        _textLabel.textColor=titleColor;
    }
    if (subTitleColor) {
        _subTextLabel.textColor=subTitleColor;
    }
    
}
-(void)fan_setTitleColor:(nullable UIColor *)titleColor{
    [self fan_setTitleColor:titleColor subTitleColor:nil];
}

#pragma mark - 移除View
-(void)buttonClick:(UIButton *)btn{
    if (self.alertBlock) {
        self.alertBlock(btn.tag-100);
    }
    if (self.isAutoRemove) {
        [self removeSelfView];
    }
}
-(void)hiddenTimer{
    //时间结束自动移除
    [_afterTimer setFireDate:[NSDate distantFuture]];
    [_afterTimer invalidate];
    _afterTimer=nil;
    
    
    [self removeSelfView];
}
-(void)removeSelfView{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.isTouchRemove) {
        CGPoint touchPoint=[[touches anyObject]locationInView:self.view];
        if (touchPoint.y<self.fan_cententView.frame.origin.y||touchPoint.x<self.fan_cententView.frame.origin.x||touchPoint.y>self.fan_cententView.frame.origin.y+self.fan_cententView.frame.size.height||touchPoint.x>self.fan_cententView.frame.origin.x+self.fan_cententView.frame.size.width) {
            [self removeSelfView];
        }
    }
}
#pragma mark - 辅助方法
+(UIViewController *)fan_presentedViewController:(UIViewController *)viewController{
    while (viewController.presentedViewController)
    {
        viewController = viewController.presentedViewController;
    }
    return viewController;
}
//求字符串
-(CGSize)fan_currentSizeWithContent:(nullable NSString *)content font:(nullable UIFont *)font cgSize:(CGSize)cgsize{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size=[content boundingRectWithSize:cgsize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
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
