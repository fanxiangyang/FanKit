//
//  FanDeviceOrientation.h
//  FanDeviceOrientation
//
//  Created by Fan  on 2021/08/25.
//  Copyright © 2021年 . All rights reserved.
//

#import "FanDeviceOrientation.h"
#import <CoreMotion/CoreMotion.h>

@interface FanDeviceOrientation () {
    
    CMMotionManager *_motionManager;
    FanDirection _direction;
    
}
@end
//sensitive 灵敏度
static const float sensitive = 0.77;

@implementation FanDeviceOrientation

- (instancetype)initWithDelegate:(id<FanDeviceOrientationDelegate>)delegate {
    self = [super init];
    if (self) {
        
        _delegate = delegate;
    }
    return self;
}
- (void)startMonitor {
    
    [self start];
}

- (void)stop {
    
    [_motionManager stopDeviceMotionUpdates];
}


//陀螺仪 每隔一个间隔做轮询
- (void)start{
    
    if (_motionManager == nil) {
        
        _motionManager = [[CMMotionManager alloc] init];
    }
    _motionManager.deviceMotionUpdateInterval = 1/40.f;
    if (_motionManager.deviceMotionAvailable) {
        
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler: ^(CMDeviceMotion *motion, NSError *error){
            [self performSelectorOnMainThread:@selector(deviceMotion:) withObject:motion waitUntilDone:YES];
        }];
    }
}
- (void)deviceMotion:(CMDeviceMotion *)motion{
    
    double x = motion.gravity.x;
    double y = motion.gravity.y;
    if (y < 0 ) {
        if (fabs(y) > sensitive) {
            if (_direction != FanDirectionPortrait) {
                _direction = FanDirectionPortrait;
                if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
                    [self.delegate directionChange:_direction];
                }
            }
        }
    }else {
        if (y > sensitive) {
            if (_direction != FanDirectionDown) {
                _direction = FanDirectionDown;
                if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
                    [self.delegate directionChange:_direction];
                }
            }
        }
    }
    if (x < 0 ) {
        if (fabs(x) > sensitive) {
            if (_direction != FanDirectionleft) {
                _direction = FanDirectionleft;
                if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
                    [self.delegate directionChange:_direction];
                }
            }
        }
    }else {
        if (x > sensitive) {
            if (_direction != FanDirectionRight) {
                _direction = FanDirectionRight;
                if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
                    [self.delegate directionChange:_direction];
                }
            }
        }
    }
}

@end
