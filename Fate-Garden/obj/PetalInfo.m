//
//  PetalInfo.m
//  Fate-Garden
//
//  Created by Rui Du on 1/19/13.
//  Copyright (c) 2013 Rui Du. All rights reserved.
//

#import "PetalInfo.h"
#define POS_CODER @"PosCoder"
#define IMAGE_CODER @"ImageCoder"
#define COLOR_CODER @"ColorCoder"
#define OP_CODER @"OpCoder"

@implementation PetalInfo
@synthesize pos = _pos;
@synthesize desc_image = _desc_image;
@synthesize option = _option;

- (PetalInfo *)initWithPos:(PetalPosition)pos
                desc_image:(UIImage *)desc_image
                desc_color:(NSString *)desc_color
                    option:(NSString *)option
{
    self = [super init];
    if (!self) return self;
    
    self.pos = pos;
    self.desc_image = desc_image;
    self.desc_color = desc_color;
    self.option = option;
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.pos = [aDecoder decodeInt32ForKey:POS_CODER];
    self.desc_image = [aDecoder decodeObjectForKey:IMAGE_CODER];
    self.desc_color = [aDecoder decodeObjectForKey:COLOR_CODER];
    self.option = [aDecoder decodeObjectForKey:OP_CODER];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt32:self.pos forKey:POS_CODER];
    [aCoder encodeObject:self.desc_image forKey:IMAGE_CODER];
    [aCoder encodeObject:self.desc_color forKey:COLOR_CODER];
    [aCoder encodeObject:self.option forKey:OP_CODER];
}

- (id)copyWithZone:(NSZone *)zone
{
    PetalInfo *petal_info_copy = [[PetalInfo alloc] init];
    petal_info_copy.pos = self.pos;
    petal_info_copy.desc_image = [self.desc_image copy];
    petal_info_copy.desc_color = [NSString stringWithFormat:@"%@", self.desc_color];
    petal_info_copy.option = [NSString stringWithFormat:@"%@", self.option];
    
    return petal_info_copy;
}

@end
