//
//  WCHTTPTool.h
//  VIP
//
//  Created by NJWC on 16/4/5.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface WCHTTPTool : NSObject

/**
 *  GET请求获取数据
 *
 *  @param URLString  url
 *  @param parameters 参数列表
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

/**
 *  POST请求获取数据
 *
 *  @param URLString  url
 *  @param parameters 参数列表
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

/**
 *  POST请求上传图片(只能一张一张的上传)
 *
 *  @param URLString  url
 *  @param parameters 参数列表
 *  @param images     上传的图片
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
      images:(UIImage *)image
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

@end
