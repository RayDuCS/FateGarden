//
//  UICustomFont.m
//  Guess
//
//  Created by Rui Du on 9/10/12.
//  Copyright (c) 2012 Slidea Limited. All rights reserved.
//

#import "UICustomFont.h"

@implementation UICustomFont

+ (UIFont *)fontWithFontType:(FontType)type
                        size:(CGFloat)size
{
    // Personal Fonts:
    // Youyuan
    // KaiTi
    // DFPHaiBaoW12-GB -- 华康
    // GJJCuQian-M17S  -- 简粗靓
    // FZKaTong-M19S   -- 方正卡通
    // FZXingHeiS-R-GB -- 方正行黑
    
    switch (type) {
        case FONT_KAITI:
            return [UIFont fontWithName:@"Kaiti" size:size];
            
        case FONT_YOUYUAN:
            return [UIFont fontWithName:@"Youyuan" size:size];
            
        case FONT_HUAKANG:
            return [UIFont fontWithName:@"DFPHaiBaoW12-GB" size:size];
            
        case FONT_JIANCULIANG:
            return [UIFont fontWithName:@"GJJCuQian-M17S" size:size];
        
        case FONT_FANGZHENG:
            return [UIFont fontWithName:@"FZKaTong-M19S" size:size];
        case FONT_FANGZHENG_XINGHEI:
            return [UIFont fontWithName:@"FZXingHeiS-R-GB" size:size];
    }
}

@end
