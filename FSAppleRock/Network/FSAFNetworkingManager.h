//
//  FSAFNetworkingManager.h
//  FSLibrary_IOS
//
//  Created by ZhangLan_PC on 16/7/8.
//  Copyright © 2016年 fangstar.net. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "FSNetworkRequest.h"

@protocol FSNetworkProtocol <NSObject>

@optional

// 获取网络请求回调
- (void)fsNetworkSuccessed:(FSNetworkRequest *)networkRequest;

// 获取网络请求失败回调
- (void)fsNetworkFailed:(FSNetworkRequest *)networkRequest;

@end

@interface FSAFNetworkingManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

#pragma mark - 网络状态相关
/**
 *  监控网络状态
 */
- (void)startMonitorNetwork;
/**
 *  检查网络状态
 */
- (BOOL)checkNetworkStatus:(FSNetworkRequest *)networkRequest;

#pragma mark - 网络回调
/**
 *  网络请求成功
 *
 */
- (void)networkSuccess:(FSNetworkRequest *)networkRequest;

/**
 *  网络请求失败
 *
 */
- (void)networkFailure:(FSNetworkRequest *)networkRequest;

#pragma mark - 请求列表
/**
 *  添加请求
 *
 *  @param networkRequest 里面配置POST/GET
 */
- (void)addRequest:(FSNetworkRequest *)networkRequest;

// 下载文件
- (NSURLSessionTask *)postDownLoadRequest:(FSNetworkRequest *)networkRequest;

// 上传文件
- (NSURLSessionUploadTask *)postUpLoadRequest:(FSNetworkRequest *)networkRequest;

// 多维上传(带进度）
- (NSURLSessionUploadTask *)postMultiPartUpLoadRequest:(FSNetworkRequest *)networkRequest;

// 上传data
- (NSURLSessionUploadTask *)postUpLoadDataRequest:(FSNetworkRequest *)networkRequest;

#pragma mark - 其他
/**
 *  将url中的字典类型参数，拼成请求的参数格式
 *
 *  @param prefix   参数前缀
 *  @param params   参数
 *  @param encoding 编码
 *
 *  @return 参数
 */
+ (NSString*)encodedUrlForUrlPrefix:(NSString*)prefix params:(NSDictionary*)params encoding:(NSStringEncoding)encoding;

/**
 *  多维表单上传
 *
 */
- (NSURLSessionUploadTask *)postFormUpLoadRequest:(FSNetworkRequest *)networkRequest;
/**
 *  多维表单上传（尊园之星）
 *
 */
- (NSURLSessionUploadTask *)postFormUpLoadForFangstarRequest:(FSNetworkRequest *)networkRequest;

@end
