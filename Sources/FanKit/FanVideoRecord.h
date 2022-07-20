//
//  FanVideoRecord.h
//  Brain
//
//  Created by 向阳凡 on 2018/10/23.
//  Copyright © 2018 向阳凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


NS_ASSUME_NONNULL_BEGIN

/**
 界面是否支持横竖屏
 
 - FanVideoRecordOrientationAll: 横竖屏切换
 - FanVideoRecordOrientationPortrait: 只支持横屏
 - FanVideoRecordOrientationLandscape: 只支持竖屏
 */
typedef NS_ENUM(NSInteger,FanVideoRecordOrientation){
    FanVideoRecordOrientationAll,
    FanVideoRecordOrientationPortrait,
    FanVideoRecordOrientationLandscape
};

//录制状态
typedef NS_ENUM(NSInteger, FanRecordState) {
    FanRecordStateInit = 0,//初始化
    FanRecordStateOpenCamera,//打开相机
    FanRecordStateRecording,//正在录制
    FanRecordStateReRecord,//重新录制
    FanRecordStatePause,//停止
    FanRecordStateFinish,//完成录制
    FanRecordStateEnterBack,//进入后台
    FanRecordStateBecomeActive//进入前台
};

@class FanVideoRecord;
typedef void(^FanVideoRecordBlock)(FanVideoRecord *videoRecord, FanRecordState recordState,CGFloat recordTime);


/**
 保存到相册的block
 
 @param saveType -1 = 开始转码 -2编码成功 -3 编码失败 -4 相机权限不允许 -5 相册不允许 -6 不支持闪光灯  0=开始保存 1=保存成功 2=保存失败
 */
typedef void(^FanVideoSaveAlbumBlock)(NSInteger saveType);

///photoType=0失败 1=成功
typedef void(^FanVideoPhotoBlock)(UIImage *_Nullable image,NSInteger photoType);

@interface FanVideoRecord : UIView

@property(nonatomic,assign)FanVideoRecordOrientation recordOrientation;
@property(nonatomic,assign)FanRecordState recordState;
//最大录制时间
@property (nonatomic, assign) CGFloat maxRecordTime;
@property (nonatomic, assign) BOOL autoSaveToAlbum;
@property (nonatomic, copy) FanVideoRecordBlock recordBlock;
@property (nonatomic, copy) FanVideoSaveAlbumBlock saveAlbumBlock;
@property (nonatomic, copy) FanVideoPhotoBlock photoBlock;

///打开摄像头
-(BOOL)fan_openVideo;
///关闭摄像头(dealloc之前一定要执行，有定时器，陀螺仪需要关闭)
-(void)fan_closeVideo;
///打开闪光灯
-(void)fan_flashLight;
/**开始录像*/
- (BOOL)fan_startVideoRecord;
- (BOOL)fan_startVideoRecord:(NSString *_Nullable)videoPath;
///重新打开录制，会清空前面录制的
- (BOOL)fan_reStartVideoRecord;
/**停止录像*/
- (void)fan_stopVideoRecord;
///开启拍照-截图保存
-(void)fan_startCapturePhoto;





#pragma mark - 文件操作和视频转化，裁剪
/** 删除录像 */
- (void)fan_deleteVideoRecord;
///清空视频缓存的文件夹内所有文件
-(void)fan_clearAllFiles;
//自动保存录制的视频到相册
-(void)fan_saveVideoToAlbum;
//保存指定文件的视频到相册
-(void)fan_saveVideoToAlbum:(NSString *)videoPath;





///创建临时视频保存的文件路径
//录制的时候保存mP4,在转码的时候o超过10秒有问题，所以录制成mov，保存成mp4
- (NSString *)fan_createTmpVideoFilePath:(NSString *)pathExtension;
/**
 根据视频拍摄时的方向编码旋转正确的mp4文件
 
 @param anInputFileURL 输入的文件URL
 @param videoOrientation 视频方向
 @param completeBlock 回调-成功失败，URLStr
 */
- (void)fan_encodeVideoOrientation:(NSURL *)anInputFileURL videoOrientation:(AVCaptureVideoOrientation)videoOrientation completeBlock:(void(^)(BOOL success, NSString*urlStr))completeBlock;
/**
 mov 转MP4 清晰度中
 
 @param fileUrl 文件URL，因为，可以是文件，可以是相册文件，可以是网络URL
 @param outPath 输出文件路径
 @param completeBlock 完成的回调 成功、失败   type=0 失败 =1 关闭  =2 成功
 */
- (void)fan_convertVideoWithURL:(NSURL *)fileUrl outPath:(NSString *)outPath completeBlock:(void(^)(BOOL success, NSInteger statusType))completeBlock;

///图片修正方向
+ (UIImage *)fan_fixOrientation:(UIImage *)aImage ;
@end

NS_ASSUME_NONNULL_END
