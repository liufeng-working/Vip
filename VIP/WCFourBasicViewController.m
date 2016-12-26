//
//  WCFourBasicViewController.m
//  VIP
//
//  Created by NJWC on 16/4/1.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCFourBasicViewController.h"
#import "WCOneBasicViewController.h"
#import "WCNavigationView.h"
#import "WCCarMessageView.h"
#import "WCExtraView.h"
#import "WCControView.h"
#import "WCHTTPRequest.h"
#import "WCTaskInfo.h"
#import "WCCarMessage.h"
#import <AMapNaviKit/MAPointAnnotation.h>
#import "WCMAPointAnnotion.h"
#import "WCDataBaseTool.h"
#import "WCDataSolver.h"
#import "WCIntersectionInfo.h"
@interface WCFourBasicViewController ()<WCNavigationViewDelegate,WCControViewDelegate>

@end

@implementation WCFourBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationView.index = 4;
    self.navigationView.delegate = self;
    NSMutableArray *nameArr = [NSMutableArray array] ;
    for (WCIntersectionInfo * info in self.route.annotionsOnRoutes) {
        [nameArr addObject:info.intersectionName] ;
    }

    NSInteger row ;
    if (nameArr.count % 9 == 0) {
        row = nameArr.count / 9;
    }else{
        row =nameArr.count / 9 + 1;
    }
    CGFloat roadH = row * (70 + 22);
    UIScrollView *bgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavigationHeight, kMainViewWidth, kMainViewHeight - 100)];
    bgScroll.backgroundColor = [UIColor clearColor];
    bgScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:bgScroll];
    
    WCCarMessageView *carView = [WCCarMessageView carMessageViewWithFrame:CGRectMake(tLineViewAndTabDis, tLineViewAndNavDis, kMainViewWidth - 2 * tLineViewAndTabDis, 90 + roadH)];
    //设置基础信息
    WCOneBasicViewController *oVC = self.navigationController.viewControllers[0];
    carView.carMessage = oVC.carMessage;
    carView.nameArray = nameArr;
    [bgScroll addSubview:carView];
    
    WCExtraView *extraView = [WCExtraView extraViewWithFrame:CGRectMake(bMainViewAndTabDis, bMainViewAndNavDis + carView.bottom, kMainViewWidth - 2 * bMainViewAndTabDis, 250)];
    extraView.hiddenSelectBtn = YES;
    [bgScroll addSubview:extraView];
    [self showImageWith:extraView];
    
    bgScroll.contentSize = CGSizeMake(kMainViewWidth, 10 + carView.height + 10 + extraView.height + 10);
    if(bgScroll.contentSize.height < bgScroll.height){
        bgScroll.contentSize = CGSizeMake(kMainViewWidth, bgScroll.height + 1);
    }
    
    
    WCControView *controView = [WCControView controViewWithFrame:CGRectMake(0, kContentHeight - 100, kMainViewWidth, 100)];
    controView.delegate = self;
    [self.view addSubview:controView];
}


//展示用户之前选择的图片
- (void)showImageWith:(WCExtraView *)extraView
{
    WCOneBasicViewController *oVC = self.navigationController.viewControllers[0];
    if(!oVC.imageArray.count){
        
        extraView.hidden = YES;
    }else{
        
        for (NSInteger i = 0; i < oVC.imageArray.count; i ++)
        {
            UIImage *image = oVC.imageArray[i];
            extraView.image = image;
        }
    }
}

#pragma mark - ****WCControViewDelegate****
-(void)controClickWithIndex:(NSInteger)index
{
    /*
     index 0:点击了保存提交的确认按钮
           1:点击了立即执行的确认按钮
     */
    /**参数列表account=xxx&plate=xxx&vehicleNum=xxx&priority=xxx&urls=xxx,xxx,xxx&intersections=xxx,xxx,xxx&length=xxx&preTime=xxx&programs=xxx,xxx,xxx&stages=xxx,xxx,xxx&status=xxx&description=xxx
     */

    WCOneBasicViewController *oVC = self.navigationController.viewControllers[0];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"account"] = [kDefaults objectForKey:kAccount];
    dic[@"plate"] = oVC.carMessage.plate;//车牌号
    dic[@"vehicleNum"] = @([oVC.carMessage.vehicleNum integerValue]);//车辆数目
    dic[@"priority"] = @([self getPriorityWithPriority:oVC.carMessage.priority]);//优先级
    dic[@"urls"] = [self getStringWithArray:oVC.imgUrl];//附件图片链接
    dic[@"description"] = oVC.carMessage.descriptions;//描述
    dic[@"status"] = @(index);//任务状态
    
    
    //小朱，这些个参数 靠你了啊
    dic[@"intersections"] = self.senderDic[@"intersections"];//路口编号
    dic[@"length"] = self.senderDic[@"length"];//路线长度
    dic[@"preTime"] = self.senderDic[@"preTime"];//行程时间
    dic[@"programs"] = self.senderDic[@"programs"];//.
    dic[@"stages"] = self.senderDic[@"stages"];//相位编号
    
    //新增参数
    dic[@"points"] = [WCDataSolver mapAllNaviPointFromArray:self.route.routeSegments] ;
    
    
    if (index == 0) {
        
        [WCHTTPRequest saveTaskWith:dic success:^(WCTaskInfo *info) {
            
            //保存截图
            [self saveImage:info.taskId];
            
            [WCPhoneNotification autoHideWithText:@"任务保存成功！"];
            //一个任务上传服务器后，就应该回到第一个页面，让用户重新填写信息，选择路线等等。。。这是一个流程
            
            //发通知,让其他页面，做出反应
            NSDictionary * dic = @{@"isGoto":@(index)};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoPerformTaskViewController" object:self userInfo:dic];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
            
        } failure:^(NSString *error) {
            [WCPhoneNotification autoHideWithText:@"保存任务失败!"];
        }];
    }else if(index == 1){
        
        [WCHTTPRequest isTaskExecution:^(BOOL isYES) {

            if (isYES) {
                [WCPhoneNotification autoHideWithText:@"有任务正在执行中，请先保存提交！"];
            }else{
                [WCHTTPRequest saveTaskWith:dic success:^(WCTaskInfo *info) {
                    
                    [self saveImage:info.taskId] ;
                    
                    //一个任务上传服务器后，就应该回到第一个页面，让用户重新填写信息，选择路线等等。。。这是一个流程
                    
                    //发通知,让其他页面，做出反应
                    NSDictionary * dic = @{@"isGoto":@(index),
                                           @"info":info};
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoPerformTaskViewController" object:self userInfo:dic];
                    [self.navigationController popToRootViewControllerAnimated:YES];

                } failure:^(NSString *error) {
                    [WCPhoneNotification autoHideWithText:error];
                }];
            }
        }];
    }
}
-(void)saveImage:(NSInteger)ID {

    [WCDataBaseTool saveImageWithImage:self.route.screenShotImage withTaskId:ID];

}
//转换优先级
-(NSInteger)getPriorityWithPriority:(NSString *)priority
{
    if ([priority isEqualToString:@"紧急"]) {
        return 3;
    }else if([priority isEqualToString:@"优先"]){
        return 2;
    }else{//一般
        return 1;
    }
}

//根据数组，获取字符串
-(NSString *)getStringWithArray:(NSArray *)array
{
    return [array componentsJoinedByString:@","];
}
/**
 *  返回上一个页面
 */
-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
