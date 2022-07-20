//
//  FanShareView.m
//  FanShowView
//
//  Created by 向阳凡 on 16/1/19.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import "FanShareView.h"

#define kFanShareWidth  57
#define kFanEachNum       4 //每行不要超过4个，

@implementation FanShareView
-(nullable instancetype)initWithDataArray:(nullable NSArray *)dataArray titleArray:(nullable NSArray *)titleArray delegate:(nullable id )delegate{
    self=[super initWithStyle:FanShowViewStyleShare];
    if (self) {
        self.delegate=delegate;
        self.dataArray=[dataArray mutableCopy];
        self.titleArray=[titleArray mutableCopy];
    }
    return self;
}
#pragma mark - 重写父类方法
-(void)configUIWithData{
    [super configUIWithData];
    
    CGFloat btnHeight=kFanShareWidth+13;
    CGFloat spaceWidth=(kFanScreenWidth_Show-kFanEachNum*kFanShareWidth)/(kFanEachNum+1);
    CGFloat spaceHeight=20;
    
    
    self.contentHeight=spaceHeight+(self.dataArray.count/kFanEachNum+(self.dataArray.count%kFanEachNum?1:0))*(btnHeight+spaceHeight)+44;
    
    self.fan_cententView=[[UIView alloc]initWithFrame:CGRectMake(0, kFanScreenHeight_Show-self.contentHeight, kFanScreenWidth_Show, self.contentHeight)];
    //    self.fan_cententView.center=self.center;
    self.fan_cententView.backgroundColor=[UIColor whiteColor];
    [self addSubview:self.fan_cententView];
    
    self.fan_cententView.layer.cornerRadius=8;
    self.fan_cententView.clipsToBounds=YES;
    
    [self.fan_cententView.layer addAnimation:[FanShareView fan_transitionAnimationWithSubType:kCATransitionFromTop withType:kCATransitionPush duration:0.3f] forKey:@"animation"];

    for (int i = 0; i <self.dataArray.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(spaceWidth+(i%kFanEachNum)*(kFanShareWidth+spaceWidth), spaceHeight+(i/kFanEachNum)*(btnHeight+spaceHeight), kFanShareWidth, btnHeight)];
        btn.tag = 100+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 13, 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(kFanShareWidth+10, -1*kFanShareWidth, 0, 0);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:self.dataArray[i]] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.fan_cententView addSubview:btn];
        
    }
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelBtn setFrame:CGRectMake(0, self.contentHeight-45, kFanScreenWidth_Show, 45)];
    cancelBtn.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(removeSelfView) forControlEvents:UIControlEventTouchUpInside];
    [self.fan_cententView addSubview:cancelBtn];
    
}

-(void)removeSelfView{
    [super removeSelfView];
    
    [self.fan_cententView setFrame:CGRectMake(0, kFanScreenHeight_Show, kFanScreenWidth_Show, self.contentHeight)];
    [self.fan_cententView.layer addAnimation:[FanShareView fan_transitionAnimationWithSubType:kCATransitionFromBottom withType:kCATransitionPush duration:0.3f] forKey:@"animation"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
