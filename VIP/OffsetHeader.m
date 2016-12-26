//
//  OffsetHeader.m
//  VIP
//
//  Created by 万存 on 16/3/25.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "OffsetHeader.h"

@implementation OffsetHeader
 
+(instancetype)loadHeaderView{
    OffsetHeader * header = [[NSBundle mainBundle] loadNibNamed:@"OffsetHeader" owner:self options:nil][0];
    
    return header;
    
}

@end
