//
//  UICustomColor.m
//  Guess
//
//  Created by Rui Du on 10/7/12.
//  Copyright (c) 2012 Slidea Limited. All rights reserved.
//

#import "UICustomColor.h"

@implementation UICustomColor

+ (UIColor *)colorWithRedValue:(float)red
                    greenValue:(float)green
                     blueValue:(float)blue
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}

+ (UIColor *)colorWithType:(UICustomColorType)type
{
    switch (type) {
        case UI_CUSTOM_COLOR_GOLD:
            return [UICustomColor colorWithRedValue:255 greenValue:215 blueValue:0];
        case UI_CUSTOM_COLOR_STEEL_BLUE:
            return [UICustomColor colorWithRedValue:99 greenValue:184 blueValue:255];
        case UI_CUSTOM_COLOR_CADE_BLUE:
            return [UICustomColor colorWithRedValue:155 greenValue:245 blueValue:255];
        case UI_CUSTOM_COLOR_GOLDENROD:
            return [UICustomColor colorWithRedValue:218 greenValue:165 blueValue:32];
        case UI_CUSTOM_COLOR_WHITE:
            return [UICustomColor colorWithRedValue:255 greenValue:255 blueValue:255];
        case UI_CUSTOM_COLOR_STEEL_BLUE_2:
            return [UICustomColor colorWithRedValue:92 greenValue:172 blueValue:238];
        case UI_CUSTOM_COLOR_YELLOW1:
            return [UICustomColor colorWithRedValue:255 greenValue:255 blueValue:0];
        case UI_CUSTOM_COLOR_DARKSEAGREEN1:
            return [UICustomColor colorWithRedValue:193 greenValue:255 blueValue:193];
        case UI_CUSTOM_COLOR_GRAY81:
            return [UICustomColor colorWithRedValue:207 greenValue:207 blueValue:207];
        case UI_CUSTOM_COLOR_LIGHT_GOLDENROD:
            return [UICustomColor colorWithRedValue:255 greenValue:236 blueValue:139];
        case UI_CUSTOM_COLOR_PINK1:
            return [UICustomColor colorWithRedValue:255 greenValue:181 blueValue:197];
        case UI_CUSTOM_COLOR_WHEAT2:
            return [UICustomColor colorWithRedValue:255 greenValue:231 blueValue:186];
        case UI_CUSTOM_COLOR_SPRINGGREEN:
            return [UICustomColor colorWithRedValue:0 greenValue:255 blueValue:127];
        case UI_CUSTOM_COLOR_DARK_ORANGE1:
            return [UICustomColor colorWithRedValue:255 greenValue:127 blueValue:0];
        case UI_CUSTOM_COLOR_TURQUOISE_3:
            return [UICustomColor colorWithRedValue:0 greenValue:197 blueValue:205];
        case UI_CUSTOM_COLOR_GOLD_2:
            return [UICustomColor colorWithRedValue:238 greenValue:201 blueValue:0];
        case UI_CUSTOM_COLOR_BROWN_1:
            return [UICustomColor colorWithRedValue:255 greenValue:64 blueValue:64];
        case UI_CUSTOM_COLOR_SGI_SLATEBLUE:
            return [UICustomColor colorWithRedValue:113 greenValue:113 blueValue:198];
        case UI_CUSTOM_COLOR_ORANGERED_2:
            return [UICustomColor colorWithRedValue:238 greenValue:64 blueValue:0];
        case UI_CUSTOM_COLOR_VIOLETRED_1:
            return [UICustomColor colorWithRedValue:255 greenValue:62 blueValue:150];
            
    }
}

@end
