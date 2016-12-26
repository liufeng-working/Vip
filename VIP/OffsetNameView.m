//
//  OffsetNameView.m
//  VIP
//
//  Created by 万存 on 16/3/29.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "OffsetNameView.h"
#import "OffsetNameCell.h"
#import "WCStageList.h"

@interface OffsetNameView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) UIWindow * realWindow ;
@property (nonatomic,strong) UIWindow * instanceWindow ;

@property (nonatomic ,strong) NSMutableArray * dataSource ;

@property (nonatomic ,strong) NSIndexPath * lastSelectedIndexPath;

@end

@implementation OffsetNameView
+(void) showOffestWithData:(NSArray *)data withIndex:(NSInteger)index SureBlock:(SureBlock) sure{
    
    [[self loadOffsetNameView] showWithBlock:sure source:data withIndex:index];
}
+(OffsetNameView * )loadOffsetNameView{
    OffsetNameView * v = [[NSBundle mainBundle] loadNibNamed:@"OffsetNameView" owner:self options:nil] [0];
    v.frame = CGRectMake(0, 0, 400, 450);
    
    return v;
}
-(void)showWithBlock:(SureBlock) sure source:(NSArray *)source withIndex:(NSInteger)index{
    _instanceWindow  = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _instanceWindow.rootViewController  = [UIViewController new] ;
    _instanceWindow.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5] ;
 
    _realWindow = [[UIApplication sharedApplication].delegate window];
    
    
    self.frame = CGRectMake(0, 0, 400, 450);
    self.center = _instanceWindow.center;
    [_instanceWindow.rootViewController.view  addSubview:self] ;
    
    self.sure = sure ;
    
    self.dataSource = [source copy] ;
    self.lastSelectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_tableView reloadData] ;

    
    [self show];                                 
    
}
-(void)show{
    [_realWindow resignKeyWindow] ;
    [_instanceWindow makeKeyAndVisible] ;
    
}
-(void)dismiss{
    [_instanceWindow resignKeyWindow] ;
    [_realWindow makeKeyAndVisible] ;
}
- (IBAction)click:(UIButton *)sender {
    [self dismiss] ;
    if (sender.tag == 2 &&self.sure) {
        self.sure(self.lastSelectedIndexPath) ;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return   self.dataSource.count ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OffsetNameCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"] ;
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"OffsetNameCell" owner:self options:nil ][0];
    }
    WCStageList * list = self.dataSource [indexPath.row] ;
    cell.offsetNameLabel.text  =list.stageName ;
    
    if (self.lastSelectedIndexPath == indexPath) {
        cell.checkImageView.hidden = NO;
    }else{
        cell.checkImageView.hidden = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.lastSelectedIndexPath = indexPath ;
    [self.tableView reloadData];
    
    if (self.sure) {
        self.sure(self.lastSelectedIndexPath) ;
    }
    
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.1];
}

@end
