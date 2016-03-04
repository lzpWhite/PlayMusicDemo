//
//  Player.m
//  zhenaiwang
//
//  Created by zhenai on 13-4-17.
//  Copyright (c) 2013年 zhenai.com. All rights reserved.
//

#import "LZPPlayer.h"

@implementation LZPPlayer


+(LZPPlayer *)shared
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

-(void)setFilename:(NSString *)fileName
{
    if (_filename != fileName) {
       
        _filename = [fileName copy];
        self.player=nil;
    }
}

-(void)dealloc
{
  
   
}
- (id)init
{
    self = [super init];
    if (self) {
        ;
    }
    return self;
}

-(AVAudioPlayer *)player
{
    if (_player == nil)
    {
        
        NSError *playerError;
        if(self.filename==nil)return nil;
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.filename] error:&playerError];
        _player.meteringEnabled = YES;
        if (_player == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }
        //_player.delegate = self;
    }
    
    return _player;
    
    
}

-(BOOL)playing
{
    return self.player.isPlaying;
}

-(void)start
{
    [self.player prepareToPlay];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
    
    
    BOOL flag=[self.player play];
    NSLog(@"flag=%d",flag);
}
-(void)stop
{
    [self.player stop];
}

-(void)initiatePlayCondition
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
    
}
#pragma mark - AVAudioPlayerDelegate
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error;
{
    
}
@end
