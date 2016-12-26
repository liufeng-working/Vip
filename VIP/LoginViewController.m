//
//  LoginViewController.m
//  VIP
//
//  Created by NJWC on 16/3/16.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "LoginViewController.h"
#import "WCTabBarController.h"
#import "WCViewControllers.h"
#import "WCHTTPRequest.h"
#import "WCNetworkStatus.h"


@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *isRememberPassWord;

- (IBAction)rememberPasswordClick:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userName.text = [kDefaults objectForKey:kUserName];
    self.passWord.text = [kDefaults objectForKey:kPassWord];
    self.isRememberPassWord.selected = [kDefaults boolForKey:@"remember"];

}

//登陆按钮
- (IBAction)loginButtonClick:(UIButton *)sender {

    //如果没有网，直接登录失败
    if(![WCNetworkStatus isAvailableNetwork]){
        [WCPhoneNotification autoHideWithText:@"网络异常"];
        return;
    }
    
    //验证用户名密码是否为空
    if (![self isAvailableNameAndPassword]) {
        [WCPhoneNotification autoHideWithText:@"用户名或密码不能为空"];
        return;
    }
 
    //登录过程中，提示框
    [WCPhoneNotification manuallyHideWithIndicator];
    
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    userDic[@"account"] = self.userName.text;
    userDic[@"password"] = self.passWord.text;
    
    //测试账号
//    account  :shengwang
//    password :123
    userDic[@"facilityId"] = @"123";

    [WCHTTPRequest loginWithAccount:userDic success:^(NSString *success) {
        //隐藏提示框
        [WCPhoneNotification hideNotification];
        
        if ([success isEqualToString:@"success"]) {
            //存储账号密码
            [self saveAccount];
            
            [self gotoMainViewController];
            
            //获取所有的信控点
            [WCHTTPRequest getIntersections];
  
        }else{
            [WCPhoneNotification autoHideWithText:@"登陆失败，请重试"];
        }
        
        
        
    } failure:^(NSString *error) {
        
        [WCPhoneNotification hideNotification];
    }];
}

//验证用户名密码
-(BOOL)isAvailableNameAndPassword
{
    if ([self.userName.text isEmptyOrBlank] || [self.passWord.text isEmptyOrBlank]) {
        return NO;
    }
    return YES;
}

//存储/清除 账号密码
-(void)saveAccount
{
    if (!self.isRememberPassWord.selected){
        
        [kDefaults removeObjectForKey:kUserName];
        [kDefaults removeObjectForKey:kPassWord];
        [kDefaults removeObjectForKey:@"remember"];
        [kDefaults synchronize];
    }else{
        [kDefaults setObject:self.userName.text forKey:kUserName];
        [kDefaults setObject:self.passWord.text forKey:kPassWord];
        [kDefaults setBool:self.isRememberPassWord.selected forKey:@"remember"];
        [kDefaults synchronize];
    }
}

//从登陆页面跳转到主页
-(void)gotoMainViewController
{
    WCTabBarController * tbVC = [[WCTabBarController alloc]init];
    tbVC.controllers = [WCViewControllers getViewControllers];
    
    //改变窗口的根控制器
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.rootViewController = tbVC;
}

//点击了记住密码
- (IBAction)rememberPasswordClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}

//隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
