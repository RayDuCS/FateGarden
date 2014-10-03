//
//  UICustomFont.h
//  Guess
//
//  Created by Rui Du on 9/10/12.
//  Copyright (c) 2012 Slidea Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    FONT_YOUYUAN = 1,     //幼圆
    FONT_KAITI = 2,       //楷体
    FONT_HUAKANG = 3,     //华康
    FONT_JIANCULIANG = 4, //简粗靓
    FONT_FANGZHENG = 5,   //方正卡通
    FONT_FANGZHENG_XINGHEI = 6,   //方正行黑
}FontType;

@interface UICustomFont : NSObject

+ (UIFont *)fontWithFontType:(FontType)type
                        size:(CGFloat)size;

@end
