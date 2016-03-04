//
//  DownPlayer.m
//  zhenaiwang
//
//  Created by zhenai on 13-6-14.
//  Copyright (c) 2013年 zhenai.com. All rights reserved.
//

#import "LZPDownPlayer.h"
//#import "AppUtils.h"
@implementation LZPDownPlayer

+(LZPDownPlayer *)shared
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

-(void)dealloc
{
}


-(LZPVoiceRequest *)voicerequest
{
    
    if(_voicerequest==nil)
    {
        _voicerequest=LZPVoiceRequest.new;
        
    }
    return _voicerequest;
}

- (void)setDownPlayerDelegate:(id<DownPlayerDelegate>)newDelegate
{
    _downPlayerDelegate=newDelegate;
    _downPlayerDelegateHas.downplayerWillStartDownload=[_downPlayerDelegate respondsToSelector:@selector(downplayerWillStartDownload:)];
    _downPlayerDelegateHas.downplayerWillDownloadEnd=[_downPlayerDelegate respondsToSelector:@selector(downplayerWillDownloadEnd:status:)];
    _downPlayerDelegateHas.downplayerWillPlaying=[_downPlayerDelegate respondsToSelector:@selector(downplayerWillPlaying:)];
    _downPlayerDelegateHas.downplayerWillStop=[_downPlayerDelegate respondsToSelector:@selector(downplayerWillStop:)];
    
}
- (id)init
{
    self = [super init];
    if (self) {
        _player=[LZPPlayer shared];
    }
    return self;
}

-(BOOL)queryDiskForVoiceUrl:(NSString *)url
{
    if(url==nil)return NO;
    return [self.voicerequest queryDiskCache:url];
}

-(void)downloadVoice:(NSString *)path
{
    if (_downPlayerDelegateHas.downplayerWillStartDownload) {
        if (self.downPlayerDelegate) {
            [_downPlayerDelegate downplayerWillStartDownload:self];
        }
        
    }
  
    __weak typeof(self) weakSelf  = self;
    [self.voicerequest download:path success:^(NSURLSessionDataTask *operation, id responseObject) {
            [weakSelf voiceDownloadSucess:@"获取语音验证码成功"];
    } failure:^(NSError *error) {        
            [weakSelf voiceDownloadSucess:@"获取语音失败"];
    }];
}

-(void)cancelDowloadVoice
{
    [self.voicerequest cancel];
}

-(void)cancelDownloadAndPlay
{
    [self cancelDowloadVoice];
    [self stopPlay];
    _player.player.delegate=nil;
}

-(void)voiceDownloadSucess:(NSString *)str
{
    //[self showDelay:nil];
    if(_downPlayerDelegateHas.downplayerWillDownloadEnd)
    {
        BOOL status=[str isEqualToString:@"获取语音验证码成功"];
        if (self.downPlayerDelegate) {
            [_downPlayerDelegate downplayerWillDownloadEnd:self status:status];
  
        }
    }
    
    if(self.voiceentity ==nil)
    {
        if (self.downPlayerDelegate) {
            [_downPlayerDelegate downplayerWillDownloadEnd:self status:NO];
        }
        
        return ;
    }
    else
    {
        NSString *filename=[self.voicerequest cachePathForKey:self.voiceentity];
        [self decodeAmrToWave:filename];
        _player.filename=filename;
        _player.player.delegate=self;
        
        [self startPlay];
    }
    
    
}

-(void)decodeAmrToWave:(NSString *)filename
{
    NSData* cafData=[NSData dataWithContentsOfFile:filename];
    
    NSData *waveData = nil;
    if ([self.voiceentity hasSuffix:@"amr"] || [filename hasSuffix:@"AMR"]) {
        waveData = DecodeAMRToWAVE(cafData);
    } else {
        waveData = cafData;
    }
    if(waveData!=nil)
    {
        [waveData writeToFile:filename atomically:YES];
    }
    
    NSLog(@"Wave len :%lu \n",(unsigned long)[waveData length]);
}

-(void)stopPlay
{
    if(_downPlayerDelegateHas.downplayerWillStop  && self.downPlayerDelegate)
    {
        [_downPlayerDelegate downplayerWillStop:self];
    }
    [_player stop];
}
-(void)startPlay
{
    if(_downPlayerDelegateHas.downplayerWillPlaying)
    {
        if (self.downPlayerDelegate) {
            [_downPlayerDelegate downplayerWillPlaying:self];
        }
    }
    
    
    [_player start];
}
-(void)playLocalVoice:(NSString *)voiceentity
{
    self.voiceentity=voiceentity;
    if(self.voiceentity==nil)
    {
        return ;
    }
    else
    {
        
        NSString *filename=self.voiceentity;
        if([_player playing]&&[filename isEqualToString:_player.filename])
        {
            [self stopPlay];
            return ;
        }
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL fileExists = [fileManager fileExistsAtPath:filename];
        if(fileExists)
        {
            _player.filename=filename;
            _player.player.delegate=self;
            [self startPlay];
        }
        
    }

}
-(void)doloadAndPlayVoice:(NSString *)voiceentity
{
    self.voiceentity=voiceentity;
    if(self.voiceentity==nil)
    {
        return ;
    }
    else
    {
        
        NSString *filename=[self.voicerequest cachePathForKey:self.voiceentity];
        if([_player playing]&&[filename isEqualToString:_player.filename])
        {
            [self stopPlay];
            return ;
        }
        
        if([self queryDiskForVoiceUrl:self.voiceentity])//exist
        {
            
            _player.filename=filename;
            _player.player.delegate=self;
            [self startPlay];
        }
        else
        {
            
            [self downloadVoice:self.voiceentity];
            
        }
    }
}

#pragma mark 播放声音
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if(_downPlayerDelegateHas.downplayerWillStop && self.downPlayerDelegate)
    {
        [_downPlayerDelegate downplayerWillStop:self];
    }
    
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error;
{
    NSLog(@"audioPlayerDecodeErrorDidOccur");
    if(_downPlayerDelegateHas.downplayerWillStop && self.downPlayerDelegate)
    {
        [_downPlayerDelegate downplayerWillStop:self];
    }
    
}

@end
