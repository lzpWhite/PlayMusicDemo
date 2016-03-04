//
//  VoiceRequest.h
//  Ershoufang
//
//  Created by lingyohunl on 15/7/16.
//  Copyright (c) 2015年 Fangdd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZPVoiceRequest : NSObject

@property(nonatomic,strong)NSString *downloadurl;

-(void)download:(NSString *)url success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
        failure:(void (^)(NSError *error))failure;

-(BOOL)queryDiskCache:(NSString *)url;

- (NSString *)cachePathForKey:(NSString *)key;

-(void)cancel;

@end
