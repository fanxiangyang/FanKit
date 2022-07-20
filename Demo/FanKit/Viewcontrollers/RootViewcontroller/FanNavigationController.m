//
//  FanNavigationController.m
//  FanKit
//
//  Created by 向阳凡 on 16/7/5.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import "FanNavigationController.h"

@interface FanNavigationController ()

@end

@implementation FanNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航为不透明
    self.navigationBar.translucent=NO;
    self.view.backgroundColor=[UIColor whiteColor];

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
