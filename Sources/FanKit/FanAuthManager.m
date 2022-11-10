//
//  FanAuthManager.m
//  FanKit
//
//  Created by 向阳凡 on 2022/7/13.
//  Copyright © 2022 凡向阳. All rights reserved.
//

#import "FanAuthManager.h"
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>


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
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusAuthorized||status== PHAuthorizationStatusLimited) {
                        if (albumBlock) {
                            albumBlock(1);
                        }
                    }else{
                        if (albumBlock) {
                            albumBlock(-2);
                        }
                    }
                });
            }];
        } else {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status==PHAuthorizationStatusAuthorized) {
                        if (albumBlock) {
                            albumBlock(1);
                        }
                    }else{
                        if (albumBlock) {
                            albumBlock(-2);
                        }
                    }
                });
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
/// 当前相册权限（ -1本来就没有权限  0- 询问  1允许）
+(NSInteger)albumAuthorizationStatus{
    PHAuthorizationStatus photoAuthorStatus=0;
    if (@available(iOS 14, *)) {
        PHAccessLevel level = PHAccessLevelReadWrite;
        photoAuthorStatus = [PHPhotoLibrary authorizationStatusForAccessLevel:level];
    } else {
        photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    }
    if (photoAuthorStatus==PHAuthorizationStatusDenied||photoAuthorStatus==PHAuthorizationStatusRestricted) {
        //用户拒绝当前应用访问相册,我们需要提醒用户打开访问开关 ||  不允许访问
        return -1;
    }else if (photoAuthorStatus==PHAuthorizationStatusNotDetermined){
        //获取用户对是否允许访问相册的操作
        return 0;
    }else{
        //允许访问  PHAuthorizationStatusAuthorized  PHAuthorizationStatusLimited
        return 1;
    }
}
#pragma mark - 相机麦克风权限
/// 请求相机权限
/// @param avBlock 【-1=不允许 -2 =用户点击不允许 0 = 弹窗询问 1=允许】
+(void)requestAVAuthorizationBlock:(void(^)(NSInteger status))avBlock{
    [FanAuthManager requestAVAuthorizationWithMediaType:AVMediaTypeVideo avBlock:avBlock];
}
/// 请求相机麦克风权限
/// @param mediaType 相机和麦克风 AVMediaTypeVideo/AVMediaTypeAudio
/// @param avBlock 【-1=不允许 -2 =用户点击不允许 0 = 弹窗询问 1=允许】
+(void)requestAVAuthorizationWithMediaType:(AVMediaType)mediaType avBlock:(void(^)(NSInteger status))avBlock{
    //判断摄像头权限
    AVAuthorizationStatus deviceStatus=[AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (deviceStatus == AVAuthorizationStatusRestricted||deviceStatus==AVAuthorizationStatusDenied) {
        if (avBlock) {
            avBlock(-1);
        }
    }else if (deviceStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
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
/// 请求相机麦克风权限【-1=不允许 -2 =用户点击不允许 0 = 弹窗询问 1=允许】
/// @param mediaType 相机和麦克风 AVMediaTypeVideo/AVMediaTypeAudio
+(NSInteger)avAuthorizationStatusWithMediaType:(AVMediaType)mediaType{
    //判断摄像头权限
    AVAuthorizationStatus deviceStatus=[AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (deviceStatus == AVAuthorizationStatusRestricted||deviceStatus==AVAuthorizationStatusDenied) {
        return -1;
    }else if (deviceStatus == AVAuthorizationStatusNotDetermined){
        return 0;
    }else{
        return 1;
    }
}

#pragma mark - 定位权限状态

/// 获取当前定位权限 0=询问 1=允许  -1服务关闭 -2=不允许 -3=无法授权
+(NSInteger)locationAuthorizationStatus{
    //确定用户的位置服务启用//位置服务是在设置中禁用
    if (![CLLocationManager locationServicesEnabled]){
        //定位服务已经关闭，请去设置界面打开该应用的定位权限！设置 > 隐私 > 位置 > 定位服务"
        return -1;
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
        //用户设置服务不允许"
        return -2;
    } if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted){
        //无法定位
        return -3;
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        return 0;
    }else{
        //kCLAuthorizationStatusAuthorizedAlways kCLAuthorizationStatusAuthorizedWhenInUse
        return 1;
    }
}
@end
