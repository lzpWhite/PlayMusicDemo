//
//  VoiceRequest.m
//

#import "LZPVoiceRequest.h"
#import <CommonCrypto/CommonDigest.h>
@interface LZPVoiceRequest ()
@property (nonatomic,strong) NSMutableArray<NSURLSessionDataTask *> *taskArr;
@end


@implementation LZPVoiceRequest
//-(NSOperationQueue *)operation {
//    if (!_operation) {
//        _operation = [[[NSOperationQueue alloc]init]init];
//    }
//    return _operation;
//}

- (instancetype)init {
    self = [super init];
    if (self) {
        _taskArr = [NSMutableArray new];
    }
    return self;
}


-(BOOL)queryDiskCache:(NSString *)url
{
    NSString *path=[self cachePathForKey:url];
    NSLog(@"音频地址:  %@", path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断temp文件夹是否存在
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    return fileExists;
    
}



-(void)download:(NSString *)url success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
        failure:(void (^)(NSError *error))failure
{
    if(url==nil)return;
    if([self queryDiskCache:url])//存在
    {
        //直接告诉完成
        success(nil,nil);
        return ;
    }
    self.downloadurl=url;
    
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //[request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    __weak __typeof(self)weakSelf = self;
    
    NSURLSession *session = [NSURLSession sharedSession];
    __block NSURLSessionDataTask *dataTask;
    dataTask = [session dataTaskWithRequest:urlRequest
                          completionHandler:
                ^(NSData *data, NSURLResponse *response, NSError *error) {
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.taskArr removeObject:dataTask];
                        if (error) {
                            if ([[urlRequest URL] isEqual:[dataTask.currentRequest URL]]) {
                                if (failure) {
                                    failure(nil);
                                }
                            }
                        }
                        else {
                            
                            if ([[urlRequest URL] isEqual:[dataTask.currentRequest URL]]) {
                                if (success) {
                                    [weakSelf downloadResult:data];
                                    success(dataTask, data);
                                } else if (data) {
                                    [weakSelf downloadResult:data];
                                }
                            }
                        }
                    });
                    
                    
                    
                }];
    // 使用resume方法启动任务
    [_taskArr addObject:dataTask];
    [dataTask resume];
    
    
}

- (NSString *)cachePathForKey:(NSString *)key
{
    const char *str = [key UTF8String];
    unsigned char r[16];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return [[self getVoicePath] stringByAppendingPathComponent:filename];
}

-(NSString *)getVoicePath
{
    NSString *fullNamespace = @"voice";
    
    // Init the disk cache
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString * diskCachePath = [paths[0] stringByAppendingPathComponent:fullNamespace];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:diskCachePath])
    {
        [fileManager createDirectoryAtPath:diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    
    return diskCachePath;
    
}

-(void)downloadResult:(NSData *)data
{
    NSString *path=[self cachePathForKey:self.downloadurl];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:path contents:data attributes:nil];
    
}

-(void)cancel {
    [self.taskArr enumerateObjectsUsingBlock:^(NSURLSessionDataTask *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
        
    }];
    
}

@end
