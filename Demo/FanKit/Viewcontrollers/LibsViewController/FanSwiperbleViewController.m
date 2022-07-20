//
//  FanSwiperbleViewController.m
//  FanKit
//
//  Created by 向阳凡 on 2017/3/10.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanSwiperbleViewController.h"
#import "FanSwiperbleView.h"

@interface FanSwiperbleViewController ()<FanSwipeableViewDataSource,FanSwipeableViewDelegate>

@property(nonatomic,strong)FanSwiperbleView *swipeableView;
@property(nonatomic,strong)NSMutableArray *dataArry;
@property (nonatomic) NSUInteger indexRow;
@end

@implementation FanSwiperbleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.dataArry=[[NSMutableArray alloc]initWithObjects:@"swip1.jpg",@"swip2.jpg",@"peerImage.png",@"swip1.jpg",@"swip2.jpg",@"peerImage.png",@"swip1.jpg",@"swip2.jpg",@"peerImage.png", nil];
    
    self.swipeableView=[[FanSwiperbleView alloc]initWithFrame:CGRectMake(30, 50, kFanWidth-60, kFanHeight-250)];
    self.swipeableView.backgroundColor=[UIColor colorWithWhite:0.7 alpha:1];
    self.swipeableView.delegate=self;
    self.swipeableView.dataSource=self;
    [self.view addSubview:self.swipeableView];
    // Do any additional setup after loading the view.
    
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"ReloadData" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.titleLabel.adjustsFontSizeToFitWidth=YES;
    button.backgroundColor=[UIColor orangeColor];
    button.frame=CGRectMake(FanScreenWidth/2-100, FanScreenHeight-150, 200, 40);
    button.tag=100;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}
-(void)buttonClick:(UIButton *)btn{
    _indexRow=0;
    [self.swipeableView fan_reloadData];
}
#pragma mark - dataSource
-(NSInteger)numberOfSwipeableShow{
    return 3;
}

-(UIView *)nextViewForSwipeableView:(FanSwiperbleView *)swipeableView{
    if (_indexRow<_dataArry.count) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:swipeableView.bounds];
        view.image=[UIImage imageNamed:_dataArry[_indexRow]];
        view.contentMode=UIViewContentModeScaleAspectFill;
        _indexRow++;
        return view;
    }
    return nil;
    
}
#pragma mark - delegate
-(void)fan_swipeableView:(FanSwiperbleView *)swiperbleView leaveView:(id<UIDynamicItem>)leaveView{
    
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
