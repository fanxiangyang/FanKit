//
//  FanShowAlertView.h
//  FanShowView
//
//  Created by 向阳凡 on 16/1/13.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import "FanShowView.h"

@interface FanShowAlertView : FanShowView

@property(nonatomic,strong,nullable)NSMutableArray<UIButton *> *buttonArray;
@property(nonatomic,strong,nullable)NSMutableArray<UITextField *> *textFiledArray;

-(nullable instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id )delegate otherButtonTitles:(nullable NSArray *)otherButtonTitles;
-(void)addButtonTitle:(nullable NSString *)buttonTitle;



@end
