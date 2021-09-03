//
//  FanDeviceOrientation.h
//  FanDeviceOrientation
//
//  Created by Fan  on 2021/08/25.
//  Copyright © 2021年 . All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,FanDirection) {
    FanDirectionUnkown,
    FanDirectionPortrait,
    FanDirectionDown,
    FanDirectionRight,
    FanDirectionleft,
};

@protocol FanDeviceOrientationDelegate <NSObject>

- (void)directionChange:(FanDirection)direction;

@end
@interface FanDeviceOrientation : NSObject

@property(nonatomic,weak)id<FanDeviceOrientationDelegate>delegate;

- (instancetype)initWithDelegate:(id<FanDeviceOrientationDelegate>)delegate;
/**
 开启监听
 */
- (void)startMonitor;
/**
 结束监听，请stop
 */
- (void)stop;

@end
