//
//  FSNetworkRequest.h
//  FangStarFindHouse
//
//  Created by ZhangLan_PC on 16/7/5.
//  Copyright © 2016年 fangstar.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSBaseModel.h"

@class FSNetworkRequest;
@protocol FSNetworkProtocol;

@interface FSNetworkRequest : NSObject

// ===================================================
// 请求相关
// ===================================================
@property (nonatomic, strong) NSMutableDictionary *requestParam;        // 请求参数
@property (nonatomic, strong) NSMutableDictionary *totalRequestParam;   // 合并公共参数
@property (nonatomic, strong) NSString *httpMethod;                     // "post"/"get"
@property (nonatomic, strong) id requestData;                           // 请求数据（可以自定义）

@property (nonatomic, strong) NSString *requestName;                    // 请求的接口名称
@property (nonatomic, strong) NSString *requestMethod;                  // 请求的url的后缀路径（也用于区分具体的请求）
@property (nonatomic, strong) NSString *otherSuffix;                  // 请求的url的其他后缀

@property (nonatomic, strong) NSString *totalUrlString;                 // 完整的请求地址

// ===================================================
// 返回相关
// ===================================================
@property (nonatomic, strong) FSBaseModel *searchResult;            // 返回结果Model
@property (nonatomic, strong) id responseData;                          // 返回数据（需要特殊返回的数据）
@property (nonatomic, strong) NSString *responseString;             

// ===================================================
// 代理
// ===================================================
@property (nonatomic, weak) id <FSNetworkProtocol> networkDelegate;

// ===================================================
// 请求任务
// ===================================================
@property (nonatomic, strong) NSURLSessionTask *requestTask;

// ===================================================
// 上传、下载相关
// ===================================================
@property (nonatomic, strong) NSURL *downLoadUrl;              // 下载文件到路径
@property (nonatomic, strong) NSString *uploadUrlString;       // 上传文件的路径

@property (nonatomic, strong) NSMutableArray *uploadDataArray;      // 上传的data

@property (nonatomic, strong) NSMutableArray *uploadFormDataArray;      // 上传的表单数据

@property (nonatomic, strong) NSData *uploaData;

@end
