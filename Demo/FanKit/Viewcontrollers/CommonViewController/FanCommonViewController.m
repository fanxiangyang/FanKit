//
//  FanCommonViewController.m
//  FanKit
//
//  Created by 向阳凡 on 2017/3/10.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanCommonViewController.h"
#import "FanKit.h"

@interface FanCommonViewController ()

@end

@implementation FanCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}
-(void)configUI{
    CGFloat top=50.0f;
    self.title=_rootDictionary[@"Title"];
    NSString *classStr=[NSString stringWithFormat:@"Class:%@",_rootDictionary[@"Class"]];
    NSString *demoStr=[NSString stringWithFormat:@"Demo:%@",_rootDictionary[@"Demo"]];
    UILabel *titleLable=[FanUIKit fan_createLabelWithFrame:CGRectMake(20, top, FanScreenWidth-40, 20) Font:17 Text:classStr];
    titleLable.adjustsFontSizeToFitWidth=YES;
    [titleLable setTextColor:FanColor(3, 103, 214, 1)];
    [self.view addSubview:titleLable];
    
    UILabel *demoLable=[FanUIKit fan_createLabelWithFrame:CGRectMake(20, top+30, FanScreenWidth-40, 40) Font:17 Text:demoStr];
    demoLable.adjustsFontSizeToFitWidth=YES;
    demoLable.numberOfLines=0;
    [demoLable setTextColor:FanColor(3, 0, 204, 1)];
    [self.view addSubview:demoLable];

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
