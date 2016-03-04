//
//  DownPlayer.h
//  zhenaiwang
//
//  Created by zhenai on 13-6-14.
//  Copyright (c) 2013年 zhenai.com. All rights reserved.
//
/*
 从网上下载语音,然后转码,播放.这是一个公共类,通常不应该创建本类的实例,而是使用
 shared方法获取一个公共的实例
 yohunl 20130704增加了一个播放本地音乐的方法,此方法将不对传入的文件名进行转码
 */
#import "LZPPlayer.h"
#import "LZPVoiceRequest.h"
#import "amrFileCodec.h"

@protocol DownPlayerDelegate;
@interface LZPDownPlayer:NSObject<AVAudioPlayerDelegate>
{
    @private
    LZPPlayer * _player;
    
    struct {
        unsigned downplayerWillStartDownload : 1;
        unsigned downplayerWillDownloadEnd:1;
        unsigned downplayerWillPlaying : 1;
        unsigned downplayerWillStop:1;
        
    } _downPlayerDelegateHas;
}
@property(nonatomic,readonly)LZPPlayer *player;
@property(nonatomic,retain)LZPVoiceRequest *voicerequest;
@property(nonatomic,retain)NSString *voiceentity;
@property(nonatomic,weak)id<DownPlayerDelegate> downPlayerDelegate;


/**
 * 获取一个公共的DownPlayer实例,这个是单例模式
 */
+(LZPDownPlayer *)shared;

/**
 * 取消下载,当我们切换页面等时,我们要取消正在下载的语音
 */
-(void)cancelDowloadVoice;

/**
 * 取消下载,并且停止正在播放的音乐
 */
-(void)cancelDownloadAndPlay;

/**
 * 下载,并且播放下载的音乐
 *
 * 
 * 此方法会对传入的对象进行判断,当播放器播放的就是本名称所对应的音乐的时候,会触发停止协议,而不是下载了,所以不用
 *
 *
 * @param voiceentity 要被播放或者下载的音乐的实体
 */
-(void)doloadAndPlayVoice:(NSString *)voiceentity;

/**
 * 播放本地的音乐
 *
 * 在个人页面录制音乐后要试听的时候,我们可以用此方法,此方法会认为voiceentity对象中的voicePath
 * 是本地音乐的全路径名称,将不会对此名称进行MD5转换编码,而是直接播放
 *
 * @param voiceentity 要被播放的音乐的实体
 */
-(void)playLocalVoice:(NSString *)voiceentity;

/**
 *  停止播放
 */
-(void)stopPlay;
@end



@protocol DownPlayerDelegate <NSObject>

@optional
-(void)downplayerWillStartDownload:(LZPDownPlayer *)player;
-(void)downplayerWillDownloadEnd:(LZPDownPlayer *)player status:(BOOL)status;
-(void)downplayerWillPlaying:(LZPDownPlayer *)player;
-(void)downplayerWillStop:(LZPDownPlayer *)player;

@end