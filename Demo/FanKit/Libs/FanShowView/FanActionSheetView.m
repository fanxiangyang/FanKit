//
//  FanActionSheetView.m
//  FanShowView
//
//  Created by 向阳凡 on 16/1/18.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import "FanActionSheetView.h"

@implementation FanActionSheetView
-(nullable instancetype)initWithDataArray:(nullable NSArray *)dataArray delegate:(nullable id )delegate{
    self=[super initWithStyle:FanShowViewStyleActionSheet];
    if (self) {
        self.delegate=delegate;
        self.dataArray=[dataArray mutableCopy];
    }
    return self;
}
-(void)layoutSubviews{
    if ([self.fan_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.fan_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.fan_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.fan_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
#pragma mark - 重写父类方法
-(void)configUIWithData{
    [super configUIWithData];
    
    self.contentHeight=44*self.dataArray.count;
    
    self.fan_cententView=[[UIView alloc]initWithFrame:CGRectMake(0, kFanScreenHeight_Show-self.contentHeight, kFanScreenWidth_Show, self.contentHeight)];
    //    self.fan_cententView.center=self.center;
    self.fan_cententView.backgroundColor=[UIColor whiteColor];
    [self addSubview:self.fan_cententView];
    
    self.fan_cententView.layer.cornerRadius=8;
    self.fan_cententView.clipsToBounds=YES;
    
    
    self.fan_tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kFanScreenWidth_Show, self.contentHeight) style:UITableViewStylePlain];
//    self.fan_tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    self.fan_tableView.separatorInset=UIEdgeInsetsZero;
    self.fan_tableView.delegate=self;
    self.fan_tableView.dataSource=self;
    [self.fan_cententView addSubview:self.fan_tableView];
    [self.fan_cententView.layer addAnimation:[FanActionSheetView fan_transitionAnimationWithSubType:kCATransitionFromTop withType:kCATransitionPush duration:0.3f] forKey:@"animation"];
 
    
}

-(void)removeSelfView{
    [super removeSelfView];
    
    [self.fan_cententView setFrame:CGRectMake(0, kFanScreenHeight_Show, kFanScreenWidth_Show, self.contentHeight)];
    [self.fan_cententView.layer addAnimation:[FanActionSheetView fan_transitionAnimationWithSubType:kCATransitionFromBottom withType:kCATransitionPush duration:0.3f] forKey:@"animation"];
}

#pragma mark - tableView delegate  dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text=self.dataArray[indexPath.row];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
//    cell.detailTextLabel.text=@"凡向阳";
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showViewDidSeletedIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
