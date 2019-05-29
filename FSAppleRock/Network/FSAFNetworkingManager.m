//
//  FSAFNetworkingManager.m
//  FSLibrary_IOS
//
//  Created by ZhangLan_PC on 16/7/8.
//  Copyright © 2016年 fangstar.net. All rights reserved.
//

#import "FSAFNetworkingManager.h"
#import "NSString+FSUtility.h"
#import "FSFormDataItem.h"

#warning 上线修改  超时时间设置
#define kTimeoutInterval            30

#define kUserDefaultsCookie         @"UserDefaultsCookie"

@implementation FSAFNetworkingManager

#pragma mark - 初始化

+ (instancetype)sharedManager
{
    static FSAFNetworkingManager *manager = nil;
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
#warning https 待测试
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://baidu.com/"]];
    });
    return manager;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self)
    {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 请求超时设定
        self.requestSerializer.timeoutInterval = kTimeoutInterval;
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//        // 如果是需要服务端验证证书，需要设置为YES
//        securityPolicy.allowInvalidCertificates = YES;
//        //validatesDomainName 是否需要验证域名，默认为YES；
//        securityPolicy.validatesDomainName = YES;
        self.securityPolicy = securityPolicy;
    }
    return self;
}

#pragma mark - 网络状态
/**
 *  监控网络状态
 */
- (void)startMonitorNetwork
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld", (long)status);
    }];
}

/**
 *  检查网络状态
 */
//- (BOOL)checkNetworkStatus:(FSNetworkRequest *)networkRequest
//{
//    if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
//        networkRequest.searchResult.msg = @"网络连接失败";
//        
//        if (networkRequest.networkDelegate && [networkRequest.networkDelegate respondsToSelector:@selector(fsNetworkFailed:)]) {
//            [networkRequest.networkDelegate fsNetworkFailed:networkRequest];
//        }
//        
//        [self printRequestInfo:networkRequest];
//        return NO;
//    }
//    return YES;
//}

#pragma mark - 网络请求列表
/**
 *  添加请求
 *
 *  @param networkRequest 请求对象
 */
- (void)addRequest:(FSNetworkRequest *)networkRequest
{
    // ===================================================
    // 发送网络请求
    // ===================================================
    FSAFNetworkingManager *sessionManager = [FSAFNetworkingManager sharedManager];

    // 设置超时时间
    [sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    sessionManager.requestSerializer.timeoutInterval = kTimeoutInterval;
    [sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [sessionManager.requestSerializer setHTTPShouldHandleCookies:YES];

    NSURLSessionDataTask *dataTask = [sessionManager dataTaskWithHTTPMethod:networkRequest.httpMethod URLString:networkRequest.totalUrlString parameters:networkRequest.totalRequestParam uploadProgress:nil downloadProgress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        // 成功
        networkRequest.responseData = responseObject;
        
        [self doHandleResponseData:networkRequest];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 失败
        networkRequest.searchResult.msg = @"网络连接失败";
        
        [self networkFailure:networkRequest];

        printf("%s:%s", [networkRequest.requestName UTF8String], [error.description UTF8String]);
        [self printRequestInfo:networkRequest];

//#warning 打印数据问题
//        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//
//        if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
//            rootVC = ((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController;
//        }
//        UINavigationController *nav;
//        if ([rootVC isKindOfClass:[UINavigationController class]]) {
//            nav = (UINavigationController *)rootVC;
//        }
//        else {
//            nav = rootVC.navigationController;
//        }
//
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%s--%s",[networkRequest.requestName UTF8String], [error.description UTF8String]] preferredStyle:UIAlertControllerStyleAlert];
//
//        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//        }]];
//        [nav presentViewController:alert animated:YES completion:nil];
        
    }];
    
    networkRequest.requestTask = dataTask;
    
    [dataTask resume];
}

/**
 *  下载文件
 *
 *  @param urlString 下载地址
 */
- (NSURLSessionTask *)postDownLoadRequest:(FSNetworkRequest *)networkRequest
{
    // 检查网络
    [self checkNetworkStatus:networkRequest];
    
    // ===================================================
    // 发送网络请求
    // ===================================================
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:networkRequest.totalUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 下载路径
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (filePath) {
            networkRequest.downLoadUrl = filePath;
            networkRequest.searchResult.msg = @"下载成功";
            
            [self doHandleResponseData:networkRequest];
        }
        else
        {
            networkRequest.searchResult.msg = @"下载失败";
            [self networkFailure:networkRequest];
        }
        NSLog(@"File downloaded to: %@", filePath);
        NSLog(@"File downloaded error: %@", error.description);
        
    }];
    [downloadTask resume];
    
    return downloadTask;
}

#pragma mark - 上传文件
/**
 *  上传文件
 *
 *  @param urlString 上传地址
 *  @param fileName  文件名
 */
- (NSURLSessionUploadTask *)postUpLoadRequest:(FSNetworkRequest *)networkRequest
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:networkRequest.totalUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURL *filePath = [NSURL fileURLWithPath:networkRequest.uploadUrlString];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", error);
            networkRequest.searchResult.msg = @"上传失败";
            [self networkFailure:networkRequest];
        }
        else
        {
            NSLog(@"Success: %@ %@", response, responseObject);
            
            networkRequest.searchResult.msg = responseObject;
            
            [self networkSuccess:networkRequest];
        }
    }];
    [uploadTask resume];
    return uploadTask;
}

/**
 *  多维表单上传
 *
 */
- (NSURLSessionUploadTask *)postFormUpLoadRequest:(FSNetworkRequest *)networkRequest
{
    // ===================================================
    // 发送网络请求
    // ===================================================
    FSAFNetworkingManager *sessionManager = [FSAFNetworkingManager sharedManager];
    
    // 设置超时时间
    [sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    sessionManager.requestSerializer.timeoutInterval = kTimeoutInterval;
    [sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [sessionManager.requestSerializer setHTTPShouldHandleCookies:YES];

    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:networkRequest.totalUrlString parameters:networkRequest.totalRequestParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (FSFormDataItem *item in networkRequest.uploadFormDataArray)
        {
            if (item.data) {
                [formData appendPartWithFormData:item.data name:item.keyName];
            }
        }

    } error:nil];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [sessionManager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          //                          [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error)
                      {
                          // 失败
                          networkRequest.searchResult.msg = @"网络连接失败";
                          
                          [self networkFailure:networkRequest];
                          
                          printf("%s:%s", [networkRequest.requestName UTF8String], [error.description UTF8String]);
                          [self printRequestInfo:networkRequest];
                          
//#warning 打印数据问题
//                          UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//
//                          if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
//                              rootVC = ((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController;
//                          }
//                          UINavigationController *nav;
//                          if ([rootVC isKindOfClass:[UINavigationController class]]) {
//                              nav = (UINavigationController *)rootVC;
//                          }
//                          else {
//                              nav = rootVC.navigationController;
//                          }
//
//                          UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%s--%s",[networkRequest.requestName UTF8String], [error.description UTF8String]] preferredStyle:UIAlertControllerStyleAlert];
//
//                          [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//                          }]];
//                          [nav presentViewController:alert animated:YES completion:nil];
                          
                      }
                      else
                      {
                          // 成功
                          networkRequest.responseData = responseObject;
                          [self doHandleResponseData:networkRequest];
                      }
                  }];
    
    [uploadTask resume];
    
    return uploadTask;
}

/**
 *  多维表单上传（尊园之星）
 *
 */
- (NSURLSessionUploadTask *)postFormUpLoadForFangstarRequest:(FSNetworkRequest *)networkRequest
{
    // ===================================================
    // 发送网络请求
    // ===================================================
    FSAFNetworkingManager *sessionManager = [FSAFNetworkingManager sharedManager];
    
    // 设置超时时间
    [sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    sessionManager.requestSerializer.timeoutInterval = kTimeoutInterval;
    [sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [sessionManager.requestSerializer setHTTPShouldHandleCookies:YES];
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:networkRequest.totalUrlString parameters:networkRequest.totalRequestParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (FSFormDataItem *item in networkRequest.uploadFormDataArray)
        {
            if (item.data) {
                [formData appendPartWithFileData:item.data name:item.keyName fileName:@"file" mimeType:@"JPG"];
            }
        }
        
    } error:nil];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [sessionManager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          //                          [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error)
                      {
                          // 失败
                          networkRequest.searchResult.msg = @"网络连接失败";
                          
                          [self networkFailure:networkRequest];
                          
                          printf("%s:%s", [networkRequest.requestName UTF8String], [error.description UTF8String]);
                          [self printRequestInfo:networkRequest];
                          
//#warning 打印数据问题
//                          UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//
//                          if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
//                              rootVC = ((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController;
//                          }
//                          UINavigationController *nav;
//                          if ([rootVC isKindOfClass:[UINavigationController class]]) {
//                              nav = (UINavigationController *)rootVC;
//                          }
//                          else {
//                              nav = rootVC.navigationController;
//                          }
//
//                          UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%s--%s",[networkRequest.requestName UTF8String], [error.description UTF8String]] preferredStyle:UIAlertControllerStyleAlert];
//
//                          [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//                          }]];
//                          [nav presentViewController:alert animated:YES completion:nil];
                      }
                      else
                      {
                          // 成功
                          networkRequest.responseData = responseObject;
                          [self doHandleResponseData:networkRequest];
                      }
                  }];
    
    [uploadTask resume];
    
    return uploadTask;
}

/**
 *  多维上传(带进度）
 *
 */
- (NSURLSessionUploadTask *)postMultiPartUpLoadRequest:(FSNetworkRequest *)networkRequest
{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:networkRequest.totalUrlString parameters:networkRequest.totalRequestParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSInteger i = 0;
        for (NSData *data in networkRequest.uploadDataArray)
        {
            [formData appendPartWithFormData:data name:[NSString stringWithFormat:@"data%ld", (long)i++]];
        }
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          //                          [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error)
                      {
                          NSLog(@"Error: %@", error);
                          networkRequest.searchResult.msg = @"上传失败";
                          [self networkFailure:networkRequest];
                      }
                      else
                      {
                          NSLog(@"Success: %@ %@", response, responseObject);
                          
                          networkRequest.searchResult.msg = responseObject;
                          
                          [self networkSuccess:networkRequest];
                      }
                  }];
    
    [uploadTask resume];
    
    return uploadTask;
}

/**
 *  上传data
 *
 *  @param networkRequest
 */
- (NSURLSessionUploadTask *)postUpLoadDataRequest:(FSNetworkRequest *)networkRequest
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:networkRequest.totalUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithRequest:request
                  fromData:networkRequest.uploaData
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          //                          [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error)
                      {
                          NSLog(@"Error: %@", error);
                          networkRequest.searchResult.msg = @"上传失败";
                          [self networkFailure:networkRequest];
                      }
                      else
                      {
                          NSLog(@"Success: %@ %@", response, responseObject);
                          
                          networkRequest.searchResult.msg = responseObject;
                          
                          [self networkSuccess:networkRequest];
                      }
                  }];
    
    [uploadTask resume];
    
    return uploadTask;
}

#pragma mark - 数据处理
- (void)doHandleResponseData:(FSNetworkRequest *)networkRequest
{
    // 子类实现
}

#pragma mark - 请求回调
/**
 *  成功
 *
 *  @param networkRequest
 */
- (void)networkSuccess:(FSNetworkRequest *)networkRequest
{
    if (networkRequest && networkRequest.networkDelegate && [networkRequest.networkDelegate respondsToSelector:@selector(fsNetworkSuccessed:)])
    {
        [networkRequest.networkDelegate fsNetworkSuccessed:networkRequest];
    }
}

/**
 *  请求失败
 *
 */
- (void)networkFailure:(FSNetworkRequest *)networkRequest
{
    if (networkRequest.networkDelegate && [networkRequest.networkDelegate respondsToSelector:@selector(fsNetworkFailed:)])
    {
        [networkRequest.networkDelegate fsNetworkFailed:networkRequest];
    }
    
}

#pragma mark - 其他方法
/**
 *  将url中的字典类型参数，拼成请求的参数格式
 *
 *  @param prefix   参数前缀
 *  @param params   参数
 *  @param encoding 编码
 *
 *  @return 参数
 */
+ (NSString*)encodedUrlForUrlPrefix:(NSString*)prefix params:(NSDictionary*)params encoding:(NSStringEncoding)encoding
{
    NSMutableString *ms = [NSMutableString stringWithCapacity:100];
    [ms appendString:prefix];
    
    NSArray *keys = [params allKeys];
    for (int i=0; i<keys.count; i++)
    {
        NSString *k = [keys objectAtIndex:i];
        NSString *value = [NSString stringWithFormat:@"%@", [params objectForKey:k]];
        if (i != 0) {
            [ms appendString:@"&"];
        }
        
        value = [FSAFNetworkingManager urlEncodeString:value];

        [ms appendFormat:@"%@=%@", k, value];
    }
    
    return ms;
//    return [ms stringByAddingPercentEscapesUsingEncoding:encoding];
}

+ (NSString *)urlEncodeString:(NSString *)input
{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}

- (void)printRequestInfo:(FSNetworkRequest *)networkRequest
{
    // 请求参数
    NSString *requestString = [FSAFNetworkingManager encodedUrlForUrlPrefix:@"" params:networkRequest.totalRequestParam encoding:NSUTF8StringEncoding];
    
    NSMutableString *requestUrl = [[NSMutableString alloc] initWithString:networkRequest.totalUrlString];
    [requestUrl appendString:requestString];
    
    NSLog(@"\n=======================\n[GET/POST][%@]:%@\n=======================\n", networkRequest.requestName, requestUrl);
    NSLog(@"\n=======================\n[GET/POST][%@]:%@=======================\n", networkRequest.requestName,networkRequest.totalRequestParam);
}
@end
