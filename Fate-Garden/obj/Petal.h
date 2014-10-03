//
//  Petal.h
//  Fate-Garden
//
//  Created by Rui Du on 1/15/13.
//  Copyright (c) 2013 Rui Du. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PetalInfo.h"

typedef enum
{
    PETAL_STATE_IDLE           = 1,
    PETAL_STATE_SHAKING        = 2,
    PETAL_STATE_SHAKING_MOVING = 3,
}PetalState;



@interface Petal : NSObject

@property (nonatomic, strong) UIView *view;
@property (nonatomic) CGRect init_frame;
@property (nonatomic) CGRect dest_frame;
@property (nonatomic) PetalState state;
@property (nonatomic) PetalPosition pos;

- (Petal *)initWithInitFrame:(CGRect)init_frame
                   destFrame:(CGRect)dest_frame
                        view:(UIView *)view
                         pos:(PetalPosition)pos;
- (void)reset;
- (void)shake;
- (UIColor *)get_petal_color;

@end
