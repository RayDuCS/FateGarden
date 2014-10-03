//
//  Theme.m
//  Fate-Garden
//
//  Created by Xiaoxuan Zhang on 1/18/13.
//  Copyright (c) 2013 Rui Du. All rights reserved.
//

#import "Theme.h"
#import "PetalInfo.h"

#define TITLE_CODER @"TitleCoder"
#define OPTION_CODER @"OptionCoder"
#define COUNT_CODER @"CountCoder"

@interface Theme()

@end

@implementation Theme
@synthesize options = _options;
@synthesize title = _title;
@synthesize count = _count;

- (Theme *)initWithTitle:(NSString *)title
                 options:(NSDictionary *)options
                   count:(int)count
{
    self = [super init];
    if (!self) return self;
    
    self.title = title;
    self.options = [options copy];
    self.count = count;
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.title = [aDecoder decodeObjectForKey:TITLE_CODER];
    self.options = [aDecoder decodeObjectForKey:OPTION_CODER];
    self.count = [aDecoder decodeIntForKey:COUNT_CODER];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:TITLE_CODER];
    [aCoder encodeObject:self.options forKey:OPTION_CODER];
    [aCoder encodeInt:self.count forKey:COUNT_CODER];
}

- (id)copyWithZone:(NSZone *)zone
{
    Theme *theme_copy = [[Theme alloc] init];
    theme_copy.title = [self.title copyWithZone:zone];
    theme_copy.count = self.count;
    
    NSMutableArray *array_keys = [[NSMutableArray alloc] init];
    NSMutableArray *array_items = [[NSMutableArray alloc] init];
    for (NSString *key in self.options) {
        [array_keys addObject:[NSString stringWithFormat:@"%@", key]];
        PetalInfo *info = [self.options objectForKey:key];
        PetalInfo *info_copy = [[PetalInfo alloc] initWithPos:info.pos
                                                   desc_image:info.desc_image
                                                   desc_color:info.desc_color
                                                       option:[NSString stringWithFormat:@"%@", info.option]];
        [array_items addObject:info_copy];
    }
    
    NSDictionary *dict_copy = [NSDictionary dictionaryWithObjects:array_items forKeys:array_keys];
    theme_copy.options = dict_copy;
    
    return theme_copy;
}

- (BOOL)isEqualToTheme:(Theme *)theme
{
    if (![self.title isEqualToString:theme.title]) return FALSE;
    if (self.count != theme.count) return FALSE;
    
    for (id key in self.options)
    {
        PetalInfo *info = [self.options objectForKey:key];
        PetalInfo *other = [theme.options objectForKey:key];
        if (![info.option isEqualToString:other.option])
            return FALSE;
    }
    
    return TRUE;
}

- (BOOL)fillOptions:(int)numberOfPetals
{
    PetalInfo *up_left_info = [self.options objectForKey:[NSString stringWithFormat:@"%d", PETAL_UP_LEFT]];
    PetalInfo *up_right_info = [self.options objectForKey:[NSString stringWithFormat:@"%d", PETAL_UP_RIGHT]];
    PetalInfo *up_info = [self.options objectForKey:[NSString stringWithFormat:@"%d", PETAL_UP]];
    PetalInfo *down_left_info = [self.options objectForKey:[NSString stringWithFormat:@"%d", PETAL_DOWN_LEFT]];
    PetalInfo *down_right_info = [self.options objectForKey:[NSString stringWithFormat:@"%d", PETAL_DOWN_RIGHT]];
    PetalInfo *down_info = [self.options objectForKey:[NSString stringWithFormat:@"%d", PETAL_DOWN]];
    
    if (numberOfPetals == 2) {
        up_left_info.option = [NSString stringWithFormat:@"%@", up_left_info.desc_color];
        down_right_info.option = [NSString stringWithFormat:@"%@", down_right_info.desc_color];
        
        return TRUE;
    } else if (numberOfPetals == 3) {
        up_left_info.option = [NSString stringWithFormat:@"%@", up_left_info.desc_color];
        down_right_info.option = [NSString stringWithFormat:@"%@", down_right_info.desc_color];
        up_info.option = [NSString stringWithFormat:@"%@", up_info.desc_color];
        
        return TRUE;
    } else if (numberOfPetals == 4) {
        up_left_info.option = [NSString stringWithFormat:@"%@", up_left_info.desc_color];
        down_right_info.option = [NSString stringWithFormat:@"%@", down_right_info.desc_color];
        up_info.option = [NSString stringWithFormat:@"%@", up_info.desc_color];
        down_left_info.option = [NSString stringWithFormat:@"%@", down_left_info.desc_color];
        
        return TRUE;
    } else if (numberOfPetals == 5) {
        up_left_info.option = [NSString stringWithFormat:@"%@", up_left_info.desc_color];
        down_right_info.option = [NSString stringWithFormat:@"%@", down_right_info.desc_color];
        up_info.option = [NSString stringWithFormat:@"%@", up_info.desc_color];
        down_left_info.option = [NSString stringWithFormat:@"%@", down_left_info.desc_color];
        up_right_info.option = [NSString stringWithFormat:@"%@", up_right_info.desc_color];
        
        return TRUE;
    } else if (numberOfPetals == 6) {
        up_left_info.option = [NSString stringWithFormat:@"%@", up_left_info.desc_color];
        down_right_info.option = [NSString stringWithFormat:@"%@", down_right_info.desc_color];
        up_info.option = [NSString stringWithFormat:@"%@", up_info.desc_color];
        down_left_info.option = [NSString stringWithFormat:@"%@", down_left_info.desc_color];
        up_right_info.option = [NSString stringWithFormat:@"%@", up_right_info.desc_color];
        down_info.option = [NSString stringWithFormat:@"%@", down_info.desc_color];
        
        return TRUE;
    }
    
    return FALSE;
}

@end
