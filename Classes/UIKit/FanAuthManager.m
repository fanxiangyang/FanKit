//
//  FanAuthManager.m
//  FanKit
//
//  Created by 向阳凡 on 2022/7/13.
//  Copyright © 2022 凡向阳. All rights reserved.
//

#import "FanAuthManager.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation FanAuthManager

///单利
+(instancetype)shareManager{
    static FanAuthManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[FanAuthManager alloc]init];
    });
    return manager;
}

#pragma mark - 相册权限
/// 请求相册权限
/// @param albumBlock （-2 用户点击不允许  -1本来就没有权限  0- 询问  1允许）
+(void)requestAlbumAuthorizationBlock:(void(^)(NSInteger status))albumBlock{
    PHAuthorizationStatus photoAuthorStatus=0;
    if (@available(iOS 14, *)) {
        PHAccessLevel level = PHAccessLevelReadWrite;
        photoAuthorStatus = [PHPhotoLibrary authorizationStatusForAccessLevel:level];
    } else {
        photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    }
    if (photoAuthorStatus==PHAuthorizationStatusDenied||photoAuthorStatus==PHAuthorizationStatusRestricted) {
        //用户拒绝当前应用访问相册,我们需要提醒用户打开访问开关 ||  不允许访问
        if (albumBlock) {
            albumBlock(-1);
        }
    }else if (photoAuthorStatus==PHAuthorizationStatusNotDetermined){
        //获取用户对是否允许访问相册的操作
        if (@available(iOS 14, *)) {
            [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized||status== PHAuthorizationStatusLimited) {
                    if (albumBlock) {
                        albumBlock(1);
                    }
                }else{
                    if (albumBlock) {
                        albumBlock(-2);
                    }
                }
            }];
        } else {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status==PHAuthorizationStatusAuthorized) {
                    if (albumBlock) {
                        albumBlock(1);
                    }
                }else{
                    if (albumBlock) {
                        albumBlock(-2);
                    }
                }
            }];
        }
        if (albumBlock) {
            albumBlock(0);
        }
        return;
    }else{
        //允许访问  PHAuthorizationStatusAuthorized  PHAuthorizationStatusLimited
        if (albumBlock) {
            albumBlock(1);
        }
    }
}
#pragma mark - 相机权限
/// 请求相机权限
/// @param avBlock 【-1=不允许 -2 =用户点击不允许 0 = 弹窗询问 1=允许】
+(void)requestAVAuthorizationBlock:(void(^)(NSInteger status))avBlock{
    //判断摄像头权限
    AVAuthorizationStatus deviceStatus=[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (deviceStatus == AVAuthorizationStatusRestricted||deviceStatus==AVAuthorizationStatusDenied) {
        if (avBlock) {
            avBlock(-1);
        }
    }else if (deviceStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    //用户接受授权
                    if (avBlock) {
                        avBlock(1);
                    }
                }else{
                    if (avBlock) {
                        avBlock(-2);
                    }
                }
            });
        }];
        if (avBlock) {
            avBlock(0);
        }
    }else{
        if (avBlock) {
            avBlock(1);
        }
    }
}
@end
