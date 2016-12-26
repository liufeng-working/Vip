//
//  NSMutableAttributedString+Extensions.m
//  VIP
//
//  Created by 万存 on 16/3/22.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "NSMutableAttributedString+Extensions.h"

@implementation NSMutableAttributedString (Extensions)
-(NSMutableAttributedString *)attributeStringWithFontSize:(CGFloat)fontSize
                                                 fontName:(NSString *)fontName
                                              inputString:(NSMutableAttributedString *)inpusStr
                                                    color:(NSString *)color
                                                    range:(NSRange)range{
    if (color) {
        [inpusStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:color]}range:range];

    }
    if (fontSize && fontName) {
        [inpusStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:fontName size:fontSize]} range:range];
    }else if (fontSize){
        [inpusStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} range:range];
    }
    return inpusStr;
}
@end
