//
//  PetalInfo.h
//  Fate-Garden
//
//  Created by Rui Du on 1/19/13.
//  Copyright (c) 2013 Rui Du. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    PETAL_UP_LEFT = 1,
    PETAL_DOWN_RIGHT = 2,
    PETAL_UP = 3,
    PETAL_DOWN_LEFT = 4,
    PETAL_UP_RIGHT = 5,
    PETAL_DOWN = 6,
}PetalPosition; /* These values are dependent inside OptionViewController */


@interface PetalInfo : NSObject<NSCoding, NSCopying>

@property (nonatomic) PetalPosition pos;
@property (strong, nonatomic) UIImage *desc_image;
@property (strong, nonatomic) NSString *option;
@property (strong, nonatomic) NSString *desc_color;

- (PetalInfo *)initWithPos:(PetalPosition)pos
                desc_image:(UIImage *)desc_image
                desc_color:(NSString *)desc_color
                    option:(NSString *)option;

@end
