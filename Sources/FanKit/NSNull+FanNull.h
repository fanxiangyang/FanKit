//
//  NSNull+FanNull.h
//  FanKit
//
//  Created by 向阳凡 on 16/7/4.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 *
 *  服务器有时候会给我们NSNull 导致程序崩溃
 *  这个Categories是为了在服务器给我们传NSNull的时候也不要导致崩溃
 *  通过cocoa消息传递机制 把NSNull换成 @"",@0,@{},@[]其中之一去接受导致崩溃的消息 保证程序跳过crash
 *  只在需要此类的.m中引入
 *
 */
@interface NSNull (FanNull)

@end
