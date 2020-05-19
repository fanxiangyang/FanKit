//
//  FanAudioConverter.m
//  Brain
//
//  Created by 向阳凡 on 2020/1/6.
//  Copyright © 2020 向阳凡. All rights reserved.
//

#import "FanAudioConverter.h"
#import <AVFoundation/AVFoundation.h>

///切换音频通道的通知
NSString * FANAudioConverterWillSwitchAudioSessionCategoryNotification = @"FANAudioConverterWillSwitchAudioSessionCategoryNotification";
///恢复音频通道的通知
NSString * FanAudioConverterDidRestoreAudioSessionCategoryNotification = @"FanAudioConverterDidRestoreAudioSessionCategoryNotification";
///错误的域
NSString * FanAudioConverterErrorDomain = @"com.fan.FanAudioConverterErrorDomain";

///内联函数的检查是否存在
#define fan_checkResult(result,operation) (_checkResultLite((result),(operation),__FILE__,__LINE__))
//内联函数，不支持result的打印需要
static inline BOOL _checkResultLite(OSStatus result, const char *operation, const char* file, int line) {
    if ( result != noErr ) {
        NSLog(@"%s:%d: %s result %d %08X %4.4s\n", file, line, operation, (int)result, (int)result, (char*)&result);
        return NO;
    }
    return YES;
}

@interface FanAudioConverter ()  {
    BOOL            _processing;//是否处理
    BOOL            _cancelled;//是否关闭
    BOOL            _interrupted;//是否中断
    AVAudioSessionCategoryOptions _priorCategoryOptions;//音频通道参数：例如是否录音，其他声音减小
}
@property (nonatomic, readwrite, strong) NSString *inputConvertPath;
@property (nonatomic, readwrite, strong) NSString *outputConvertPath;
@property (nonatomic, assign) id<FanAudioConverterDelegate> delegate;
@property (nonatomic, strong) id<FanAudioConverterDataSource> dataSource;
///信号量条件判断（为中断加锁，安全）
@property (nonatomic, strong) NSCondition *condition;
@end

@implementation FanAudioConverter
/*
 kAudioFormatLinearPCM   pcm
 kAudioFormatMPEGLayer3  mp3
 kAudioFormatMPEG4AAC   aac
 */
+ (BOOL)isCanConverterAAC{
#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
    static BOOL available;
    static BOOL available_set = NO;

    if ( available_set ) return available;
    
    //设备编码格式 kAudioFormatMPEG4AAC默认
    UInt32 encoderSpecifier = kAudioFormatMPEG4AAC;
    UInt32 size;
    //检查编码格式是否支持（软件编码）
    if ( !fan_checkResult(AudioFormatGetPropertyInfo(kAudioFormatProperty_Encoders, sizeof(encoderSpecifier), &encoderSpecifier, &size),
                      "AudioFormatGetPropertyInfo(kAudioFormatProperty_Encoders") ) return NO;
    
    UInt32 numEncoders = size / sizeof(AudioClassDescription);
    AudioClassDescription encoderDescriptions[numEncoders];
    
    if ( !fan_checkResult(AudioFormatGetProperty(kAudioFormatProperty_Encoders, sizeof(encoderSpecifier), &encoderSpecifier, &size, encoderDescriptions),
                      "AudioFormatGetProperty(kAudioFormatProperty_Encoders") ) {
        available_set = YES;
        available = NO;
        return NO;
    }
    /* AudioClassDescription
     mType: 指明提编码器还是解码器。kAudioDecoderComponentType／kAudioEncoderComponentType。
     mSubType: 指明是 AAC, iLBC 还是 OPUS等。
     mManufacturer: 指明是软编还是硬编码。
     */
    for (UInt32 i=0; i < numEncoders; ++i) {
        if ( encoderDescriptions[i].mSubType == kAudioFormatMPEG4AAC ) {
            available_set = YES;
            available = YES;
            return YES;
        }
    }
    
    available_set = YES;
    available = NO;
    return NO;
#endif
}

/// 初始化转换工具
/// @param delegate 回调完成失败的代理
/// @param inputPath 输入需要转换的全路径文件
/// @param outputPath 输出转换完成的全路径文件
- (instancetype)initWithDelegate:(id<FanAudioConverterDelegate>)delegate inputPath:(NSString*)inputPath outputPath:(NSString*)outputPath{
    if ( !(self = [super init]) ) return nil;
    
    self.delegate = delegate;
    self.inputConvertPath = inputPath;
    self.outputConvertPath = outputPath;
    _condition = [[NSCondition alloc] init];
    return self;
}

/// 初始化转换工具外部资源获取音频帧
/// @param delegate 转换代理
/// @param dataSource 音频帧资源代理
/// @param audioFormat 音频格式
/// @param outputPath 输出文件
- (instancetype)initWithDelegate:(id<FanAudioConverterDelegate>)delegate dataSource:(id<FanAudioConverterDataSource>)dataSource audioFormat:(AudioStreamBasicDescription)audioFormat outputPath:(NSString*)outputPath{
    if ( !(self = [super init]) ) return nil;
    
    self.delegate = delegate;
    self.dataSource = dataSource;
    self.outputConvertPath = outputPath;
    _audioFormat = audioFormat;
    _condition = [[NSCondition alloc] init];
    return self;
}
#pragma mark - 开始  关闭  中断  中断恢复
///开启转换
-(void)start {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    _priorCategoryOptions = audioSession.categoryOptions;//获取音频与其他音频通道混音参数
    //AVAudioSessionCategoryOptionMixWithOthers是否和其他后台APP混音  其他参数请Google搜索
    if ( _priorCategoryOptions & AVAudioSessionCategoryOptionMixWithOthers ) {
        NSError *error = nil;
        //~ 按位取反（禁用混音）
        if (![audioSession setCategory:audioSession.category
                           withOptions:(_priorCategoryOptions & ~AVAudioSessionCategoryOptionMixWithOthers)
                                 error:&error]) {
            NSLog(@"无法禁用混音进行转换: %@", error.localizedDescription);
        }
    }
    _cancelled = NO;
    _processing = YES;
    [self performSelectorInBackground:@selector(processingThread) withObject:nil];
}
///关闭转换
-(void)cancel {
    _cancelled = YES;
    //等待处理完成
    while ( _processing ) {
        [NSThread sleepForTimeInterval:0.1];
    }
    if ( _priorCategoryOptions & AVAudioSessionCategoryOptionMixWithOthers ) {
        NSError *error = nil;
        if ( ![[AVAudioSession sharedInstance] setCategory:[AVAudioSession sharedInstance].category
                                               withOptions:_priorCategoryOptions
                                                     error:&error] ) {
            NSLog(@"无法恢复音频会话原参数: %@", error.localizedDescription);
        }
    }
}
///中断
- (void)interrupt {
    [_condition lock];
    _interrupted = YES;
    [_condition unlock];
}
///中断恢复
- (void)resume {
    [_condition lock];
    _interrupted = NO;
    [_condition signal];
    [_condition unlock];
}
#pragma mark - 转换实现和进度
///转换进度
- (void)convertProgress:(NSNumber*)progress {
    if ( _cancelled ) return;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(fan_audioDidConverting:progress:)]) {
        [self.delegate fan_audioDidConverting:self progress:[progress floatValue]];
    }
}
///转换完成
- (void)convertCompletion {
    if ( _cancelled ) return;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(fan_audioDidFinishConverter:)]) {
        [self.delegate fan_audioDidFinishConverter:self];
    }
    if ( _priorCategoryOptions & AVAudioSessionCategoryOptionMixWithOthers ) {
        NSError *error = nil;
        if ( ![[AVAudioSession sharedInstance] setCategory:[AVAudioSession sharedInstance].category
                                               withOptions:_priorCategoryOptions
                                                     error:&error] ) {
            NSLog(@"无法恢复混音参数: %@", error.localizedDescription);
        }
    }
}
///转换错误
- (void)convertErrorAndCleanup:(NSError*)error {
    if ( _cancelled ) return;
    BOOL isDir=NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:_outputConvertPath isDirectory:&isDir]) {
        if (isDir==NO) {
            //不是路径就移除旧错误文件
            [[NSFileManager defaultManager] removeItemAtPath:_outputConvertPath error:NULL];
        }
    }
    if ( _priorCategoryOptions & AVAudioSessionCategoryOptionMixWithOthers ) {
        NSError *error = nil;
        if ( ![[AVAudioSession sharedInstance] setCategory:[AVAudioSession sharedInstance].category
                                               withOptions:_priorCategoryOptions
                                                     error:&error] ) {
            NSLog(@"无法恢复混音参数: %@", error.localizedDescription);
        }
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(fan_audioDidFailConverter:error:)]) {
        [self.delegate fan_audioDidFailConverter:self error:error];
    }
}
///转换核心的处理线程
- (void)processingThread {
    //设置线程优先级（不推荐用了，先注释掉吧）
//    [[NSThread currentThread] setThreadPriority:0.9];
    
    //资源文件
    ExtAudioFileRef sourceFile = NULL;
    //资源文件格式
    AudioStreamBasicDescription sourceFormat;
    if ( _inputConvertPath ) {
        //设置的是有输入文件转换
        //判断资源文件是否能打开
        if ( !fan_checkResult(ExtAudioFileOpenURL((__bridge CFURLRef)[NSURL fileURLWithPath:_inputConvertPath], &sourceFile), "ExtAudioFileOpenURL") ) {
            [self performSelectorOnMainThread:@selector(convertErrorAndCleanup:)
                                   withObject:[NSError errorWithDomain:FanAudioConverterErrorDomain
                                                                  code:FanAudioConverterFileError
                                                              userInfo:[NSDictionary dictionaryWithObject:@"Couldn't open the input file" forKey:NSLocalizedDescriptionKey]]
                                waitUntilDone:NO];
            _processing = NO;
            return;
        }
        UInt32 size = sizeof(sourceFormat);
        //判断资源文件是否能按格式读取
        if ( !fan_checkResult(ExtAudioFileGetProperty(sourceFile, kExtAudioFileProperty_FileDataFormat, &size, &sourceFormat),
                          "ExtAudioFileGetProperty(kExtAudioFileProperty_FileDataFormat)") ) {
            [self performSelectorOnMainThread:@selector(convertErrorAndCleanup:)
                                   withObject:[NSError errorWithDomain:FanAudioConverterErrorDomain
                                                                  code:FanAudioConverterFormatError
                                                              userInfo:[NSDictionary dictionaryWithObject:@"Couldn't read the source file" forKey:NSLocalizedDescriptionKey]]
                                waitUntilDone:NO];
            _processing = NO;
            return;
        }
    } else {
        //从数据流中转换的数据流原格式
        sourceFormat = _audioFormat;
    }
    //输出的音频数据流格式
    AudioStreamBasicDescription destinationFormat;
    memset(&destinationFormat, 0, sizeof(destinationFormat));
    destinationFormat.mChannelsPerFrame = sourceFormat.mChannelsPerFrame;
    //转出的文件格式
    destinationFormat.mFormatID = kAudioFormatMPEG4AAC;
    UInt32 size = sizeof(destinationFormat);
    //判断输出文件是否能按格式设置
    if ( !fan_checkResult(AudioFormatGetProperty(kAudioFormatProperty_FormatInfo, 0, NULL, &size, &destinationFormat),
                      "AudioFormatGetProperty(kAudioFormatProperty_FormatInfo)") ) {
        [self performSelectorOnMainThread:@selector(convertErrorAndCleanup:)
                               withObject:[NSError errorWithDomain:FanAudioConverterErrorDomain
                                                              code:FanAudioConverterFormatError
                                                          userInfo:[NSDictionary dictionaryWithObject:@"Couldn't setup destination format" forKey:NSLocalizedDescriptionKey]]
                            waitUntilDone:NO];
        _processing = NO;
        return;
    }
    //输出文件Ref
    ExtAudioFileRef destinationFile;
    //kAudioFileAAC_ADTSType =aac  kAudioFileM4AType =m4a
    //判断是否能创建指定后缀名的输出文件
    if ( !fan_checkResult(ExtAudioFileCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:_outputConvertPath],
                                                kAudioFileAAC_ADTSType,
                                                &destinationFormat,
                                                NULL,
                                                kAudioFileFlags_EraseFile,
                                                &destinationFile), "ExtAudioFileCreateWithURL") ) {
        [self performSelectorOnMainThread:@selector(convertErrorAndCleanup:)
                               withObject:[NSError errorWithDomain:FanAudioConverterErrorDomain
                                                              code:FanAudioConverterFileError
                                                          userInfo:[NSDictionary dictionaryWithObject:@"Couldn't open the destination file" forKey:NSLocalizedDescriptionKey]]
                            waitUntilDone:NO];
        _processing = NO;
        return;
    }
    //中间转换流
    AudioStreamBasicDescription clientFormat;
    if ( sourceFormat.mFormatID == kAudioFormatLinearPCM ) {
        //源文件是pcm格式的，直接设置
        clientFormat = sourceFormat;
    } else {
        //把不是pcm格式的音频文件转成pcm
        memset(&clientFormat, 0, sizeof(clientFormat));
        clientFormat.mFormatID          = kAudioFormatLinearPCM;//指示流中数据的一般类型
        clientFormat.mFormatFlags       = kAudioFormatFlagIsFloat | kAudioFormatFlagIsPacked | kAudioFormatFlagIsNonInterleaved;
        clientFormat.mChannelsPerFrame  = sourceFormat.mChannelsPerFrame;//每帧数据中的通道数
        clientFormat.mBytesPerPacket    = sizeof(float);//数据包中的字节数
        // 每个音频包帧的数量. 对于未压缩的数据设置为 1.
        // 动态码率格式，这个值是一个较大的固定数字，比如说AAC的1024。
        // 如果是动态帧数（比如Ogg格式）设置为0。
        clientFormat.mFramesPerPacket   = 1;//每个数据包中的样本帧数
        clientFormat.mBytesPerFrame     = sizeof(float);//单个数据样本帧中的字节数
        clientFormat.mBitsPerChannel    = 8 * sizeof(float);//数据帧中每个通道的样本数据的位数 (8 16 24 32)
        clientFormat.mSampleRate        = sourceFormat.mSampleRate;//流中每秒数据的样本帧数
    }
    
    size = sizeof(clientFormat);
    //判断是否可以设置中间转换格式
    if ( (sourceFile && !fan_checkResult(ExtAudioFileSetProperty(sourceFile, kExtAudioFileProperty_ClientDataFormat, size, &clientFormat),
                      "ExtAudioFileSetProperty(sourceFile, kExtAudioFileProperty_ClientDataFormat")) ||
         !fan_checkResult(ExtAudioFileSetProperty(destinationFile, kExtAudioFileProperty_ClientDataFormat, size, &clientFormat),
                      "ExtAudioFileSetProperty(destinationFile, kExtAudioFileProperty_ClientDataFormat")) {
        if ( sourceFile ) ExtAudioFileDispose(sourceFile);
        ExtAudioFileDispose(destinationFile);
        [self performSelectorOnMainThread:@selector(convertErrorAndCleanup:)
                               withObject:[NSError errorWithDomain:FanAudioConverterErrorDomain
                                                              code:FanAudioConverterFormatError
                                                          userInfo:[NSDictionary dictionaryWithObject:@"Couldn't setup intermediate conversion format" forKey:NSLocalizedDescriptionKey]]
                            waitUntilDone:NO];
        _processing = NO;
        return;
    }
    //是否能从中断恢复
    BOOL canResumeFromInterruption = YES;
    //音频转换Ref
    AudioConverterRef converter;
    size = sizeof(converter);
    if ( fan_checkResult(ExtAudioFileGetProperty(destinationFile, kExtAudioFileProperty_AudioConverter, &size, &converter),
                      "ExtAudioFileGetProperty(kExtAudioFileProperty_AudioConverter;)") ) {
        UInt32 canResume = 0;
        size = sizeof(canResume);
        //中断中恢复
        if ( AudioConverterGetProperty(converter, kAudioConverterPropertyCanResumeFromInterruption, &size, &canResume) == noErr ) {
            canResumeFromInterruption = (BOOL)canResume;
        }
    }
    //文件总的frame长度 后面做进度，偏移量
    SInt64 lengthInFrames = 0;
    if ( sourceFile ) {
        size = sizeof(lengthInFrames);
        //获取文件长度
        ExtAudioFileGetProperty(sourceFile, kExtAudioFileProperty_FileLengthFrames, &size, &lengthInFrames);
    }
    //设置缓冲区大小
    UInt32 bufferByteSize = 32768;//1024*4*8
    char srcBuffer[bufferByteSize];
    //格式字节偏移量
    SInt64 sourceFrameOffset = 0;
    //看是否需要回调进度数据
    BOOL reportProgress = lengthInFrames > 0 && [self.delegate respondsToSelector:@selector(fan_audioDidConverting:progress:)];
    //最后一次回调进度时间
    NSTimeInterval lastProgressReport = [NSDate timeIntervalSinceReferenceDate];
    
    while ( !_cancelled ) {
        AudioBufferList fillBufList;
        fillBufList.mNumberBuffers = 1;
        fillBufList.mBuffers[0].mNumberChannels = clientFormat.mChannelsPerFrame;
        fillBufList.mBuffers[0].mDataByteSize = bufferByteSize;
        fillBufList.mBuffers[0].mData = srcBuffer;
        
        UInt32 numFrames = bufferByteSize / clientFormat.mBytesPerFrame;
        
        if ( sourceFile ) {
            //读资源文件放在缓存里面
            if ( !fan_checkResult(ExtAudioFileRead(sourceFile, &numFrames, &fillBufList), "ExtAudioFileRead") ) {
                ExtAudioFileDispose(sourceFile);
                ExtAudioFileDispose(destinationFile);
                [self performSelectorOnMainThread:@selector(convertErrorAndCleanup:)
                                       withObject:[NSError errorWithDomain:FanAudioConverterErrorDomain
                                                                      code:FanAudioConverterFormatError
                                                                  userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"Error reading the source file", @"Error message") forKey:NSLocalizedDescriptionKey]]
                                    waitUntilDone:NO];
                _processing = NO;
                return;
            }
        } else {
            //读取外面一帧文件
            NSUInteger length = bufferByteSize;
            if (self.dataSource&&[self.dataSource respondsToSelector:@selector(fan_audioConverter:nextBytes:length:)]) {
                [self.dataSource fan_audioConverter:self nextBytes:srcBuffer length:&length];
            }
            numFrames = (UInt32)length / clientFormat.mBytesPerFrame;
            fillBufList.mBuffers[0].mDataByteSize = (UInt32)length;
        }
        
        if ( !numFrames ) {
            break;
        }
        //资源多少帧偏移量
        sourceFrameOffset += numFrames;
        //等待中断恢复后继续
        [_condition lock];
        BOOL wasInterrupted = _interrupted;
        while ( _interrupted ) {
            [_condition wait];
        }
        [_condition unlock];
        //中断没有恢复
        if ( wasInterrupted && !canResumeFromInterruption ) {
            if ( sourceFile ) {
                //释放原资源
                ExtAudioFileDispose(sourceFile);
            }
            //释放转换后文件
            ExtAudioFileDispose(destinationFile);
            [self performSelectorOnMainThread:@selector(convertErrorAndCleanup:)
                                   withObject:[NSError errorWithDomain:FanAudioConverterErrorDomain
                                                                  code:FanAudioConverterInterruptionError
                                                              userInfo:[NSDictionary dictionaryWithObject:@"Interrupted" forKey:NSLocalizedDescriptionKey]]
                                waitUntilDone:NO];
            _processing = NO;
            return;
        }
        //把一包数据写入到输出文件里面
        OSStatus status = ExtAudioFileWrite(destinationFile, numFrames, &fillBufList);
        
        if ( status == kExtAudioFileError_CodecUnavailableInputConsumed) {
            /*
             ExtAudioFileWrite写入中断的时候你必须首先停止写.
             之后中断恢复后看( kAudioConverterPropertyCanResumeFromInterruption)
             你必须等待AudioSession的中断通知，然后设置AudioSessionSetActive(true)在恢复之前
             但是这一包已经转换成功了
             */
        } else if ( status == kExtAudioFileError_CodecUnavailableInputNotConsumed ) {
            /*
             ExtAudioFileWrite写入中断的时候你必须首先停止写.
             之后中断恢复后看( kAudioConverterPropertyCanResumeFromInterruption)
             你必须等待AudioSession的中断通知，然后设置AudioSessionSetActive(true)在恢复之前
             但是这一包转换失败了，你必须跳转到上一包继续执行一次
             */
            
            // seek back to last offset before last read so we can try again after the interruption
            sourceFrameOffset -= numFrames;
            if ( sourceFile ) {
                //跳转文件句柄到上一包
                fan_checkResult(ExtAudioFileSeek(sourceFile, sourceFrameOffset), "ExtAudioFileSeek");
            } else if (self.dataSource&&[self.dataSource respondsToSelector:@selector(fan_audioConverter:seekToPosition:)]) {
                [self.dataSource fan_audioConverter:self seekToPosition:(sourceFrameOffset * clientFormat.mBytesPerFrame)];
            }
        } else if ( !fan_checkResult(status, "ExtAudioFileWrite") ) {
            //写入是否成功判断
            if ( sourceFile ) ExtAudioFileDispose(sourceFile);
            ExtAudioFileDispose(destinationFile);
            [self performSelectorOnMainThread:@selector(convertErrorAndCleanup:)
                                   withObject:[NSError errorWithDomain:FanAudioConverterErrorDomain
                                                                  code:FanAudioConverterFormatError
                                                              userInfo:[NSDictionary dictionaryWithObject:@"Error writing the destination file" forKey:NSLocalizedDescriptionKey]]
                                waitUntilDone:NO];
            _processing = NO;
            return;
        }
        //支持进度回调
        if ( reportProgress && [NSDate timeIntervalSinceReferenceDate]-lastProgressReport > 0.1 ) {
            lastProgressReport = [NSDate timeIntervalSinceReferenceDate];
            [self performSelectorOnMainThread:@selector(convertProgress:) withObject:[NSNumber numberWithDouble:(double)sourceFrameOffset/lengthInFrames] waitUntilDone:NO];
        }
    }
    //释放当前音频文件一包占用
    if ( sourceFile ) ExtAudioFileDispose(sourceFile);
    ExtAudioFileDispose(destinationFile);
    
    if ( _cancelled ) {
        BOOL isDir=NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:_outputConvertPath isDirectory:&isDir]) {
            if (isDir==NO) {
                //不是路径就移除旧错误文件
                [[NSFileManager defaultManager] removeItemAtPath:_outputConvertPath error:NULL];
            }
        }
    } else {
        [self performSelectorOnMainThread:@selector(convertCompletion) withObject:nil waitUntilDone:NO];
    }
    _processing = NO;
}
@end
