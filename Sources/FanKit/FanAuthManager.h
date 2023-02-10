//
//  FanAuthManager.h
//  FanKit
//
//  Created by 向阳凡 on 2022/7/13.
//  Copyright © 2022 凡向阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FanAuthManager : NSObject
///单利
+(instancetype)shareManager;


#pragma mark - 相册权限
/// 请求相册读写权限
/// @param albumBlock （-2 用户点击不允许  -1本来就没有权限  0- 询问  1允许）
+(void)requestAlbumAuthorizationBlock:(void(^)(NSInteger status))albumBlock;
/// 当前相册读写权限（ -1本来就没有权限  0- 询问  1允许）
+(NSInteger)albumAuthorizationStatus;
/// 请求相册读权限-（只有写iOS14+）
/// @param albumBlock （-2 用户点击不允许  -1本来就没有权限  0- 询问  1允许）
+(void)requestAlbumAuthorizationOnlyWriteBlock:(void(^)(NSInteger status))albumBlock;
/// 当前相册（只有写）权限iOS14+（ -1本来就没有权限  0- 询问  1允许）
+(NSInteger)albumAuthorizationStatusOnlyWrite;
/// 保存到相册-图片UIImage、视频NSString
/// - Parameters:
///   - data: UIImage NSString NSURL
///   - isImage: 是否是图片还是视频
///   - completion: （isSuccess=成功、失败，identifier=相册标识符）
+(void)saveToAlbum:(id)data isImage:(BOOL)isImage completion:(void (^)(BOOL isSuccess,NSString *_Nullable identifier))completion;
#pragma mark - 相机麦克风权限
// ???: 为什么权限回调不执行
// 请求权限与dispatch_group_wait有冲突，导致回调不执行，请使用嵌套权限处理
/// 请求相机权限
/// @param avBlock 【-1=不允许 -2 =用户点击不允许 0 = 弹窗询问 1=允许】
+(void)requestAVAuthorizationBlock:(void(^)(NSInteger status))avBlock;
/// 请求相机麦克风权限
/// @param mediaType 相机和麦克风 AVMediaTypeVideo/AVMediaTypeAudio
/// @param avBlock 【-1=不允许 -2 =用户点击不允许 0 = 弹窗询问 1=允许】
+(void)requestAVAuthorizationWithMediaType:(AVMediaType)mediaType avBlock:(void(^)(NSInteger status))avBlock;
/// 请求相机麦克风权限【-1=不允许 -2 =用户点击不允许 0 = 弹窗询问 1=允许】
/// @param mediaType 相机和麦克风 AVMediaTypeVideo/AVMediaTypeAudio
+(NSInteger)avAuthorizationStatusWithMediaType:(AVMediaType)mediaType;
#pragma mark - 定位权限状态

/// 获取当前定位权限 0=询问 1=允许  -1服务关闭 -2=不允许 -3=无法授权
+(NSInteger)locationAuthorizationStatus;

@end

NS_ASSUME_NONNULL_END
