//
//  FanActionSheetView.h
//  FanShowView
//
//  Created by 向阳凡 on 16/1/18.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import "FanShowView.h"

@interface FanActionSheetView : FanShowView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong,nullable)UITableView *fan_tableView;



-(nullable instancetype)initWithDataArray:(nullable NSArray *)dataArray delegate:(nullable id )delegate;

@end
