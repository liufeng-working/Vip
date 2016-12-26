//
//  WCMAPointAnnotion.h
//  VIP
//
//  Created by 万存 on 16/4/18.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
//该类的存在意义在于可以对象序列化。。。
@interface WCMAPointAnnotion : NSObject <NSCoding>
/*!
 @brief 标题
 */
@property (copy) NSString *title;

/*!
 @brief 副标题
 */
@property (copy) NSString *subtitle;
/*!
 @brief 经纬度
 */
@property (nonatomic, assign) CLLocationDegrees lat ;
@property (nonatomic, assign) CLLocationDegrees lon ;

//mamapAnntation ->wcmapointAnntation  模型转换
+(NSMutableArray *)modelTransformFrom:(NSMutableArray *) arr ;
// wcmapointAnntation ->mamapAnntation
+(NSMutableArray *)modelTransformTo :(NSMutableArray *) arr ;
@end
