//
//  UIImagePickerController+WCLandscape.m
//  VIP
//
//  Created by NJWC on 16/4/7.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "UIImagePickerController+WCLandscape.h"

@implementation UIImagePickerController (WCLandscape)

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end
