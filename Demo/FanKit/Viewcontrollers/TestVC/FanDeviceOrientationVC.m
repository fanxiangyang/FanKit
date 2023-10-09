//
//  FanDeviceOrientationVC.m
//  FanKit
//
//  Created by 向阳凡 on 2023/10/9.
//  Copyright © 2023 凡向阳. All rights reserved.
//

#import "FanDeviceOrientationVC.h"
#import "FanDeviceOrientation.h"

@interface FanDeviceOrientationVC ()<FanDeviceOrientationDelegate>
///三轴陀螺仪判断设备方向
@property(nonatomic,strong)FanDeviceOrientation *deviceMotion;
//通过加速计判断当前设备方向
@property (nonatomic, assign)UIDeviceOrientation currentDeviceOrientation;
@property (nonatomic,strong) UILabel *textLabel;

@end

@implementation FanDeviceOrientationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //判断设备方向
    self.deviceMotion = [[FanDeviceOrientation alloc]initWithDelegate:self];
    
    self.textLabel = [FanUIKit fan_createLabelWithFrame:CGRectMake(50, 100, FanWidth-100, FanHeight/2.0f-50) text:@"设备方向" textColor:[UIColor grayColor]];
    [self.view addSubview:self.textLabel];
    
    [self.deviceMotion startMonitor];
}
-(void)dealloc{
    [self.deviceMotion stop];
}
#pragma mark FanDeviceOrientationDelegate
///三轴陀螺仪 设备方向改变
-(void)directionChange:(FanDirection)direction{
    NSString *cStr = @"";
    switch (direction) {
        case FanDirectionPortrait:
            cStr = @"竖着";
            self.currentDeviceOrientation = UIDeviceOrientationPortrait;
            break;
        case FanDirectionDown:
            cStr = @"倒着";
            self.currentDeviceOrientation = UIDeviceOrientationPortraitUpsideDown;
            break;
        case FanDirectionRight:
            cStr = @"home在左手";
            self.currentDeviceOrientation = UIDeviceOrientationLandscapeRight;
            break;
        case FanDirectionleft:
            cStr = @"home在右手";
            self.currentDeviceOrientation = UIDeviceOrientationLandscapeLeft;
            break;
            
        default:
            break;
    }
    NSString *logStr = [NSString stringWithFormat:@"设备当前方向：%@=%ld",cStr, self.currentDeviceOrientation];
    NSLog(@"%@",logStr);
    self.textLabel.text = logStr;
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
