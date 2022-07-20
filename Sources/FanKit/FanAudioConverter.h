//
//  FanAudioConverter.h
//  Brain
//
//  Created by 向阳凡 on 2020/1/6.
//  Copyright © 2020 向阳凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

NS_ASSUME_NONNULL_BEGIN

/*
 本文参考：https://github.com/michaeltyson/TPAACAudioConverter
 这个是5年前的库，一直没有更新维护，我自己重新封装成中文风格，加入更多的注释
 
 注意:这里是转换出aac格式的音频文件，改了后缀名也没有用
    可以pcm编码器编码的caf wav 等转换成aac
 */


///错误的域，外部解析错误使用
extern NSString * FanAudioConverterErrorDomain;



///转换错误类型
typedef NS_ENUM(NSUInteger, FanAudioConverterErrorType) {
    ///文件错误
    FanAudioConverterFileError,
    ///格式错误
    FanAudioConverterFormatError,
    //中断错误
    FanAudioConverterInterruptionError,
    ///初始化错误
    FanAudioConverterInitialisationError
};


@class FanAudioConverter;

#pragma mark -FanAudioConverterDelegate
@protocol FanAudioConverterDelegate <NSObject>
///转换完成
- (void)fan_audioDidFinishConverter:(FanAudioConverter*)converter;
///转换失败
- (void)fan_audioDidFailConverter:(FanAudioConverter*)converter error:(NSError*)error;
@optional
///转换进度
- (void)fan_audioDidConverting:(FanAudioConverter*)converter progress:(CGFloat)progress;
@end
#pragma mark -FanAudioConverterDataSource

@protocol FanAudioConverterDataSource <NSObject>
///需要转换一帧的字节和长度  mBytesPerFrame*1024
- (void)fan_audioConverter:(FanAudioConverter*)converter nextBytes:(char*)bytes length:(NSUInteger*)length;
@optional
///转换偏移量到多少字节  
- (void)fan_audioConverter:(FanAudioConverter *)converter seekToPosition:(long long)position;
@end

#pragma mark -FanAudioConverter

@interface FanAudioConverter : NSObject

/* AudioFormatID
kAudioFormatLinearPCM   pcm
kAudioFormatMPEGLayer3  mp3
kAudioFormatMPEG4AAC   aac
*/
///是否能转换到需要的格式
+ (BOOL)isCanConverterAAC;
/// 初始化转换工具
/// @param delegate 回调完成失败的代理
/// @param inputPath 输入需要转换的全路径文件
/// @param outputPath 输出转换完成的全路径文件
- (instancetype)initWithDelegate:(id<FanAudioConverterDelegate>)delegate inputPath:(NSString*)inputPath outputPath:(NSString*)outputPath;

/// 初始化转换工具外部资源获取音频帧
/// @param delegate 转换代理
/// @param dataSource 音频帧资源代理
/// @param audioFormat 音频格式
/// @param outputPath 输出文件
- (instancetype)initWithDelegate:(id<FanAudioConverterDelegate>)delegate dataSource:(id<FanAudioConverterDataSource>)dataSource audioFormat:(AudioStreamBasicDescription)audioFormat outputPath:(NSString*)outputPath;
///开始转换
- (void)start;
///关闭转换
- (void)cancel;
///中断转换
- (void)interrupt;
///中断恢复
- (void)resume;

///输入的转换文件全路径
@property (nonatomic, readonly, strong) NSString *inputConvertPath;
///输出的转换文件全路径
@property (nonatomic, readonly, strong) NSString *outputConvertPath;
/*
 struct AudioStreamBasicDescription
 {
     Float64             mSampleRate;//流中每秒数据的样本帧数
     AudioFormatID       mFormatID;//指示流中数据的一般类型
     AudioFormatFlags    mFormatFlags;// 由mFormatID指示的格式的AudioFormatFlags
     UInt32              mBytesPerPacket;//数据包中的字节数
     UInt32              mFramesPerPacket;//每个数据包中的样本帧数
     UInt32              mBytesPerFrame;//单个数据样本帧中的字节数
     UInt32              mChannelsPerFrame;//每帧数据中的通道数
     UInt32              mBitsPerChannel;//数据帧中每个通道的样本数据的位数 (8 16 24 32)
     UInt32              mReserved;//将结构填充出来以强制进行甚至8个字节的对齐
 };
 */
///音频数据流的格式属性
@property (nonatomic, readonly) AudioStreamBasicDescription audioFormat;


#pragma mark -关于中断和中断恢复的使用
/*
 //转换被打断的处理 interruption
 //转换成功或者失败的时候要移除代理
 //[[NSNotificationCenter defaultCenter] removeObserver:self];
 - (void)audioSessionInterrupted:(NSNotification*)notification {
     AVAudioSessionInterruptionType type =(AVAudioSessionInterruptionType) [notification.userInfo[AVAudioSessionInterruptionTypeKey] integerValue];
     if ( type == AVAudioSessionInterruptionTypeEnded) {
         [[AVAudioSession sharedInstance] setActive:YES error:NULL];
         if ( _audioConverter ) [_audioConverter resume];
     } else if ( type == AVAudioSessionInterruptionTypeBegan ) {
         if ( _audioConverter ) [_audioConverter interrupt];
     }
 }
 */

@end

NS_ASSUME_NONNULL_END
