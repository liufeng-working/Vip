//
//  TaskExcuteView.h
//  VIP
//
//  Created by 万存 on 16/3/22.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(int , TaskType){
    TaskTypeWaitting =1 ,
    TaskTypeExcuting =2 ,
    TaskTypeExcuted  =3
};

@interface TaskExcuteView : UIView


@property (nonatomic,assign) TaskType  taskType;

-(instancetype)initWithTaskType:(TaskType)type position:(CGPoint)point times:(NSString *)times;
@end
