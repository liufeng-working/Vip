//
//  PresentOverUsedCell.h
//  VIP
//
//  Created by 万存 on 16/3/28.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCLineInfo.h"
@interface PresentOverUsedCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lineNameLabel;

@property (nonatomic ,strong) WCLineInfo * info ;
@end
