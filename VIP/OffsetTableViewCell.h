//
//  OffsetTableViewCell.h
//  VIP
//
//  Created by 万存 on 16/3/25.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/MAPointAnnotation.h>
#import "WCIntersectionInfo.h"
@class OffsetTableViewCell ;
@protocol OffsetTableCellDelegate <NSObject>

-(void)offsetCellClicked:(OffsetTableViewCell *)cell ;

@end

@interface OffsetTableViewCell : UITableViewCell

@property (nonatomic ,assign) id<OffsetTableCellDelegate> delegate ;


@property (strong, nonatomic) IBOutlet UILabel *numLabel;

@property (strong, nonatomic) IBOutlet UILabel *roadPeriodLabel;

@property (strong, nonatomic) IBOutlet UILabel *offsetNameLabel;


@property (nonatomic ,strong) WCIntersectionInfo * info ;

@end
