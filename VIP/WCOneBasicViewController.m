//
//  WCOneBasicViewController.m
//  VIP
//
//  Created by NJWC on 16/4/1.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCOneBasicViewController.h"
#import "WCNavigationView.h"
#import "WCTwoBasicViewController.h"
#import "WCBasicMessageView.h"
#import "WCExtraView.h"
#import "WCDeviceDirectionTool.h"


#import "WCTaskInfo.h"
#import "WCHTTPRequest.h"
#import "WCCarMessage.h"
#import "WCPerformTaskViewController.h"
#import "WCRoute.h"
#import "WCDataBaseTool.h"
@interface WCOneBasicViewController ()<WCExtraViewDelegate,WCNavigationViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    WCBasicMessageView * _basicView;
    WCExtraView * _extraView;
}

@end

@implementation WCOneBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationView.index = 1;
    self.navigationView.delegate = self;
    
    UIScrollView *bgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavigationHeight, kMainViewWidth, kMainViewHeight - 1)];
    bgScroll.contentSize = CGSizeMake(kMainViewWidth, kMainViewHeight);
    bgScroll.backgroundColor = [UIColor clearColor];
    bgScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:bgScroll];
    
    _basicView = [WCBasicMessageView basicMessageViewWithFrame:CGRectMake(bMainViewAndTabDis, bMainViewAndNavDis, kContentWidth - 2 * bMainViewAndTabDis, 245)];
    [bgScroll addSubview:_basicView];
    
    //设置车牌号
    [self setPlate];
    
    //附件
    _extraView = [WCExtraView extraViewWithFrame:CGRectMake(bMainViewAndTabDis, bMainViewAndNavDis + _basicView.bottom, kContentWidth - 2 * bMainViewAndTabDis, 240)];
    _extraView.delegate = self;
    [bgScroll addSubview:_extraView];
 
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanMessageAndGoto:) name:@"gotoPerformTaskViewController" object:nil];
}

-(NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)setPlate
{
    NSString *plate = [WCDataBaseTool getPlate];
    if (plate) {
        _basicView.plate.text = plate;
    }
}

#pragma mark - ****WCExtraViewDelegate****
-(void)selectImageWithView:(WCExtraView *)extraView withIndex:(NSInteger)index
{
    UIImagePickerControllerSourceType sourceType;
    if (index == 0) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            [WCPhoneNotification autoHideWithText:@"相册不可用"];
            return;
        }
        
        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }else if(index == 1){
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [WCPhoneNotification autoHideWithText:@"相机不可用"];
            return;
        }
        
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    //1.先设置为竖屏模式
    [WCDeviceDirectionTool shareDeviceDirection].isVertical = YES;
    
    //2.再打开相册/相机
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.sourceType = sourceType;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark - ****UIImagePickerControllerDelegate****
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //存入数组
    
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    [self.imageArray addObject:image];
    
    //显示在界面上
    _extraView.image = image;
    
    
    //选中某张照片后，设置为不是竖屏状态
    [WCDeviceDirectionTool shareDeviceDirection].isVertical = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //取消时，设置为不是竖屏
    [WCDeviceDirectionTool shareDeviceDirection].isVertical = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
}


//推出下一个页面
-(void)rightButtonClick
{
    //进入下一个页面的时候
    [self.view endEditing:YES];
    
    //验证信息完整性
    if (![self verificationMessage]) {
        return;
    }else{
        //能走到这里，说明信息是完整的，保存起来，供最后一个页面使用
        WCCarMessage *carMessage = [[WCCarMessage alloc]init];
        carMessage.plate = _basicView.plate.text;
        carMessage.vehicleNum = _basicView.vehicleNum.text;
        carMessage.priority = _basicView.priority.text;
        carMessage.descriptions = _basicView.descriptions.text;
        self.carMessage = carMessage;
        
    }
    
    //上传图片
    [self uploadImages];
    
    //保存车牌号
    [self savePlate];

    WCTwoBasicViewController *tVC = [[WCTwoBasicViewController alloc]init];
    [self.navigationController pushViewController:tVC animated:YES];
}

//验证信息完整性
- (BOOL)verificationMessage
{
    if(
       //需求更改，车牌号为可选
//       !_basicView.plate.text.length |
       !_basicView.vehicleNum.text.length |
       !_basicView.priority.text.length){
        [WCPhoneNotification autoHideWithText:@"信息不完整"];
        return NO;
    }
    
    if (![_basicView.plate.text isEmptyOrBlank]) {
        if (![_basicView.plate.text isValidateCarNo]) {
            [WCPhoneNotification autoHideWithText:@"车牌号码格式不正确"];
            return NO;
        }
    }

    //图片 为可选
//    if (!self.imageArray.count) {
//        [WCPhoneNotification autoHideWithText:@"至少选择一张图片"];
//        return NO;
//    }
    
    return YES;
}

//上传图片
-(void)uploadImages
{
    if (!self.imageArray.count) {
        return;
    }
    
    for (NSInteger i = 0; i < self.imageArray.count; i ++)
    {
        UIImage *image = self.imageArray[i];
        [WCHTTPRequest uploadImaegWithImages:image Success:^(NSString *url) {
            
            [self.imgUrl addObject:url];
            
        } failure:^(NSString *error) {
            
            NSLog(@"%@",error);
        }];
    }
}

/**
 *  保存车牌号
 */
- (void)savePlate
{
    [WCDataBaseTool savePlateWithPlate:_basicView.plate.text];
}

- (void)cleanMessageAndGoto:(NSNotification *)noti
{
    [self cleanMessage];
    BOOL isGoto = [noti.userInfo[@"isGoto"] integerValue];

    if (isGoto) {
        //在这里做跳转
        WCTaskInfo  * info =  ( WCTaskInfo*)noti.userInfo[@"info"];
        WCPerformTaskViewController *pVC = [[WCPerformTaskViewController alloc]init];
        pVC.taskInfo = info ;
        [self.view addSubview:pVC.view];
        [self addChildViewController:pVC];
    }
    
}

-(void)cleanMessage
{
    //清空基本信息的内容
//    _basicView.plate.text = nil;
    _basicView.vehicleNum.text = nil;
    _basicView.priority.text = nil;
    _basicView.descriptions.text = nil;
    
    //清空数组的内容
    _imageArray = nil;
    _carMessage = nil;
    _imgUrl = nil;
    
    //清空图片的内容
    [_extraView removeImage];
}

-(NSMutableArray *)imgUrl
{
    if (!_imgUrl) {
        _imgUrl = [NSMutableArray array];
    }
    return _imgUrl;
}

-(void)dealloc
{
    NSLog(@"%s",__func__);
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
