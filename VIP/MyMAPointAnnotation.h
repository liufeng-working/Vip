//
//  WCMAPointAnnotation.h
//  VIP
//
//  Created by 万存 on 16/4/20.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapNaviKit/MAPointAnnotation.h>
//该类可以用于地图展示
@interface MyMAPointAnnotation : MAPointAnnotation

@property (nonatomic ,assign) NSInteger status ;
@property (nonatomic ,copy)   NSString *ID ;
@end
