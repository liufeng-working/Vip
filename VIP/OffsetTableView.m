//
//  OffsetTableView.m
//  VIP
//
//  Created by 万存 on 16/3/25.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "OffsetTableView.h"
#import "OffsetTableViewCell.h"
#import "OffsetHeader.h"
#import "OffsetNameView.h"
#import "WCHTTPRequest.h"
#import <AMapNaviKit/MAPointAnnotation.h>
#import "WCStageList.h"
#import "WCStageSetting.h"
#import "WCIntersectionInfo.h"
@interface OffsetTableView() <UITableViewDelegate ,UITableViewDataSource,OffsetTableCellDelegate>

@property (nonatomic,strong)  UITableView * tableView ;

@property (nonatomic ,strong) NSMutableArray * poster ;

@property (nonatomic, strong)NSMutableArray *selectArr;
@end

@implementation OffsetTableView

-(NSMutableArray *)selectArr
{
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    
    return _selectArr;
}

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _poster =[NSMutableArray array] ;

        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _tableView.backgroundColor =[UIColor clearColor] ;
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.rowHeight = 44 ;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
        [_tableView registerNib:[UINib nibWithNibName:@"OffsetTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        [self addSubview:_tableView];
        
    }

    return self;
}
//#pragma mark -- 获取相位数据
//-(void)getOffsetData{
//    NSMutableArray * IDArr = [NSMutableArray array] ;
//    for (MAPointAnnotation *ann in self.lineArray) {
//        [IDArr addObject:ann.subtitle] ;
//    }
//    NSString * IDString = [IDArr componentsJoinedByString:@","] ;
//    [WCHTTPRequest getStageInfoWithIntersections:IDString success:^(NSArray *success) {
//        _offsetNameArr = [success mutableCopy ];
//        [_tableView reloadData] ;
//    } failure:^(NSString *error) {
//        NSLog(@"获取相位信息失败__%s",__FUNCTION__) ;
//    }];
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.lineArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OffsetTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath] ;
//    默认显示第一个
    WCStageList * stage = self.poster[indexPath.row] ;

    cell.delegate = self ;
    cell.info = self.lineArray [indexPath.row] ;
    
    cell.numLabel.text = [NSString stringWithFormat:@"%lu",(long)indexPath.row+1] ;
    cell.offsetNameLabel.text  =stage.stageName  ;

    if ([self.selectArr containsObject:indexPath]) {
        cell.numLabel.textColor = [UIColor greenColor];
        cell.roadPeriodLabel.textColor = [UIColor greenColor];
        cell.offsetNameLabel.textColor = [UIColor greenColor];
    }else{
        cell.numLabel.textColor = [UIColor blackColor];
        cell.roadPeriodLabel.textColor = [UIColor blackColor];
        cell.offsetNameLabel.textColor = [UIColor blackColor];
    }
    return cell;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    OffsetHeader * header = [OffsetHeader loadHeaderView] ;
    return header;
}
-(void)offsetCellClicked:(OffsetTableViewCell *)cell{
    NSIndexPath * indexPath = [_tableView indexPathForCell:cell] ;
    WCStageSetting * sourceSetting = self.offsetNameArr[indexPath.row] ;
    
    NSInteger index = -1;
    for (NSInteger i = 0; i < sourceSetting.stageList.count; i ++)
    {
        WCStageList *list = sourceSetting.stageList [i];
        if ([list.stageName isEqualToString:cell.offsetNameLabel.text]) {
            index = i;
            break;
        }
    }
    
    [OffsetNameView showOffestWithData:sourceSetting.stageList withIndex:index SureBlock:^(NSIndexPath *selecetdIndexPath ){
        
        if (![self.selectArr containsObject:indexPath]) {
            [self.selectArr addObject:indexPath];
        }
        
        WCStageList *list = sourceSetting.stageList [selecetdIndexPath.row] ;
        cell.offsetNameLabel.text  = list.stageName ;
        [self.tableView reloadData];
        
        [_poster replaceObjectAtIndex:indexPath.row withObject:list] ;
        NSDictionary * dic = @{@"IDArray":_poster} ;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"POSTSTAGEID" object:self userInfo:dic];
        
    }];
}

-(void)setLineArray:(NSMutableArray *)lineArray{
    _lineArray = lineArray ;
}
-(void)setOffsetNameArr:(NSMutableArray *)offsetNameArr{
    _offsetNameArr = offsetNameArr ;
    for (WCStageSetting * setting in _offsetNameArr) {
        WCStageList  *stage = setting.stageList [0];
        [_poster addObject:stage] ;
    }
    [_tableView reloadData];
    
    NSDictionary * dic = @{@"IDArray":_poster} ;
     [[NSNotificationCenter defaultCenter] postNotificationName:@"POSTSTAGEID" object:self userInfo:dic];
}
@end
