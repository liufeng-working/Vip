//
//  NSMutableAttributedString+Extensions.h
//  VIP
//
//  Created by 万存 on 16/3/22.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Extensions)

-(NSMutableAttributedString *)attributeStringWithFontSize:(CGFloat)fontSize
                                                 fontName:(NSString *)fontName
                                              inputString:(NSMutableAttributedString *)inpusStr
                                                    color:(NSString *)color
                                                    range:(NSRange)range;

@end
