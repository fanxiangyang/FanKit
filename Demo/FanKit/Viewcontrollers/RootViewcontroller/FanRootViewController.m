//
//  FanRootViewController.m
//  FanKit
//
//  Created by 向阳凡 on 16/7/5.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import "FanRootViewController.h"

@interface FanRootViewController ()

@end

@implementation FanRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fan_jumpVCWithName:(NSString *)name{
    UIViewController *vc=[FanUIKit fan_classFromName:name];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
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
