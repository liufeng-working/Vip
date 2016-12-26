//
//  PresentOverUsedCell.m
//  VIP
//
//  Created by 万存 on 16/3/28.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "PresentOverUsedCell.h"
#import "WCRoadLineView.h"
#import "WCLineInfo.h"
#import "WCIntersections.h"
@interface PresentOverUsedCell ()


@property (strong, nonatomic) IBOutlet WCRoadLineView *roadView;

@end

@implementation PresentOverUsedCell

- (void)awakeFromNib {
    // Initialization code
    
    self.roadView.width = 725-40;
//    self.roadView.nameArr = @[
//                                   
//                                   @"清水亭西/",
//                                   @"吉印大道/",
//                                   @"金鑫东路/",
//                                   @"清水亭西/",
//                                   @"清水亭西/",
//                                   @"清水亭西/",
//                                   @"清水亭西/",
//                                   @"清水亭西/",
//                                   @"苏源大道/",
//                                   @"秣周东路/",
//                                   @"清水西苑/",
//                                   @"清水亭西/",
//                                   @"吉印大道/",
//                                   @"金鑫东路/",
//                                   @"清水亭西/",
//                                   @"清水亭西/",
//                                   @"清水亭西/",
//                                   @"清水亭西/",
//                                   @"清水亭西/",
//                                   @"苏源大道/",
//                                   @"秣周东路/",
//                                   @"清水西苑/"
//                                   ];
    //默认
    self.roadView.roadLineViewType = WCRoadLineViewTypeSenvenName;
    //默认
    self.roadView.count = 7;

}
-(void)setInfo:(WCLineInfo *)info{
    NSDictionary * dic =[WCIntersections getAllInteractions] ;
    NSArray * lineInfo = [info.intersections componentsSeparatedByString:@","];
    NSMutableArray * priodRoadNameArr =[NSMutableArray array] ;
    for (int i = 0; i<lineInfo.count; i++) {
        NSDictionary * contentDic = dic [lineInfo[i]];
        if (contentDic) {
            [priodRoadNameArr addObject:contentDic[@"intersectionName"]];
        }
    }
    self.lineNameLabel.text = info.lineName;
    self.roadView.nameArr = priodRoadNameArr ;
    [self.roadView settingRoadLine];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
