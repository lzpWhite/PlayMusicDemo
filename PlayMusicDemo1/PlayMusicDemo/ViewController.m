//
//  ViewController.m
//  PlayMusicDemo
//
//  Created by 刘志鹏 on 16/3/4.
//  Copyright © 2016年 刘志鹏. All rights reserved.
//

#import "ViewController.h"
#import "LZPDownPlayer.h"

#define urlstr @"地址需要找"

@interface ViewController () <DownPlayerDelegate> {
    BOOL downloadStatus;
}
/**
 *  播放音频
 */
@property (nonatomic, strong) LZPDownPlayer *dPlay;
@property (nonatomic, strong) UILabel *label;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    label.numberOfLines = 0;
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    self.label = label;
    [self.dPlay doloadAndPlayVoice:urlstr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (LZPDownPlayer *)dPlay{
    
    if (!_dPlay) {
        _dPlay = [LZPDownPlayer shared];
        _dPlay.downPlayerDelegate = self;
        downloadStatus = YES;
    }
    
    return _dPlay;
}

#pragma mark - LZPDownPlayerDelegate 播放音乐

-(void)downplayerWillStartDownload:(LZPDownPlayer *)player {
    _label.text = @"正在下载歌曲 请稍后。。。";
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
-(void)downplayerWillDownloadEnd:(LZPDownPlayer *)player status:(BOOL)status {
    downloadStatus = status;
    if ([player.voiceentity isEqualToString:urlstr] && status) {
        NSLog(@"开始播放");
        _label.text = @"歌曲下载成功。准备播放";
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    }
}
-(void)downplayerWillPlaying:(LZPDownPlayer *)player {
    if ([player.voiceentity isEqualToString:urlstr] && downloadStatus) {
        _label.text = @"开始播放 歌曲《默》";
    }
}
-(void)downplayerWillStop:(LZPDownPlayer *)player {
    _label.text = @"播放技术";
}



@end
