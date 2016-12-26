//
//  TaskExcuteView.m
//  VIP
//
//  Created by 万存 on 16/3/22.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "TaskExcuteView.h"

@implementation TaskExcuteView


-(instancetype)initWithTaskType:(TaskType)type position:(CGPoint)point times:(NSString *)times{
    if (self = [super init]) {
        
        [self initViewWithType:type position:point times:times];
    }
    return self;
}

-(void)initViewWithType:(TaskType) type position:(CGPoint)position times:(NSString *)times{
    
    UIImage * statusImage =[UIImage imageNamed:[NSString stringWithFormat:@"icon_task%d",type]];
    
    UIImage * backGroundImage = [UIImage imageNamed:@"task_background"];
    
//    CGFloat imageW = (kContentWidth/2-10-20-40)/3;
//    CGFloat scaleH = imageW*backGroundImage.size.height/backGroundImage.size.width;
    self.frame  = CGRectMake(position.x, position.y, backGroundImage.size.width, backGroundImage.size.height);

    UIImageView * backImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, backGroundImage.size.width, backGroundImage.size.height)];
    backImageView.image = backGroundImage;
    [self addSubview:backImageView];
    
    
    UIImageView * taskImageView = [[UIImageView alloc]initWithFrame:CGRectMake(11, 9, statusImage.size.width , statusImage.size.height)];
    taskImageView.image =statusImage;
    [backImageView addSubview:taskImageView];
    
    NSString * taskStatus = nil;
    if (type == TaskTypeWaitting) {
        taskStatus = @"待执行";
    }else if (type == TaskTypeExcuting){
        taskStatus = @"执行中";
    }else{
        taskStatus = @"已执行";
    }
    
    UILabel * taskStatusLabel = [UILabel new];
    taskStatusLabel.center = CGPointMake(taskImageView.right+4+[taskStatus widthWithFontSize:15]/2, taskImageView.centerY);
    taskStatusLabel.bounds =CGRectMake(0, 0, [taskStatus widthWithFontSize:15], 21);
    taskStatusLabel.text = taskStatus;
    taskStatusLabel.font = [UIFont systemFontOfSize:15];
    taskStatusLabel.textColor = [UIColor colorWithHexString:@"#8899AA"];
    [backImageView addSubview:taskStatusLabel];
    
    
    NSMutableAttributedString * timesString  = [[NSMutableAttributedString alloc]initWithString:times];
    NSRange  numberRange = NSMakeRange(0, [[timesString string] rangeOfString:@"/"].location);
    NSRange  unitRange   = NSMakeRange(numberRange.length, 2);

    [timesString attributeStringWithFontSize:61.5
                                    fontName:@"Arial-BoldMT"
                                 inputString:timesString
                                       color:@"#F96268"
                                       range:numberRange];
    [timesString attributeStringWithFontSize:15
                                    fontName:nil
                                 inputString:timesString
                                       color:@"#8899AA"
                                       range:unitRange];
    
    UILabel * timesLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0, 18+statusImage.size.height, self.bounds.size.width, self.bounds.size.height-18-statusImage.size.height)];
    timesLabel.attributedText = timesString;
    timesLabel.textAlignment =NSTextAlignmentCenter;
    [backImageView addSubview:timesLabel];
    
    
    
    
    
    
}

@end
