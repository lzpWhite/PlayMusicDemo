//
//  Player.h
//  zhenaiwang
//
//  Created by zhenai on 13-4-17.
//  Copyright (c) 2013年 zhenai.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface LZPPlayer : NSObject

+(LZPPlayer *)shared;
-(void)start;
-(void)stop;
-(BOOL)playing;
@property(nonatomic,retain)AVAudioPlayer*  player;
@property(nonatomic,retain)NSString *filename;

-(void)initiatePlayCondition;
@end
