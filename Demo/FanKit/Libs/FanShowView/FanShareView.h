//
//  FanShareView.h
//  FanShowView
//
//  Created by 向阳凡 on 16/1/19.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import "FanShowView.h"

@interface FanShareView : FanShowView

@property(nonatomic,strong,nullable)NSMutableArray *titleArray;


-(nullable instancetype)initWithDataArray:(nullable NSArray *)dataArray titleArray:(nullable NSArray *)titleArray delegate:(nullable id )delegate;

@end
