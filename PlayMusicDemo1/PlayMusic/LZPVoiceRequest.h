//
//  VoiceRequest.h
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
