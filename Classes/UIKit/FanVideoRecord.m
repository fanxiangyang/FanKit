//
//  FanVideoRecord.m
//  Brain
//
//  Created by 向阳凡 on 2018/10/23.
//  Copyright © 2018 向阳凡. All rights reserved.
//

#import "FanVideoRecord.h"
#import <Photos/Photos.h>
#import "NSBundle+FanKit.h"
#import "FanToolBox.h"

@interface FanVideoRecord()<AVCaptureFileOutputRecordingDelegate>
@property (nonatomic, strong) AVCaptureSession *captureSession;//会话session
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//预览层Layer
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureDeviceInput *audioInput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *fileOutput;

@property (nonatomic, strong) NSString *videoPath;//输出视频路径

@property (nonatomic, strong, readwrite) NSURL *videoUrl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat recordTime;
//设备每次打开录制瞬间时的方向
@property (nonatomic, assign)AVCaptureVideoOrientation currentOrientation;
@end


@implementation FanVideoRecord


-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self initVideo];
    }
    return self;
}
-(void)initVideo{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBack) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [self fan_clearAllFiles];
    //初始化最大录制时间
    if (self.maxRecordTime<=0.01f) {
        self.maxRecordTime=45.0f;
    }
    
    self.recordState=FanRecordStateInit;
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.timer invalidate];
    self.timer=nil;
    
}
-(BOOL)fan_openVideo{
    if ([self.captureSession isRunning]) {
        return YES;
    }
    
    //第二次打开，只需要启动运行就OK了，不需要配置摄像机
    if (self.captureSession) {
        [self.captureSession startRunning];
        return YES;;
    }
    
    //判断摄像头权限
    AVAuthorizationStatus deviceStatus=[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (deviceStatus == AVAuthorizationStatusRestricted||deviceStatus==AVAuthorizationStatusDenied) {
        if (self.saveAlbumBlock) {
            self.saveAlbumBlock(-4);
        }
        return NO;
    }
    
    //初始化会话
    self.captureSession = [[AVCaptureSession alloc]init];
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];//AVCaptureSessionPresetPhoto
    }
    //摄像头设备-默认的摄像头
    AVCaptureDevice *captureDevice=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //设备输入口-视频输入
    NSError *error = nil;
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error || !self.videoInput) {
        NSLog(@"error:%@",[error description]);
        return NO;
    }
    
    //  把输入口加入会话session
    if ([self.captureSession canAddInput:self.videoInput]) {
        [self.captureSession addInput:self.videoInput];
    }
    
    
    //音频输入
    // 获取音频输入设备
    AVCaptureDevice *audioCaptureDevice=nil;
    if (@available(iOS 10.0, *)) {
        //AVCaptureDeviceTypeBuiltInWideAngleCamera 视频
        AVCaptureDeviceDiscoverySession *avDeviceDiscoverySession=[AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInMicrophone] mediaType:AVMediaTypeAudio position:AVCaptureDevicePositionUnspecified];
        audioCaptureDevice=[avDeviceDiscoverySession.devices firstObject];
        
    } else {
        audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio]firstObject];
    }
    NSError *audoError=nil;
    //创建音频输入源
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&audoError];
    //将音频输入源添加到会话
    if ([self.captureSession canAddInput:self.audioInput]) {
        [self.captureSession addInput:self.audioInput];
    }
    
    //设置输出对象
    self.fileOutput = [[AVCaptureMovieFileOutput alloc]init];
    // 设置输出对象的一些属性
    AVCaptureConnection *captureConnection=[self.fileOutput connectionWithMediaType:AVMediaTypeVideo];
    //视频防抖 是在 iOS 6 和 iPhone 4S 发布时引入的功能。到了 iPhone 6，增加了更强劲和流畅的防抖模式，被称为影院级的视频防抖动。相关的 API 也有所改动 (目前为止并没有在文档中反映出来，不过可以查看头文件）。防抖并不是在捕获设备上配置的，而是在 AVCaptureConnection 上设置。由于不是所有的设备格式都支持全部的防抖模式，所以在实际应用中应事先确认具体的防抖模式是否支持：
    if ([captureConnection isVideoStabilizationSupported ]) {
        captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
    }
    
    
    
    //设置预览层信息
    if (!self.captureVideoPreviewLayer) {
        self.captureVideoPreviewLayer=[AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        self.captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    }
    
    [self.captureVideoPreviewLayer connection].videoOrientation=[self viewStatusBrarOrientation];
    //设置后，输出的方向，随着预览图变化（但是不起作用，给每次启动录制时设备是什么方向，视频就是什么方向）
    captureConnection.videoOrientation=[self.captureVideoPreviewLayer connection].videoOrientation;
    //    captureConnection.videoMirrored=NO;
    //    if ([captureConnection isVideoOrientationSupported]) {
    //        captureConnection.videoOrientation=AVCaptureVideoOrientationLandscapeLeft;//[self.captureVideoPreviewLayer connection].videoOrientation;
    //    }else{
    //        NSLog(@"----------不支持---------");
    //    }
    
    
    if ([self.captureSession canAddOutput:self.fileOutput]) {
        [self.captureSession addOutput:self.fileOutput];
    }
    
    
    self.captureVideoPreviewLayer.frame=self.layer.bounds;
    [self.layer addSublayer:self.captureVideoPreviewLayer];
    
    
    //启动扫描
    [self.captureSession startRunning];
    
    self.recordState=FanRecordStateOpenCamera;
    if (self.recordBlock) {
        self.recordBlock(self, FanRecordStateOpenCamera, 0);
    }
    return  YES;
}
-(void)fan_closeVideo{
    [self.timer invalidate];
    self.timer=nil;
    [self.fileOutput stopRecording];
    [self.captureSession stopRunning];
}
-(void)fan_flashLight{
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if(![device isTorchModeSupported:AVCaptureTorchModeOn]){
        if (self.saveAlbumBlock) {
            self.saveAlbumBlock(-6);
        }
        return;
    }
    [device lockForConfiguration:nil];
    if (device.torchMode==AVCaptureTorchModeOff) {
        //闪光灯开启
        [device setTorchMode:AVCaptureTorchModeOn];
    }else {
        //闪光灯关闭
        [device setTorchMode:AVCaptureTorchModeOff];
    }
    [device unlockForConfiguration];
    
}
/**
 开始录像
 */
- (BOOL)fan_startVideoRecord{
    return [self fan_startVideoRecord:nil];
}

- (BOOL)fan_startVideoRecord:(NSString *_Nullable)videoPath{
    self.recordState=FanRecordStateInit;
    
    if ([self fan_openVideo]) {
        //修正每次拍摄时的方向,每次录制时，记录当前屏幕方向
        self.currentOrientation=[self viewStatusBrarOrientation];
        
        if (videoPath.length>0) {
            self.videoPath=videoPath;
        }else{
            self.videoPath = [self fan_createTmpVideoFilePath:@"mov"];
            
        }
        self.videoUrl = [NSURL fileURLWithPath:self.videoPath];
        [self.fileOutput startRecordingToOutputFileURL:self.videoUrl recordingDelegate:self];
        return YES;
        
    }else{
//        NSLog(@"无法打开摄像头，请重试");
        return NO;
    }
}
- (BOOL)fan_reStartVideoRecord{
    if (self.recordState==FanRecordStateRecording) {
        self.recordState=FanRecordStateReRecord;
        [self fan_stopVideoRecord];
        //在回调中处理
        return YES;
        
    }else{
        self.recordState=FanRecordStateReRecord;
        //没有启动，直接启动
        return [self fan_startVideoRecord];
    }
    
}

/**
 停止录像
 */
- (void)fan_stopVideoRecord{
    [self.timer invalidate];
    self.timer=nil;
    [self.fileOutput stopRecording];
}

/**
 删除录像
 */
- (void)fan_deleteVideoRecord{
    [FanToolBox fan_deleteFile:self.videoPath];
}
-(void)fan_clearAllFiles{
    NSString *path = [[FanToolBox fan_cachePath] stringByAppendingPathComponent:@"FanVideoRecordFolder"];
    [FanToolBox fan_deleteFilesAtPath:path];
    
}
-(void)fan_saveVideoToAlbum{
    [self fan_saveVideoToAlbum:[self.videoUrl path]];
}
-(void)fan_saveVideoToAlbum:(NSString *)videoPath{
    PHAuthorizationStatus photoAuthorStatus=0;
    if (@available(iOS 14, *)) {
        PHAccessLevel level = PHAccessLevelReadWrite;
        photoAuthorStatus = [PHPhotoLibrary authorizationStatusForAccessLevel:level];
    } else {
        photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    }
    if (photoAuthorStatus==PHAuthorizationStatusDenied||photoAuthorStatus==PHAuthorizationStatusRestricted) {
        //用户拒绝当前应用访问相册,我们需要提醒用户打开访问开关 ||  不允许访问
        if (self.saveAlbumBlock) {
            self.saveAlbumBlock(-5);
        }
    }else if (photoAuthorStatus==PHAuthorizationStatusNotDetermined){
        //获取用户对是否允许访问相册的操作
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status==PHAuthorizationStatusAuthorized) {
                [self fan_saveVideoToAlbumAuthorization:videoPath];
            }
        }];
        return;
    }else{
        //允许访问  PHAuthorizationStatusAuthorized  PHAuthorizationStatusLimited
        [self fan_saveVideoToAlbumAuthorization:videoPath];
    }
}
-(void)fan_saveVideoToAlbumAuthorization:(NSString *)videoPath{
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath isDirectory:nil]) {
        if (self.saveAlbumBlock) {
            self.saveAlbumBlock(0);
        }
        //文件存在
        NSURL *url=[NSURL fileURLWithPath:videoPath];
        __weak typeof(self)weakSelf=self;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
            //            localIdentifier = request.placeholderForCreatedAsset.localIdentifier;
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    //                    PHAsset *asset = [[PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil] firstObject];
                    //                    NSLog(@"文件保存成功");
                    if (weakSelf.saveAlbumBlock) {
                        weakSelf.saveAlbumBlock(1);
                    }
                } else if (error) {
//                    NSLog(@"保存视频出错:%@",error.localizedDescription);
                    if (weakSelf.saveAlbumBlock) {
                        weakSelf.saveAlbumBlock(2);
                    }
                }
            });
        }];
    }
}
//录制的时候保存mP4,在转码的时候o超过10秒有问题，所以录制成mov，保存成mp4
- (NSString *)fan_createTmpVideoFilePath:(NSString *)pathExtension{
    NSString *videoName = [NSString stringWithFormat:@"video_%ld.%@", (long)[NSDate timeIntervalSinceReferenceDate],pathExtension];
    NSString *path = [[FanToolBox fan_cachePath] stringByAppendingPathComponent:@"FanVideoRecordFolder"];
    [FanToolBox fan_createDirectoryAtPath:path];
    path=[path stringByAppendingPathComponent:videoName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
//    NSLog(@"========:%@",path);
    
    return path;
    
}
//    NSString *outPath=[self fan_createTmpVideoFilePath];
//    __weak typeof(self)weakSelf=self;
//    [self fan_convertVideoWithURL:self.videoUrl outPath:outPath completeBlock:^(BOOL success, NSInteger statusType) {
//        if (success) {
//            [weakSelf fan_saveVideoToAlbum:outPath];
//        }
//
//    }];
- (void)fan_convertVideoWithURL:(NSURL *)fileUrl outPath:(NSString *)outPath completeBlock:(void(^)(BOOL success, NSInteger statusType))completeBlock{
    __block NSURL *outputFileURL = fileUrl;
    NSString *path = [outPath copy];
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:outputFileURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality])
    {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        exportSession.outputURL = [[NSURL alloc] initFileURLWithPath:path];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    completeBlock(NO,0);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    completeBlock(NO,1);
                    break;
                case AVAssetExportSessionStatusCompleted:
                    completeBlock(YES,2);
//                    NSLog(@"转出成功");
                    break;
                default:
                    break;
            }
        }];
    }
}
- (void)fan_encodeVideoOrientation:(NSURL *)anInputFileURL videoOrientation:(AVCaptureVideoOrientation)videoOrientation completeBlock:(void(^)(BOOL success, NSString*urlStr))completeBlock{
    //    __weak typeof(self)weakSelf=self;
    //1 — 采集
    AVAsset *asset = [AVAsset assetWithURL:anInputFileURL];
    //    AVURLAsset * urlAsset = [[AVURLAsset alloc]initWithURL:anInputFileURL options:nil];
    
    
    /********************************************************************************************/
    //配置图像转码时属性和通道，可以旋转和裁剪图像
    //    AVMutableVideoComposition *mainComposition=[self getVideoComposition:asset];
    
    // 2 创建AVMutableComposition实例. 创建一个包含asset的新子类对象，导出时需要用这个，不然没有图像数据
    AVMutableComposition *composition = [[AVMutableComposition alloc] init];
    
    // 3 视频通道  工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    //获取duration的时候，不要用asset.duration，应该用track.timeRange.duration，用前者的时间不准确，会导致黑帧
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetTrack.timeRange.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
    
    // 4. 音频通道
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *audioAssetTrack =[[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetTrack.timeRange.duration) ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    
    //5 创建视频组合图层指令AVMutableVideoCompositionLayerInstruction，并设置图层指令在视频的作用时间范围和旋转矩阵变换
    CMTime totalDuration = kCMTimeZero;
    AVMutableVideoCompositionLayerInstruction*layerInstruction=[AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    totalDuration = CMTimeAdd(totalDuration, videoAssetTrack.timeRange.duration);
    // 6.videoAssetTrack.naturalSize 就是录制的视频的实际宽高
    CGSize renderSize = videoAssetTrack.naturalSize;
    CGFloat maxsize=MAX(renderSize.width, renderSize.height);
    CGFloat minsize=MIN(renderSize.width, renderSize.height);
    
    CGAffineTransform t = videoAssetTrack.preferredTransform;
    if((t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0) ||
       (t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0)){
        renderSize = CGSizeMake(maxsize, minsize);
    }
    //    renderSize = CGSizeMake(1920, 1080);
    
    // 7. 根据录制视频时的方向旋转视频
    //关于旋转矩阵介绍https://www.jianshu.com/p/ca7f9bc62429
    //对视频做仿射变换矩阵
    CGFloat angle=0;//旋转角度
    CGFloat moveX=0;//平移距离
    CGFloat moveY=0;//平移距离
    switch (videoOrientation) {
        case AVCaptureVideoOrientationPortrait:
        {
            
        }
            break;
        case AVCaptureVideoOrientationPortraitUpsideDown:
        {
            renderSize = CGSizeMake(minsize, maxsize);
            
            angle=-M_PI;
            moveX=-maxsize;
            moveY=-minsize;
        }
            break;
        case AVCaptureVideoOrientationLandscapeLeft:
        {
            
            angle=M_PI_2;
            moveX=minsize-maxsize;
            moveY=-minsize;
            
        }
            break;
        case AVCaptureVideoOrientationLandscapeRight:
        {
            angle=-M_PI_2;
            moveX=-minsize;
        }
            break;
            
            
        default:
            break;
    }
    composition.naturalSize=renderSize;
    
    //iPhone录制视频1920*1080 默认保存到相册都是按实际宽高， 开始时屏幕是什么方向视频内容就翻转多少，视频是左下角为坐标轴
    CGAffineTransform layerTransform =CGAffineTransformRotate(videoAssetTrack.preferredTransform, angle);
    layerTransform=CGAffineTransformTranslate(layerTransform, moveX, moveY);
    //    layerTransform = CGAffineTransformScale(layerTransform, 1, 1);
    [layerInstruction setTransform:layerTransform atTime:kCMTimeZero];
    [layerInstruction setOpacity:0.0 atTime:totalDuration];
    
    //8. 创建视频组合指令AVMutableVideoCompositionInstruction，并设置指令在视频的作用时间范围和旋转矩阵变换
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
    instruction.layerInstructions = @[layerInstruction];
    //录制视频编码属性
    AVMutableVideoComposition *mainComposition = [AVMutableVideoComposition videoComposition];
    mainComposition.instructions = @[instruction];
    mainComposition.frameDuration = CMTimeMake(1, 30);//fps 1秒30帧
    mainComposition.renderSize =renderSize; //CGSizeMake(renderW,renderW);
    mainComposition.renderScale = 1.0;
    
    
    /********************************************************************************************/
    
    
    NSString* outputPath = [self fan_createTmpVideoFilePath:@"mp4"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputPath]){
        [[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
    }
    
    NSURL *outurl = [[NSURL alloc] initFileURLWithPath:outputPath];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:anInputFileURL options:nil];
    NSString * presetName=AVAssetExportPresetMediumQuality;
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:urlAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality])
    {
        presetName=AVAssetExportPresetHighestQuality;
    }
    // 9.导出视频(asset参数不能用urlAsset ,会得不到图像，不知道为什么)
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:presetName];
    exporter.videoComposition = mainComposition;
    exporter.outputURL = outurl;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
//        NSLog(@"编码错误：%@",exporter.error);
        switch ([exporter status]) {
            case AVAssetExportSessionStatusFailed:
                completeBlock(NO,@"0");
                break;
            case AVAssetExportSessionStatusCancelled:
                completeBlock(NO,@"1");
                break;
            case AVAssetExportSessionStatusCompleted:
            {
                
                completeBlock(YES,outputPath);
//                NSLog(@"转出成功");
                break;
            }
            default:
                break;
        }
        
        
    }];
    
    
}
+ (NSUInteger)degressFromVideoFileWithURL:(NSURL *)url {
    NSUInteger degress = 0;
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    return degress;
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    self.recordTime=0;
    self.recordState = FanRecordStateRecording;
    if (self.recordBlock) {
        self.recordBlock(self, FanRecordStateRecording, 0);
    }
    [self.timer invalidate];
    self.timer=nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(refreshRecordTime) userInfo:nil repeats:YES];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    if (self.recordState==FanRecordStateEnterBack) {
        //系统退出后台，会自动完成录制
        return;
    }
    if (self.recordState==FanRecordStateReRecord) {
        //重新录制时，这里清空上次，重新调用新录制
        [self fan_deleteVideoRecord];
        if ([self fan_startVideoRecord]) {
            if (self.recordBlock) {
                self.recordBlock(self, FanRecordStateReRecord, 1);
            }
        }else{
            if (self.recordBlock) {
                self.recordBlock(self, FanRecordStateReRecord, 0);
            }
        }
        return;
    }
    if (self.recordState!=FanRecordStateRecording) {
        //重新录制时，这个停止不做处理,关闭录制时，不记录
        return;
    }
    self.recordState = FanRecordStateFinish;
    if (self.recordBlock) {
        self.recordBlock(self, FanRecordStateFinish, 0);
    }
    //系统退出后台，会自动完成录制
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.videoPath isDirectory:nil]) {
        
//        long long length = [FanToolBox fan_fileSizeFromPath:self.videoPath];
//        NSLog(@"文件大小：%lld",length);
        if (self.autoSaveToAlbum) {
            if (self.currentOrientation==AVCaptureVideoOrientationPortrait) {
                [self fan_saveVideoToAlbum];
            }else{
                if (self.saveAlbumBlock) {
                    self.saveAlbumBlock(-1);
                }
                __weak typeof(self)weakSelf=self;
                [self fan_encodeVideoOrientation:self.videoUrl videoOrientation:self.currentOrientation completeBlock:^(BOOL success, NSString * _Nonnull urlStr) {
                    if (success) {
                        if (weakSelf.saveAlbumBlock) {
                            weakSelf.saveAlbumBlock(-2);
                        }
                        [weakSelf fan_saveVideoToAlbum:urlStr];
                    }else{
                        if (weakSelf.saveAlbumBlock) {
                            weakSelf.saveAlbumBlock(-3);
                        }
                    }
                }];
            }
        }
        
        
        
        
    }else{
//        NSLog(@"录制失败");
    }
    
}

- (void)refreshRecordTime{
    self.recordTime += 0.5;
    if (self.recordBlock) {
        self.recordBlock(self, FanRecordStateRecording, self.recordTime);
    }
    if (self.recordTime >= self.maxRecordTime) {
        [self fan_stopVideoRecord];
    }
}
#pragma mark - notification
//设备方向改变
-(void)deviceOrientationDidChange:(NSObject*)sender{
    if (self.captureVideoPreviewLayer==nil) {
        return;
    }
    AVCaptureVideoOrientation orientation=0;
    
    UIDevice* device = [sender valueForKey:@"object"];
    switch (device.orientation) {
        case UIDeviceOrientationUnknown: {
            orientation=[self.captureVideoPreviewLayer connection].videoOrientation;
            break;
        }
        case UIDeviceOrientationPortrait: {
            if (self.recordOrientation==FanVideoRecordOrientationLandscape) {
                orientation=[self.captureVideoPreviewLayer connection].videoOrientation;
            }else{
                orientation=AVCaptureVideoOrientationPortrait;
            }
            
            break;
        }
        case UIDeviceOrientationPortraitUpsideDown: {
            if (self.recordOrientation==FanVideoRecordOrientationLandscape) {
                orientation=[self.captureVideoPreviewLayer connection].videoOrientation;
            }else{
                orientation=AVCaptureVideoOrientationPortraitUpsideDown;
            }
            break;
        }
        case UIDeviceOrientationLandscapeLeft: {
            if (self.recordOrientation==FanVideoRecordOrientationPortrait) {
                orientation=[self.captureVideoPreviewLayer connection].videoOrientation;
            }else{
                orientation=AVCaptureVideoOrientationLandscapeRight;
            }
            break;
        }
        case UIDeviceOrientationLandscapeRight: {
            if (self.recordOrientation==FanVideoRecordOrientationPortrait) {
                orientation=[self.captureVideoPreviewLayer connection].videoOrientation;
            }else{
                orientation=AVCaptureVideoOrientationLandscapeLeft;
            }
            break;
        }
        case UIDeviceOrientationFaceUp: {
            // 面朝上
            orientation=[self.captureVideoPreviewLayer connection].videoOrientation;
            
            break;
        }
        case UIDeviceOrientationFaceDown: {
            //面朝下
            orientation=[self.captureVideoPreviewLayer connection].videoOrientation;
            
            break;
        }
        default:{
            
        }
    }
    //    self.captureVideoPreviewLayer.frame=self.layer.bounds;
    //    [self.layer addSublayer:self.captureVideoPreviewLayer];
    [self.captureVideoPreviewLayer connection].videoOrientation=orientation;
    //    AVCaptureConnection *captureConnection=[self.fileOutput connectionWithMediaType:AVMediaTypeVideo];
    //    captureConnection.videoOrientation=[self.captureVideoPreviewLayer connection].videoOrientation;
}

//用设备方向没有解决当用户锁定屏幕时解决方案
-(AVCaptureVideoOrientation)viewStatusBrarOrientation{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    switch (orientation) {
        case UIInterfaceOrientationUnknown:
        {
            
        }
            break;
        case UIInterfaceOrientationPortrait:
        {
            return AVCaptureVideoOrientationPortrait;
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            return AVCaptureVideoOrientationPortraitUpsideDown;
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            return AVCaptureVideoOrientationLandscapeLeft;
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            return AVCaptureVideoOrientationLandscapeRight;
        }
            break;
        default:
            break;
    }
    if (self.recordOrientation==FanVideoRecordOrientationLandscape) {
        return AVCaptureVideoOrientationLandscapeRight;
    }else{
        return AVCaptureVideoOrientationPortrait;
    }
}
//进入后台
- (void)enterBack
{
    self.videoUrl = nil;
    self.recordState = FanRecordStateEnterBack;
    [self fan_stopVideoRecord];
    if (self.recordBlock) {
        self.recordBlock(self, FanRecordStateEnterBack, 0);
    }
    //在回调里面，可以停止摄像头
    
}
//进入前台
- (void)becomeActive
{
    self.recordTime=0;
    self.recordState = FanRecordStateBecomeActive;
    if (self.recordBlock) {
        self.recordBlock(self, FanRecordStateBecomeActive, 0);
    }
    //在回调里面，可以重新打开摄像头
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
