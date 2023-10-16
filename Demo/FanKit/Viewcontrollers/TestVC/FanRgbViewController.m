//
//  FanRgbViewController.m
//  FanKit
//
//  Created by 向阳凡 on 2020/10/17.
//  Copyright © 2020 凡向阳. All rights reserved.
//

#import "FanRgbViewController.h"
#import "FanRgbView.h"
#import "FanColorView.h"

@interface FanRgbViewController ()

@end

@implementation FanRgbViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}
-(void)configUI{
    CGFloat w=FanWidth;
//    CGFloat h=FanHeight;
    CGFloat top=0;
    
    //圆形  色域+饱和度 H+S
    FanRgbView *rgbView1=[[FanRgbView alloc]initWithFrame:CGRectMake(0, top, w*0.4, w*0.4)];
    rgbView1.backgroundColor=[UIColor clearColor];
    rgbView1.isVertical=YES;
    rgbView1.rgbColor=[UIColor redColor];
    [self.view addSubview:rgbView1];
    [rgbView1 fan_drawStyle:FanHSVTypeCicle_HS];
    //矩形  色域 H
    FanRgbView *rgbView12=[[FanRgbView alloc]initWithFrame:CGRectMake(w-w*0.4, top, w*0.4, w*0.4)];
    rgbView12.backgroundColor=[UIColor clearColor];
    rgbView12.isVertical=YES;
    rgbView12.rgbColor=[UIColor redColor];
    [self.view addSubview:rgbView12];
    [rgbView12 fan_drawStyle:FanHSVTypeRect_H];
    
    top=w*0.4;
    //矩形  亮度 L
    FanRgbView *rgbView2=[[FanRgbView alloc]initWithFrame:CGRectMake(0, top, w*0.4, 32)];
    rgbView2.backgroundColor=[UIColor clearColor];
    rgbView2.isVertical=NO;
    rgbView2.rgbColor=[UIColor redColor];
    rgbView2.hsvView.layer.cornerRadius=8;
    rgbView2.hsvView.clipsToBounds=YES;
    [self.view addSubview:rgbView2];
    [rgbView2 fan_drawStyle:FanHSVTypeRect_L];
    
    //矩形  饱和度 S
    FanRgbView *rgbView3=[[FanRgbView alloc]initWithFrame:CGRectMake(w-w*0.4, top, w*0.4, 32)];
    rgbView3.backgroundColor=[UIColor clearColor];
    rgbView3.isVertical=NO;
    rgbView3.panCenter=YES;//只能居中拖动
    rgbView3.rgbColor=[UIColor redColor];
    rgbView3.hsvView.layer.cornerRadius=8;
    rgbView3.hsvView.clipsToBounds=YES;
    [self.view addSubview:rgbView3];
    [rgbView3 fan_drawStyle:FanHSVTypeRect_S];
    
    top+=50;
    
    //矩形  饱和度+亮度 S+L
    FanRgbView *rgbView4=[[FanRgbView alloc]initWithFrame:CGRectMake(20, top, w*0.4, w*0.6)];
    rgbView4.backgroundColor=[UIColor clearColor];
    rgbView4.rgbColor=[UIColor redColor];
    [self.view addSubview:rgbView4];
    [rgbView4 fan_drawStyle:FanHSVTypeRect_SL];
    
    
    [rgbView1 setRgbBlock:^(FanRgbView * _Nullable rgbView, UIColor * _Nullable rgbColor, FanHSVTouchType touchType) {
        if (rgbColor) {
            self.view.backgroundColor=rgbColor;
        }
    }];
    
    [rgbView2 setRgbBlock:^(FanRgbView * _Nullable rgbView, UIColor * _Nullable rgbColor, FanHSVTouchType touchType) {
        if (rgbColor) {
            self.view.backgroundColor=rgbColor;
        }
    }];
    
    [rgbView3 setRgbBlock:^(FanRgbView * _Nullable rgbView, UIColor * _Nullable rgbColor, FanHSVTouchType touchType) {
        if (rgbColor) {
            self.view.backgroundColor=rgbColor;
        }
    }];
    [rgbView4 setRgbBlock:^(FanRgbView * _Nullable rgbView, UIColor * _Nullable rgbColor, FanHSVTouchType touchType) {
        if (rgbColor) {
            self.view.backgroundColor=rgbColor;
        }
    }];
    [rgbView12 setRgbBlock:^(FanRgbView * _Nullable rgbView, UIColor * _Nullable rgbColor, FanHSVTouchType touchType) {
        if (rgbColor) {
            self.view.backgroundColor=rgbColor;
        }
    }];
    
    FanColorView *cView = [[FanColorView alloc]initWithFrame:CGRectMake(40+w*0.4, top, w*0.3, w*0.3)];
//    cView.startDepthColor = [UIColor redColor];
    [cView initWithColorType:0];
    [self.view addSubview:cView];

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
