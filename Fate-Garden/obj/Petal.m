//
//  Petal.m
//  Fate-Garden
//
//  Created by Rui Du on 1/15/13.
//  Copyright (c) 2013 Rui Du. All rights reserved.
//

#import "Petal.h"
#import "UICustomColor.h"

@interface Petal()
@property (atomic, strong) NSLock *petalLock;
@end

@implementation Petal
@synthesize init_frame = _init_frame;
@synthesize dest_frame = _dest_frame;
@synthesize view = _view;
@synthesize state = _state;
@synthesize pos = _pos;
@synthesize petalLock = _petalLock;

- (Petal *)initWithInitFrame:(CGRect)init_frame
                   destFrame:(CGRect)dest_frame
                        view:(UIView *)view
                         pos:(PetalPosition)pos
{
    self = [super init];
    
    if (!self) return self;
    
    self.init_frame = init_frame;
    self.dest_frame = dest_frame;
    self.view = view;
    self.state = PETAL_STATE_IDLE;
    self.pos = pos;
    self.petalLock = [[NSLock alloc] init];
    
    return self;
}

- (void)reset
{
    self.state = PETAL_STATE_IDLE;
    self.view.frame = self.init_frame;
    self.view.alpha = 1;
}

/*
 * Animate the shake event of a Petal
 * The full animation consist of 2 part, 
 * 1. Shake the petal slightly, up and down, consistently
 * 2. Move the petal off the Pedicel.
 */
- (void)shake
{
    self.state = PETAL_STATE_SHAKING;
    
    int amount = 20; // the total animation time = 0.07 * 3 * amount   -- 4.2s
    float freq = ((float)(arc4random() % 6))/100; // the freq for this petal to shake
    float delay = ((float)(arc4random() % 5))/10 +0.5f; // delay for when this petal should leave pistle
    
    [self shakeWithDuration:0.07 delay:freq amount:amount radian:M_PI*2/180];
    [self removeOffPedicelWithDelay:delay];
}

- (void)removeOffPedicelWithDelay:(float)delay
{
    [UIView animateWithDuration:1
                          delay:delay
                        options:UIViewAnimationOptionCurveLinear
                     animations:^(){
                         if (self.state == PETAL_STATE_IDLE) return;
                         
                         self.state = PETAL_STATE_SHAKING_MOVING;
                         self.view.center = self.dest_frame.origin;
                     }
                     completion:^(BOOL finished){
                         if (self.state == PETAL_STATE_IDLE) return;
                         if (!finished) return;
                         
                         self.state = PETAL_STATE_SHAKING;
                         self.view.alpha = 0;
                     }];

}

- (void)shakeWithDuration:(float)duration
                    delay:(float)delay
                    amount:(int)amount
                   radian:(float)radian
{
    [UIView animateWithDuration:duration - delay
                          delay:delay
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         /* Rotate up */
                         self.view.transform = CGAffineTransformMakeRotation(radian);
                     }
                     completion:^(BOOL finished) {
                         if (!finished || self.state == PETAL_STATE_IDLE) {
                             self.view.transform = CGAffineTransformMakeRotation(-radian);
                             return;
                         }
                         
                         [UIView animateWithDuration:duration - delay
                                               delay:delay
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              /* Rotate down */
                                              self.view.transform = CGAffineTransformMakeRotation(-radian*2);
                                          }
                                          completion:^(BOOL finished){
                                              if (!finished || self.state == PETAL_STATE_IDLE) {
                                                  self.view.transform = CGAffineTransformMakeRotation(radian);
                                                  return;
                                              }
                                              
                                              [UIView animateWithDuration:duration - delay
                                                                    delay:delay
                                                                  options:UIViewAnimationOptionCurveLinear
                                                               animations:^{
                                                                   /* Rotate back to start pos */
                                                                   self.view.transform = CGAffineTransformMakeRotation(radian);
                                                               }
                                                               completion:^(BOOL finished){
                                                                   if (!finished || self.state == PETAL_STATE_IDLE) {
                                                                       return;
                                                                   }
                                                                   
                                                                   if (amount > 0) [self shakeWithDuration:duration delay:delay amount:amount-1 radian:radian];
                                                                   else {
                                                                       self.state = PETAL_STATE_IDLE;
                                                                   }
                                                               }];
                                          }];
                     }];
}

- (UIColor *)get_petal_color
{
    switch (self.pos) {
        case PETAL_UP:
            return [UICustomColor colorWithType:UI_CUSTOM_COLOR_GOLD_2];
        case PETAL_UP_RIGHT:
            return [UICustomColor colorWithType:UI_CUSTOM_COLOR_BROWN_1];
        case PETAL_DOWN_RIGHT:
            return [UICustomColor colorWithType:UI_CUSTOM_COLOR_SGI_SLATEBLUE];
        case PETAL_DOWN:
            return [UICustomColor colorWithType:UI_CUSTOM_COLOR_ORANGERED_2];
        case PETAL_DOWN_LEFT:
            return [UICustomColor colorWithType:UI_CUSTOM_COLOR_VIOLETRED_1];
        case PETAL_UP_LEFT:
            return [UICustomColor colorWithType:UI_CUSTOM_COLOR_TURQUOISE_3];
    }
}

@end
