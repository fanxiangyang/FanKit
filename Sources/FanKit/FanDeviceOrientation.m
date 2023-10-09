//
//  FanDeviceOrientation.h
//  FanDeviceOrientation
//
//  Created by Fan  on 2021/08/25.
//  Copyright © 2021年 . All rights reserved.
//

#import "FanDeviceOrientation.h"
#import <CoreMotion/CoreMotion.h>

@interface FanDeviceOrientation ()

@property (nonatomic,assign) FanDirection direction;
@property (nonatomic,strong) CMMotionManager *motionManager;

@end
//sensitive 灵敏度（模仿实际屏幕旋转)
static const float sensitive = 0.77;

@implementation FanDeviceOrientation

- (instancetype)initWithDelegate:(id<FanDeviceOrientationDelegate>)delegate {
    self = [super init];
    if (self) {
        
        self.delegate = delegate;
    }
    return self;
}
- (void)startMonitor {
    
    [self start];
}

- (void)stop {
    
    [self.motionManager stopDeviceMotionUpdates];
}


//陀螺仪 每隔一个间隔做轮询
- (void)start{
    
    if (self.motionManager == nil) {
        
        self.motionManager = [[CMMotionManager alloc] init];
    }
    self.motionManager.deviceMotionUpdateInterval = 1/40.f;
    if (self.motionManager.deviceMotionAvailable) {
        
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler: ^(CMDeviceMotion *motion, NSError *error){
            [self performSelectorOnMainThread:@selector(deviceMotion:) withObject:motion waitUntilDone:YES];
        }];
    }
}
- (void)deviceMotion:(CMDeviceMotion *)motion{
    
    double x = motion.gravity.x;
    double y = motion.gravity.y;
//    NSLog(@"陀螺仪：x:%f,y:%f",x,y);
    if(fabs(x)<fabs(y)){
        if (y < 0 ) {
            if (self.simulateRotation == NO || (fabs(y) > sensitive)) {
                if (self.direction != FanDirectionPortrait) {
                    self.direction = FanDirectionPortrait;
                    if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
                        [self.delegate directionChange:self.direction];
                    }
                }
            }
        }else {
            if (self.simulateRotation == NO ||  y > sensitive) {
                if (self.direction != FanDirectionDown) {
                    self.direction = FanDirectionDown;
                    if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
                        [self.delegate directionChange:self.direction];
                    }
                }
            }
        }
    }else{
        if (x < 0 ) {
            if (self.simulateRotation == NO || fabs(x) > sensitive) {
                if (self.direction != FanDirectionleft) {
                    self.direction = FanDirectionleft;
                    if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
                        [self.delegate directionChange:self.direction];
                    }
                }
            }
        }else {
            if (self.simulateRotation == NO || x > sensitive) {
                if (self.direction != FanDirectionRight) {
                    self.direction = FanDirectionRight;
                    if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
                        [self.delegate directionChange:self.direction];
                    }
                }
            }
        }
    }
}

@end
