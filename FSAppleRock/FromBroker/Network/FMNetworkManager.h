//
//  FMNetworkManager.h
//  FMLibrary
//
//  Created by fangstar on 13-4-1.
//  Copyright (c) 2013年 fangstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"

@protocol FMNetworkProtocol;
@protocol FMNetworkRequestProtocol;

//	自定义网络数据包头，用于区分不同类型的请求和回复
@interface FMNetworkRequest : NSObject
{
    NSString *_requestName;             //请求方法名
	id _responseData;                   //返回数据
    id _requestData;                    //请求数据
	id <FMNetworkProtocol> _networkDelegate;   //
    id <FMNetworkRequestProtocol> _requestDelegate;
	ASIHTTPRequest *_asiHttpRequest;
    
    //统计数据用
    NSTimeInterval _startTime;
    NSTimeInterval _endTime;
    
    long long _uploadedBytes;
    long long _downloadedBytes;
    
    CGFloat _uploadedPercent;
    CGFloat _downloadedPercent;
    
    BOOL _isSkipFilterRequest;
}
@property (nonatomic, copy) NSString *requestName;
@property (nonatomic, retain) id responseData;
@property (nonatomic, retain) id requestData;
@property (nonatomic, weak) id <FMNetworkProtocol> networkDelegate;
@property (nonatomic, weak) id <FMNetworkRequestProtocol> requestDelegate;
@property (nonatomic, retain) ASIHTTPRequest *asiHttpRequest;

@property (nonatomic, readonly) NSTimeInterval startTime;
@property (nonatomic, readonly) NSTimeInterval endTime;
@property (nonatomic, readonly) long long uploadedBytes;
@property (nonatomic, readonly) long long downloadedBytes;

@property (nonatomic) BOOL isSkipFilterRequest;
-(void)start;
-(void)stop;

@end

@interface FMNetworkManager : NSObject <ASIHTTPRequestDelegate, ASIProgressDelegate>
{
    NSMutableDictionary *_registedInstances;        //instance地址做Key，value为Dictionary对象, 存放FMNetworkData，以data地址做key，对象做value
    NSString *_fsnSession;
}
@property (nonatomic, retain) NSString *fsnSession;
+(id)sharedInstance;
-(BOOL)registNetwork:(id)instanceAddress;
-(BOOL)unregistNetwork:(id)instanceAddress;
-(BOOL)addNetworkRequest:(FMNetworkRequest*)networkRequest forInstance:(id)instance;
-(void)cancelNetworkRequest:(FMNetworkRequest*)networkData;
-(FMNetworkRequest*)downloadImageUrl:(NSString*)urlString requestName:(NSString*)requestName requestData:(NSString*)requestData delegate:(id<FMNetworkProtocol>)networkDelegate;

+(BOOL)isNetworkReachable;
+(NetworkStatus)networkReachableStatus;
+(NSString*)networkReachableDescriptionForStatus:(NetworkStatus)status;
+(NSString*)encodedUrlForUrlPrefix:(NSString*)prefix params:(NSDictionary*)params;
+(NSString*)encodedUrlForUrlPrefix:(NSString*)prefix params:(NSDictionary*)params enc:(NSStringEncoding)encoding;

-(FMNetworkRequest*)addGetUrl:(NSString*)urlString
                  requestName:(NSString*)requestName
                     delegate:(id<FMNetworkProtocol>)networkDelegate;
-(FMNetworkRequest*)addPostUrl:(NSString*)urlString
                   requestName:(NSString*)requestName
                     formDatas:(NSDictionary*)formDatas
                      delegate:(id<FMNetworkProtocol>)networkDelegate;

//use statist only
-(FMNetworkRequest*)addStatistPostUrl:(NSString*)urlString
                          requestName:(NSString*)requestName
                            formDatas:(NSDictionary*)formDatas
                             delegate:(id<FMNetworkProtocol>)networkDelegate;

-(FMNetworkRequest*)addPostUrl:(NSString*)urlString
                   requestName:(NSString*)requestName
                     formDatas:(NSDictionary*)formDatas
                           enc:(NSStringEncoding)enc
                      delegate:(id<FMNetworkProtocol>)networkDelegate;

@end

@protocol FMNetworkProtocol <NSObject>

-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest;
-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest;
@end

@protocol FMNetworkRequestProtocol <NSObject>
@optional
-(void)fmNetworkRequestUploadProgressDidChanged:(FMNetworkRequest*)fmNetworkRequest;
-(void)fmNetworkRequestDownloadProgressDidChanged:(FMNetworkRequest*)fmNetworkRequest;
-(void)fmNetworkRequestFinishedStat:(FMNetworkRequest*)fmNetworkRequest;
@end
