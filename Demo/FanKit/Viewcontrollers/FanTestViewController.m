//
//  FanTestViewController.m
//  FanKit
//
//  Created by 向阳凡 on 2017/3/10.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanTestViewController.h"
#import "FanRSA.h"
#import "FanVideoRecord.h"

@interface FanTestViewController ()
@property(nonatomic,strong)FanVideoRecord *videoView;

@end

@implementation FanTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self testRSA];
    UIButton *openButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [openButton setFrame:CGRectMake(60, 60, 80, 32)];
    [openButton setTitle:@"开启" forState:UIControlStateNormal];
    [openButton setTitleColor:FanBlackColor(1.0) forState:UIControlStateNormal];
    openButton.titleLabel.font=FanBoldFont(16);
    [openButton addTarget:self action:@selector(openLocalCameraClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openButton];
    
    UIButton *recordButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [recordButton setFrame:CGRectMake(60+100, 60, 80, 32)];
    [recordButton setTitle:@"录制" forState:UIControlStateNormal];
    [recordButton setTitleColor:FanBlackColor(1.0) forState:UIControlStateNormal];
    recordButton.titleLabel.font=FanBoldFont(16);
    [recordButton addTarget:self action:@selector(recoardVideoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordButton];
    
    UIButton *saveButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [saveButton setFrame:CGRectMake(60+200, 60, 80, 32)];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:FanBlackColor(1.0) forState:UIControlStateNormal];
    saveButton.titleLabel.font=FanBoldFont(16);
    [saveButton addTarget:self action:@selector(saveRecoardVideoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    UIButton *stopButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [stopButton setFrame:CGRectMake(60+300, 60, 80, 32)];
    [stopButton setTitle:@"停止" forState:UIControlStateNormal];
    [stopButton setTitleColor:FanBlackColor(1.0) forState:UIControlStateNormal];
    stopButton.titleLabel.font=FanBoldFont(16);
    [stopButton addTarget:self action:@selector(cancelVideoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];
    UIButton *tackButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [tackButton setFrame:CGRectMake(60+400, 60, 80, 32)];
    [tackButton setTitle:@"拍照" forState:UIControlStateNormal];
    [tackButton setTitleColor:FanBlackColor(1.0) forState:UIControlStateNormal];
    tackButton.titleLabel.font=FanBoldFont(16);
    [tackButton addTarget:self action:@selector(tackPhotoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tackButton];
}
-(FanVideoRecord *)videoView{
    if (_videoView==nil) {
        //本地录制
        _videoView = [[FanVideoRecord alloc]initWithFrame:self.view.bounds];
        //    _videoView.backgroundColor=[UIColor blackColor];
        _videoView.autoSaveToAlbum=YES;
        _videoView.maxRecordTime=30.0f;
        [self.view insertSubview:_videoView atIndex:0];
        
        __weak typeof(self) weakSelf=self;
        [_videoView setRecordBlock:^(FanVideoRecord * _Nonnull videoRecord, FanRecordState recordState, CGFloat recordTime) {
            NSLog(@"状态：%ld",recordState);
            switch (recordState) {
                case FanRecordStateRecording:
                {
                    NSLog(@"录制时间：%.2f/%.2f",recordTime,videoRecord.maxRecordTime);
                }
                    break;
                case FanRecordStateFinish:
                {
                   
                    [weakSelf.videoView fan_closeVideo];
                    weakSelf.videoView.hidden=YES;
                }
                    break;
                case FanRecordStateEnterBack:
                {
                    //进入后台，库里面自动停止了

                }
                    break;
                case FanRecordStateBecomeActive:
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
        }];
        [_videoView setSaveAlbumBlock:^(NSInteger saveType) {
            NSLog(@"保存状态：%ld",saveType);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (saveType==0) {
                }else if(saveType==1){
                    
                }else if(saveType==2){
                    
                }else if (saveType==-1) {
                    //编码中
                    
                }else if(saveType==-2){
                   
                }else if(saveType==-3){
                    
                }else if(saveType==-4){
                    
                }else if(saveType==-5){
                    
                }
            });
            
        }];
        
    }
    return _videoView;
}

#pragma mark - 本地视频录制
///打开摄像头
-(void)openLocalCameraClick{
    FanWeakSelf;
    [FanAuthManager requestAVAuthorizationBlock:^(NSInteger status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status==-2) {
                //用户点击不允许
            }else if(status==-1){
                //不允许
            }else if(status==0){
                //询问
            }else if(status==1){
                //允许
                [weakSelf openLocalCameraReal];
            }
        });
    }];
}
-(void)openLocalCameraReal{
    if ([self.videoView fan_openVideo]) {
        self.videoView.recordState=FanRecordStateOpenCamera;
        //修正每次拍摄时的方向,每次录制时，记录当前屏幕方向
//        self.currentOrientation=[self videoDeviceOrientation:[UIDevice currentDevice].orientation];
        self.videoView.hidden=NO;
    }else{
    }
}
-(void)cancelAllUI{
    [self.videoView fan_stopVideoRecord];
    [self.videoView fan_closeVideo];
    [self.videoView fan_deleteVideoRecord];
    [self.videoView removeFromSuperview];
    _videoView=nil;
}
///关闭录制+摄像头
-(void)cancelVideoClick{
    NSLog(@"关闭录制-摄像头");
    [self.videoView fan_clearAllRecord];
    self.videoView.hidden=YES;
}
///重新录制
-(void)refreshVideoClick{
    if([self.videoView fan_reStartVideoRecord]){
        self.videoView.hidden=NO;
    }else{
    }
}
//打开录制 保存录制
-(void)recoardVideoClick{
    if (self.videoView.recordState==FanRecordStateRecording) {
        //关闭录制
//        [self.videoView fan_stopVideoRecord];
//        [self.videoView fan_closeVideo];
//        self.videoView.hidden=YES;
    }else{
        //打开录制
//        [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:nil];
        if([self.videoView fan_startVideoRecord]){
            self.videoView.hidden=NO;
        }else{
        }
    }
}
///保存录制
-(void)saveRecoardVideoClick{
    if (self.videoView.recordState==FanRecordStateRecording) {
        //关闭录制
        [self.videoView fan_stopVideoRecord];
        [self.videoView fan_closeVideo];
        self.videoView.hidden=YES;
    }
}
-(void)tackPhotoClick{
    if ([self.videoView fan_openVideo]) {
        [self.videoView fan_startCapturePhoto];
    }
}
-(void)testRSA{
    NSString *siyao = @"-----BEGIN PRIVATE KEY-----\nMIIBVgIBADANBgkqhkiG9w0BAQEFAASCAUAwggE8AgEAAkEA0YEsIeIpbyYhzWSf\npa1ZteoGFxJsH+VXc3HngEneK3PlSIj//Q39TAzQprIJtNoI6k7RDHOZggffZJ+v\njN41RwIDAQABAkANJEwvZ+9vcHXoW2qESwZ4mdB9/ALaUVmV/UwnSPrtwL8/jMgL\ndbaR4gYGqK0qlaKW89xizfnGAAdaNQYaCxoBAiEA96NTUnL/9mRQy2ui7Og22TwA\ncNDnQp00Xd7NoayHAQECIQDYlDUkhqUYzWsydbzctIzxvveMN6oxqB+UkDJOsn7u\nRwIhANjgXTS0Kp9rM6cz2TiKFp8iAXDMQ/z/GMGtQ4H4SzQBAiEAx14/QV11E0zd\ntjit35mQ+WTq6je/wzBZyd+nf8xOjjcCIQDzreOntgLL91+Pyea034PSgljOVIda\nlScgsEauudnJHg==\n-----END PRIVATE KEY-----";

    NSString *gongyao = @"-----BEGIN PUBLIC KEY-----\nMFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBANGBLCHiKW8mIc1kn6WtWbXqBhcSbB/l V3Nx54BJ3itz5UiI//0N/UwM0KayCbTaCOpO0QxzmYIH32Sfr4zeNUcCAwEAAQ==\n-----END PUBLIC KEY-----";
    
    NSString *str=@"我看门狗的啥控件地方了啥控件法律手段";
    
    NSString *eStr=[FanRSA fan_encryptString:str publicKey:gongyao];
    
    FanPrintf(@"加密：%@",eStr);
//
//    eStr=@"K6y/zW4fKlmtfYkeOYtsbsoKmkuSdNXjLgW1GMTRUaAuSmerqFWrAVrf0A4+N+CvMBRUw4zcguRjAxYtXulHww==";
//
//    eStr=@"E0nEn3IcAORjoZJPQOuOw5lLPCqh6wjpS110z9HNTPmK3eMhfOX19U5VMm8lgri3nu07DTEXazgPHz743FJnpA==";
    NSString *dStr=[FanRSA fan_decryptString:eStr privateKey:siyao];
    
    FanPrintf(@"解密：%@",dStr);

    
    
}


//int (*orig_sysctlbyname)(const char *name, void *oldp, size_t *oldlenp, void *newp, size_t newlen);
//
//int mysysctlbyname(const char *name, void *oldp, size_t *oldlenp, void *newp, size_t newlen){
//    if (strcmp(name,"hw.machine") == 0) {
//        if (oldp != NULL) {
//            int ret = orig_sysctlbyname(name,oldp,oldlenp,newp,newlen);
//            const char* mechine = "iWatch Edition";
//            strncpy((char *)oldp,mechine,strlen(mechine));
//            return ret;
//        }else{
//            int ret = orig_sysctlbyname(name,oldp,oldlenp,newp,newlen);
//            return ret;
//        }
//    }else{
//        return orig_sysctlbyname(name,oldp,oldlenp,newp,newlen);
//    }
//}
//%ctor {
//    MSHookFunction((void *)MSFindSymbol(NULL,"_sysctlbyname"), (void *)mysysctlbyname, (void **)&orig_sysctlbyname);
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
