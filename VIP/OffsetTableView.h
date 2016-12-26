//
//  OffsetTableView.h
//  VIP
//
//  Created by 万存 on 16/3/25.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffsetTableView : UIView <UITableViewDataSource ,UITableViewDelegate>


@property (nonatomic ,strong) NSMutableArray * lineArray ;
@property (nonatomic ,strong) NSMutableArray *offsetNameArr ;
@end
