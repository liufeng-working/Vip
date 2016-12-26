//
//  WCHTTPTool.m
//  VIP
//
//  Created by NJWC on 16/4/5.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCHTTPTool.h"

@implementation WCHTTPTool

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
    failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

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
     failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  POST请求上传图片
 *
 *  @param URLString  url
 *  @param parameters 参数列表
 *  @param block      上传的数据
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
      images:(UIImage *)image
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //根据当前系统时间生成图片名称（如果用户修改了系统时间，就可能会出现相同的名字）
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:date];
        
        
        NSString *fileName = [NSString stringWithFormat:@"%@.png",dateString];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);

        [formData appendPartWithFileData:imageData
                                    name:@"upload"
                                fileName:fileName
                                mimeType:@"image/jpg/png/jpeg"];

        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
