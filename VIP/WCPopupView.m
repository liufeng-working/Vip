//
//  WCPopupView.m
//  VIP
//
//  Created by NJWC on 16/4/7.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCPopupView.h"

@interface WCPopupView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)btnClick:(UIButton *)sender;

@end

@implementation WCPopupView

+ (instancetype)popupViewWithFrame:(CGRect)frame
{
    WCPopupView * popupView = [[[NSBundle mainBundle] loadNibNamed:@"WCPopupView" owner:nil options:nil] lastObject];
    popupView.frame = frame;
    return popupView;
}

-(void)setNameArray:(NSArray *)nameArray
{
    _nameArray = nameArray;
    
    self.titleLabel.text = nameArray.count == 3 ? @"优先等级" : @"车辆数目";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nameArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        
        UIImageView *bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 460, 50)];
        bgImg.image = [UIImage imageNamed:@"list_1upper"];
        [cell.contentView addSubview:bgImg];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 300, 50)];
        nameLabel.tag = 10000;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:20];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = [UIColor colorWithHexString:@"#8899AA"];
        [cell.contentView addSubview:nameLabel];
        
        UIImageView *checkImg = [[UIImageView alloc]initWithFrame:CGRectMake(460 - 15 - 25 - 15, 12.5, 25, 25)];
        checkImg.tag = 20000;
        checkImg.image = [UIImage imageNamed:@"icon_check"];
        checkImg.hidden = YES;
        [cell.contentView addSubview:checkImg];
        
    }
    
    
    UILabel *nameLabel = [cell.contentView viewWithTag:10000];
    nameLabel.text = self.nameArray[indexPath.row];
    
    
    //默认第一个是选中的
    UIImageView *checkImg = [cell.contentView viewWithTag:20000];
    if(indexPath.row == self.lastSelectedIndex){
        checkImg.hidden = NO;
    }else{
        checkImg.hidden = YES;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.lastSelectedIndex = indexPath.row;
    [self.tableView reloadData];
    
    if ([_delegate respondsToSelector:@selector(selectWithPopupView:withName:)]) {
        [_delegate selectWithPopupView:self withName:self.nameArray[indexPath.row]];
    }
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.1];
}

/**
 *  需求更改，这两个按钮都被隐藏了，这个方法也不会执行了（2016-08-01修改）
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btnClick:(UIButton *)sender {
    
    if (sender.tag == 1) {
        
    }else if(sender.tag == 2){
        
        if ([_delegate respondsToSelector:@selector(selectWithPopupView:withName:)]) {
            [_delegate selectWithPopupView:self withName:self.nameArray[self.lastSelectedIndex]];
        }
    }
    //从父视图移除
    [self removeFromSuperview];
}

@end
