//
//  FanAuthManager.h
//  FanKit
//
//  Created by 向阳凡 on 2022/7/13.
//  Copyright © 2022 凡向阳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FanAuthManager : NSObject
///单利
+(instancetype)shareManager;


#pragma mark - 相册权限
/// 请求相册权限
/// @param albumBlock （-2 用户点击不允许  -1本来就没有权限  0- 询问  1允许）
+(void)requestAlbumAuthorizationBlock:(void(^)(NSInteger status))albumBlock;

#pragma mark - 相机权限
/// 请求相机权限
/// @param avBlock 【-1=不允许 -2 =用户点击不允许 0 = 弹窗询问 1=允许】
+(void)requestAVAuthorizationBlock:(void(^)(NSInteger status))avBlock;


@end

NS_ASSUME_NONNULL_END
