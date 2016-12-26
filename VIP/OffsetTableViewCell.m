//
//  OffsetTableViewCell.m
//  VIP
//
//  Created by 万存 on 16/3/25.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "OffsetTableViewCell.h"
@interface OffsetTableViewCell()

@end
@implementation OffsetTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)buttonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(offsetCellClicked:)]) {
        [self.delegate offsetCellClicked:self] ;
    }
}
-(void)setInfo:(WCIntersectionInfo *)info{
    self.roadPeriodLabel.text = info.intersectionName ;
}


@end
